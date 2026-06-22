import 'package:flsosy/data/models/coin_detail.dart';
import 'package:flsosy/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// Widget displaying the current price and 24h change.
class PriceSection extends StatelessWidget {
  const PriceSection({required this.detail, super.key});

  final CoinDetail detail;

  @override
  Widget build(BuildContext context) {
    final isPositive = detail.percentChange24h >= 0;
    final changeColor = isPositive
        ? context.colors.accentNeonCyberGreen
        : context.colors.neutralMutedSilverGray;
    final changePrefix = isPositive ? '+' : '';

    return Column(
      children: [
        // Large price display
        Text(
          '\$${_formatPrice(detail.price)}',
          style: context.fonts.headlineLg.copyWith(
            color: context.colors.pureWhite,
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        // 24h change chip
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$changePrefix${detail.percentChange24h.toStringAsFixed(2)}%',
              style: context.fonts.bodyLg.copyWith(
                color: changeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              context.strings?.today ?? '',
              style: context.fonts.bodyLg.copyWith(
                color: context.colors.neutralMutedSilverGray,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Formats a price with appropriate precision and optional commas.
  String _formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    }
    if (price >= 1) return price.toStringAsFixed(2);
    if (price >= 0.01) return price.toStringAsFixed(4);
    return price.toStringAsFixed(6);
  }
}
