import 'package:flsosy/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(left: 48.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: context.colors.surfaceBright,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            text,
            style: context.fonts.bodyLg.copyWith(
              color: context.colors.pureWhite,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.strings?.sosynIntelligence ?? 'SOSYN INTELLIGENCE',
            style: context.fonts.labelMd.copyWith(
              color: context.colors.accentNeonCyberGreen,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            margin: const EdgeInsets.only(right: 48.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: context.colors.coinLogoBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: context.colors.borderGreen.withValues(alpha: 0.5),
                width: 1.0,
              ),
            ),
            child: Text(
              text,
              style: context.fonts.bodyLg.copyWith(
                color: context.colors.pureWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
