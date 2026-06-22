import 'package:flsosy/extensions/context_extensions.dart';
import 'package:flsosy/pages/home/coin_detail/coin_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flsosy/data/models/coin_model.dart';
import 'package:flsosy/widgets/coin_logo_widget.dart';

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
            CoinLogoWidget(imageUrl: coin.imageUrl),
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
