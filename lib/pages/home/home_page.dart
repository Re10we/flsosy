import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.strings?.market ?? '',
              style: context.fonts.headlineLg.copyWith(
                color: context.colors.pureWhite,
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for market list
            Text(
              "Market data will be displayed here.",
              style: context.fonts.bodyLg.copyWith(
                color: context.colors.neutralMutedSilverGray,
              ),
            ),
          ],
        ),
      );
}
