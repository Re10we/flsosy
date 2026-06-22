import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';
import '../../data/models/coin_model.dart';
import '../../isar/isar_service.dart';
import '../../widgets/coin_logo_widget.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CoinModel>>(
      stream: IsarService.instance.watchFavorites(),
      builder: (context, snapshot) {
        final favorites = snapshot.data ?? [];
        if (favorites.isEmpty) {
          // Empty watchlist UI (unchanged design).
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.colors.pureWhite.withValues(alpha: 0.05),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: context.colors.accentHeaderGreen.withValues(
                      alpha: 0.1,
                    ),
                  ),
                  child: Icon(
                    Icons.star_border,
                    size: 52,
                    color: context.colors.neutralMutedSilverGray
                        .withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 40),

                /// Your watchlist is empty
                Text(
                  context.strings?.yourWatchlistIsEmpty ?? '',
                  textAlign: TextAlign.center,
                  style: context.fonts.headlineLgMobile,
                ),
                const SizedBox(height: 8),

                /// Tap the star icon on the Market tab to track your favorite coins and assets in real-time.

                Text(
                  context.strings
                          ?.tapTheStarIconOnTheMarketTabToTrackYourFavoriteCoins ??
                      '',
                  textAlign: TextAlign.center,
                  style: context.fonts.bodyLg
                      .copyWith(color: context.colors.neutralMutedSilverGray),
                ),
              ],
            ),
          );
        }
        // Populated watchlist UI.
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: favorites.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final coin = favorites[index];

            final isPositive = (coin.percentChange24h) >= 0;
            final percentageSign = isPositive ? '+' : '';
            final percentageColor = isPositive
                ? context.colors.accentNeonCyberGreen
                : Colors.redAccent;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: context.colors.accentHeaderGreen.withValues(alpha: 0.6),
                border: Border.all(
                  color: context.colors.neutralMutedSilverGray
                      .withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CoinLogoWidget(imageUrl: coin.imageUrl),

                  const SizedBox(width: 16),

                  /// Info coin
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Symbol coin
                        Text(
                          coin.symbol.toUpperCase(),
                          style: context.fonts.bodyLg.copyWith(
                            color: context.colors.pureWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),

                        /// Name coin
                        Text(
                          coin.name,
                          style: context.fonts.bodySm.copyWith(
                            color: context.colors.neutralMutedSilverGray,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Price section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Price coin
                      Text(
                        '\$${coin.price.toStringAsFixed(2)}',
                        style: context.fonts.bodyLg.copyWith(
                          color: context.colors.pureWhite,
                        ),
                      ),
                      const SizedBox(height: 2),

                      /// Percentage change coin
                      Text(
                        '$percentageSign${coin.percentChange24h.toStringAsFixed(2)}%',
                        style: context.fonts.bodySm.copyWith(
                          color: percentageColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  /// Remove favorite icon
                  GestureDetector(
                    onTap: () => _onRemoveFavorite(coin),
                    child: Icon(
                      Icons.star,
                      color: context.colors.accentNeonCyberGreen,
                      size: 26,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onRemoveFavorite(CoinModel coin) async =>
      await IsarService.instance.removeFavorite(coin.id);
}
