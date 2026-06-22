import 'package:flsosy/data/models/coin_detail.dart';
import 'package:flsosy/extensions/context_extensions.dart';
import 'package:flsosy/isar/isar_service.dart';

import 'package:flsosy/pages/home/coin_detail/bloc/coin_detail_bloc.dart';
import 'package:flsosy/pages/home/coin_detail/bloc/coin_detail_event.dart';
import 'package:flsosy/pages/home/coin_detail/bloc/coin_detail_state.dart';
import 'package:flsosy/pages/home/coin_detail/widgets/coin_chart_widget.dart';

import 'package:flsosy/pages/home/coin_detail/widgets/price_section_widget.dart';
import 'package:flsosy/pages/home/coin_detail/widgets/metrics_grid_widget.dart';
import 'package:flsosy/pages/home/widgets/first_page_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/coin_model.dart';

class CoinDetailPage extends StatefulWidget {
  const CoinDetailPage({super.key, required this.coin});

  final CoinModel coin;

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<CoinDetailBloc>(
        create: (_) => CoinDetailBloc()
          ..add(CoinDetailFetchRequested(coinId: int.parse(widget.coin.id))),
        child: Scaffold(
          backgroundColor: context.colors.baseObsidianBlack,
          appBar: AppBar(
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.coin.name,
                  style: context.fonts.titleMd.copyWith(
                    color: context.colors.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${widget.coin.symbol} / USD',
                  style: context.fonts.labelMd.copyWith(
                    color: context.colors.neutralMutedSilverGray,
                  ),
                ),
              ],
            ),
          ),
          body: BlocBuilder<CoinDetailBloc, CoinDetailState>(
            builder: (context, state) {
              return switch (state) {
                CoinDetailLoading() => _buildLoading(context),
                CoinDetailLoaded(:final detail) =>
                  _buildLoaded(context, detail),
                CoinDetailError() => _buildError(context),
                _ => _buildLoading(context),
              };
            },
          ),
        ),
      );

  Future<void> _loadFavoriteStatus() async {
    final isFav = await IsarService.instance.isFavorite(widget.coin.id);
    if (mounted) setState(() => _isFavorite = isFav);
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await IsarService.instance.removeFavorite(widget.coin.id);
    } else {
      await IsarService.instance.addFavorite(widget.coin);
    }
    if (mounted) setState(() => _isFavorite = !_isFavorite);
  }

  // ── States ────────────────────────────────────────────────────────────────

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.colors.accentNeonCyberGreen,
        strokeWidth: 1.5,
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return FirstPageError(
      onRetry: () => context.read<CoinDetailBloc>().add(
            CoinDetailFetchRequested(
              coinId: int.parse(widget.coin.id),
            ),
          ),
    );
  }

  Widget _buildLoaded(BuildContext context, CoinDetail detail) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ///price section
            PriceSection(detail: detail),

            const SizedBox(height: 24),

            ///chart
            CoinChartWidget(
              currentPrice: detail.price,
              percentChange24h: detail.percentChange24h,
            ),

            const SizedBox(height: 28),

            ///metrics grid
            MetricsGrid(detail: detail),

            const SizedBox(height: 32),

            OutlinedButton(
              onPressed: _toggleFavorite,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: context.colors.pureWhite,
                backgroundColor: _isFavorite
                    ? Colors.redAccent.withValues(alpha: 0.5)
                    : context.colors.accentNeonCyberGreen
                        .withValues(alpha: 0.5),
                textStyle: context.fonts.labelMd,
              ),
              child: Text(
                ((_isFavorite
                            ? context.strings?.removeFromFavorites
                            : context.strings?.addToFavorites) ??
                        '')
                    .toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
