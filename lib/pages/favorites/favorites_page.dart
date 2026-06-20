import "package:flutter/material.dart";
import "package:flsosy/style/fonts.dart";
import "package:flsosy/style/colors.dart";

import "../../extensions/context_extensions.dart";

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = SFont();
    final colors = SColors();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_border,
            size: 64,
            color: colors.neutralMutedSilverGray,
          ),
          const SizedBox(height: 16),
          Text(
            context.strings?.watchlistEmpty ?? '',
            textAlign: TextAlign.center,
            style: typography.bodyLg
                .copyWith(color: colors.neutralMutedSilverGray),
          ),
        ],
      ),
    );
  }
}
