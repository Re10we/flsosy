import 'package:flsosy/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class MetricCardWidget extends StatelessWidget {
  const MetricCardWidget({
    super.key,
    required this.label,
    required this.value,
  });

  /// Short uppercase label, e.g. "MARKET CAP".
  final String label;

  /// Formatted value string, e.g. "\$1.27T".
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: context.colors.accentHeaderGreen.withValues(alpha: 0.8),
        border: Border.all(
          color: context.colors.neutralMutedSilverGray.withValues(alpha: 0.18),
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Uppercase muted label row
          Text(
            label.toUpperCase(),
            style: context.fonts.labelMd.copyWith(
              color: context.colors.neutralMutedSilverGray,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          /// Bold value in white
          Text(
            value,
            style: context.fonts.titleMd.copyWith(
              color: context.colors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
