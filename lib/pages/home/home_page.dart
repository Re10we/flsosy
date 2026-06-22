import 'package:flsosy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'dart:async';

import '../../data/models/coin_model.dart';
import '../../extensions/context_extensions.dart';
import 'bloc/coin_market_bloc.dart';
import 'widgets/coin_item_widget.dart';
import 'widgets/first_page_error_widget.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<bool>? isBotOpenNotifier;
  const HomePage({super.key, this.isBotOpenNotifier});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PagingController<int, CoinModel> _pagingController;
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    _initPagingController();
    _startTimer();
    widget.isBotOpenNotifier?.addListener(_onBotOpenChanged);
  }

  void _onBotOpenChanged() {
    if (widget.isBotOpenNotifier?.value == true) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _pagingController.refresh();
    });
  }

  void _stopTimer() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  @override
  void dispose() {
    widget.isBotOpenNotifier?.removeListener(_onBotOpenChanged);
    _stopTimer();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PagingListener(
        controller: _pagingController,
        builder: (_, state, __) => PagedListView<int, CoinModel>(
          state: state,
          fetchNextPage: _pagingController.fetchNextPage,
          padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
          builderDelegate: PagedChildBuilderDelegate<CoinModel>(
            itemBuilder: (_, coin, __) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CoinItemWidget(coin: coin),
            ),
            firstPageProgressIndicatorBuilder: (_) => Center(
              child: CircularProgressIndicator(
                color: context.colors.accentNeonCyberGreen,
                strokeWidth: 1.5,
              ),
            ),
            firstPageErrorIndicatorBuilder: (_) => FirstPageError(
              onRetry: _pagingController.refresh,
            ),
            noItemsFoundIndicatorBuilder: (_) => Center(
              child: Text(
                context.strings?.noCoinsFound ?? 'No coins found.',
                style: context.fonts.bodyLg.copyWith(
                  color: context.colors.neutralMutedSilverGray,
                ),
              ),
            ),
          ),
        ),
      );

  void _initPagingController() {
    _pagingController = PagingController<int, CoinModel>(
      // Wrap the BLoC call in a timeout so that a hung request throws a
      // TimeoutException after 15 seconds. ISP catches this and routes it
      // to firstPageErrorIndicatorBuilder instead of spinning forever.
      fetchPage: (int pageKey) => context
          .read<CoinMarketBloc>()
          .fetchPage(pageKey)
          .timeout(const Duration(seconds: 15)),

      // ISP calls this after every successful fetch to determine the key for
      // the next page. Returning null signals "end of list".
      getNextPageKey: (PagingState<int, CoinModel> state) {
        final pages = state.pages;

        // ── First call: no pages loaded yet ──────────────────────────────
        // pages is null/empty before the very first fetch completes.
        // We MUST return a non-null key here so ISP actually triggers the
        // first fetch. Returning null would make ISP think pagination is
        // already finished, causing the infinite spinner observed.
        if (pages == null || pages.isEmpty) return 1;

        // ── Last page detection ──────────────────────────────────────────
        // The API has no more data when the last page is shorter than the
        // requested limit. Returning null stops further fetches.
        if (pages.last.length < kPaginationLimit) return null;

        // ── Next page key ────────────────────────────────────────────────
        // CoinMarketCap uses a 1-based start offset, so the next key is
        // (total items fetched so far) + 1.
        final totalItemsFetched =
            pages.fold(0, (sum, page) => sum + page.length);
        return totalItemsFetched + 1;
      },
    );
  }
}
