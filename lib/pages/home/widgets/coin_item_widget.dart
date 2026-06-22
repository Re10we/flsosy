// lib/pages/home/widgets/coin_item_widget.dart

import 'package:flsosy/extensions/context_extensions.dart';
import 'package:flsosy/pages/home/coin_detail/coin_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flsosy/data/models/coin_model.dart';

/// Widget that renders a single [CoinModel] in the market list.
///
/// Tapping the card navigates to [CoinDetailPage] via a standard
/// [MaterialPageRoute] push so the detail page sits on top of the
/// current scaffold (no bottom nav bar visible).
class CoinItemWidget extends StatelessWidget {
  const CoinItemWidget({
    super.key,
    required this.coin,
  });

  final CoinModel coin;

  @override
  Widget build(BuildContext context) {
    // Neon cyber green accent for positive change, muted silver for negative.
    final changeColor = coin.percentChange24h >= 0
        ? context.colors.accentNeonCyberGreen
        : context.colors.neutralMutedSilverGray;

    return GestureDetector(
      // Navigate to the detail page when the card is tapped.
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CoinDetailPage(coin: coin),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: context.colors.accentHeaderGreen.withValues(alpha: 0.6),
          border: Border.all(
            color: context.colors.neutralMutedSilverGray.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Render the coin logo using the logo URL. To ensure UI stability, we use
            // ClipRRect to force a circular boundary (matching the design system),
            // and provide a fallback Bitcoin icon container during loading or error states.

            /// Coin logo
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.colors.coinLogoBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  coin.imageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 40,
                    height: 40,
                    color: context.colors.neutralMutedSilverGray
                        .withValues(alpha: 0.2),
                    child: const Icon(
                      Icons.currency_bitcoin,
                      color: Colors.white70,
                      size: 24,
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 40,
                      height: 40,
                      color: context.colors.neutralMutedSilverGray
                          .withValues(alpha: 0.2),
                      child: const Icon(
                        Icons.currency_bitcoin,
                        color: Colors.white70,
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Coin symbol
                  Text(
                    coin.symbol,
                    style: context.fonts.bodyLg.copyWith(
                      color: context.colors.pureWhite,
                    ),
                  ),

                  /// Coin name
                  Text(
                    coin.name,
                    style: context.fonts.bodyLg.copyWith(
                      color: context.colors.neutralMutedSilverGray,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// Price
                Text(
                  '\$${coin.price.toStringAsFixed(2)}',
                  style: context.fonts.bodyLg.copyWith(
                    color: context.colors.pureWhite,
                  ),
                ),

                /// 24h percent change
                Text(
                  '${coin.percentChange24h >= 0 ? '+' : ''}${coin.percentChange24h.toStringAsFixed(2)}%',
                  style: context.fonts.bodyLg.copyWith(color: changeColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
