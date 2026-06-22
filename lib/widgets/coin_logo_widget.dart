import 'package:flsosy/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class CoinLogoWidget extends StatelessWidget {
  const CoinLogoWidget({
    super.key,
    required this.imageUrl,
    this.size = 40.0,
  });

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colors.coinLogoBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: size,
            height: size,
            color: context.colors.neutralMutedSilverGray.withValues(alpha: 0.2),
            child: Icon(
              Icons.currency_bitcoin,
              color: Colors.white70,
              size: size * 0.6,
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              color: context.colors.neutralMutedSilverGray.withValues(alpha: 0.2),
              child: Icon(
                Icons.currency_bitcoin,
                color: Colors.white70,
                size: size * 0.6,
              ),
            );
          },
        ),
      ),
    );
  }
}
