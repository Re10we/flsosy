import 'package:flsosy/data/models/coin_detail.dart';
import 'package:flsosy/extensions/context_extensions.dart';
import 'package:flsosy/pages/home/coin_detail/widgets/metric_card_widget.dart';
import 'package:flutter/material.dart';

class MetricsGrid extends StatelessWidget {
  const MetricsGrid({required this.detail, super.key});

  final CoinDetail detail;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // Shrink‑wrap so the grid takes only the needed height inside the
      // surrounding Column.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        /// Market Cap
        MetricCardWidget(
          label: context.strings?.marketCap ?? 'Market Cap',
          value: _formatNumber(detail.marketCap, prefix: '\$'),
        ),

        /// 24h High
        MetricCardWidget(
          label: context.strings?.high24h ?? '24h High',
          value: '-',
        ),

        /// 24h Volume
        MetricCardWidget(
          label: context.strings?.volume24h ?? '24h Volume',
          value: _formatNumber(detail.volume24h, prefix: '\$'),
        ),

        /// Supply
        MetricCardWidget(
          label: context.strings?.supply ?? 'Supply',
          value: '${_formatNumber(detail.circulatingSupply)} ${detail.symbol}',
        ),
      ],
    );
  }

  // Helper to format large numbers with commas and a dollar prefix when
  // appropriate. Keeping it inline avoids pulling a utility function from
  // elsewhere, ensuring the widget stays self‑contained.
  String _formatNumber(double value, {String? prefix}) {
    final formatted = value >= 1000
        ? value.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')
        : value.toStringAsFixed(2);
    return '${prefix ?? ''}$formatted';
  }
}
