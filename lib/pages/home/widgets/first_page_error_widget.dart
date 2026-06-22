import 'package:flsosy/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// Full-screen error widget – the design spec "State C" for the Market Dashboard:
/// connection‑lost icon, descriptive text, and a neon "Retry" button.
class FirstPageError extends StatefulWidget {
  const FirstPageError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  State<FirstPageError> createState() => _FirstPageErrorState();
}

class _FirstPageErrorState extends State<FirstPageError>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: SizedBox(
                width: 170,
                height: 170,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      // Dynamic padding: max 20.0 at start, shrinking to 0.0.
                      final currentPadding = (1.0 - _animation.value) * 20.0;
                      return Container(
                        padding: EdgeInsets.all(currentPadding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.colors.accentNeonCyberGreen
                                .withValues(alpha: 0.1),
                          ),
                        ),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              context.colors.pureWhite.withValues(alpha: 0.05),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: context.colors.baseObsidianBlack,
                      ),
                      child: Icon(
                        Icons.wifi_off_rounded,
                        size: 56,
                        color: context.colors.neutralMutedSilverGray
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Error headline with shimmering effect.
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double value = _controller.value;
                final beginX = 2.0 - (value * 4.0);
                final endX = beginX - 2.0;
                return ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment(beginX, 0.0),
                    end: Alignment(endX, 0.0),
                    colors: [
                      context.colors.pureWhite.withValues(alpha: 0.25),
                      context.colors.pureWhite,
                      context.colors.pureWhite.withValues(alpha: 0.25),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ).createShader(bounds),
                  child: child,
                );
              },
              child: Text(
                context.strings?.failedToLoadMarketData ??
                    'Failed to load market data',
                style: context.fonts.headlineLgMobile.copyWith(
                  color: context.colors.pureWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Text(
                context.strings?.errorSecureConnection ?? '',
                style: context.fonts.bodySm.copyWith(
                  color: context.colors.neutralMutedSilverGray,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 64),
            // Neon "Retry" button.
            ElevatedButton(
              onPressed: widget.onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.accentNeonCyberGreen,
                foregroundColor: context.colors.baseObsidianBlack,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                elevation: 0,
              ),
              child: Text(
                (context.strings?.retry ?? 'Retry').toUpperCase(),
                style: context.fonts.labelMd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
