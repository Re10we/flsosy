import 'package:flutter/material.dart';
import 'package:flsosy/style/fonts.dart';
import 'package:flsosy/style/colors.dart';

import '../../extensions/context_extensions.dart';
import '../../data/models/coin_model.dart';
import '../../isar/isar_service.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = SFont();
    final colors = SColors();

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
                    color: colors.neutralMutedSilverGray.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 40),

                /// Your watchlist is empty
                Text(
                  context.strings?.yourWatchlistIsEmpty ?? '',
                  textAlign: TextAlign.center,
                  style: typography.headlineLgMobile,
                ),
                const SizedBox(height: 8),

                /// Tap the star icon on the Market tab to track your favorite coins and assets in real-time.

                Text(
                  context.strings
                          ?.tapTheStarIconOnTheMarketTabToTrackYourFavoriteCoins ??
                      '',
                  textAlign: TextAlign.center,
                  style: typography.bodyLg
                      .copyWith(color: colors.neutralMutedSilverGray),
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
            return ListTile(
              leading: Image.network(
                coin.imageUrl,
                width: 40,
                height: 40,
                errorBuilder: (_, __, ___) => const Icon(Icons.monetization_on),
              ),
              title: Text(
                coin.name,
                style: typography.bodyLg
                    .copyWith(color: colors.neutralMutedSilverGray),
              ),
              subtitle: Text(
                '\\${coin.price.toStringAsFixed(2)}',
                style: typography.bodySm
                    .copyWith(color: colors.accentNeonCyberGreen),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () async =>
                    await IsarService.instance.removeFavorite(coin.id),
              ),
            );
          },
        );
      },
    );
  }
}
