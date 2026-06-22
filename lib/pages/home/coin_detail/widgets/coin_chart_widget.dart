import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flsosy/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class CoinChartWidget extends StatefulWidget {
  const CoinChartWidget({
    super.key,
    required this.currentPrice,
    required this.percentChange24h,
  });

  /// Live price in USD; used as the terminal value of the generated series.
  final double currentPrice;

  /// 24-hour percentage change; drives the overall trend direction of the walk.
  final double percentChange24h;

  @override
  State<CoinChartWidget> createState() => _CoinChartWidgetState();
}

class _CoinChartWidgetState extends State<CoinChartWidget>
    with SingleTickerProviderStateMixin {
  // Currently selected time range — defaults to 1-week to match the design.
  ChartRange _selectedRange = ChartRange.oneWeek;

  // Index of the bar the user is currently touching (-1 = none).
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final spots = _generateSpots(_selectedRange);
    final minY = spots.map((s) => s.y).reduce(math.min);
    final maxY = spots.map((s) => s.y).reduce(math.max);
    // Add 5% padding above/below so the line doesn't clip the widget edges.
    final yPadding = (maxY - minY) * 0.05;

    final neonGreen = context.colors.accentNeonCyberGreen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 220,
          child: LineChart(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            LineChartData(
              // Hide the default grid lines to match the minimal dark design.
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              // Axis range with padding so the curve breathes.
              minY: minY - yPadding,
              maxY: maxY + yPadding,
              titlesData: const FlTitlesData(show: false),
              // Touch interaction: highlight the nearest point.
              lineTouchData: LineTouchData(
                enabled: true,
                touchCallback: (FlTouchEvent event, LineTouchResponse? resp) {
                  // Update touched index for the glowing dot.
                  setState(() {
                    if (resp?.lineBarSpots != null &&
                        resp!.lineBarSpots!.isNotEmpty) {
                      _touchedIndex = resp.lineBarSpots![0].x.toInt();
                    } else {
                      _touchedIndex = -1;
                    }
                  });
                },

                /// Custom tooltip showing the price value.
                getTouchedSpotIndicator: (LineChartBarData barData,
                        List<int> spotIndexes) =>
                    spotIndexes
                        .map(
                          (index) => TouchedSpotIndicatorData(
                            /// Vertical dashed line indicator.
                            FlLine(
                              color: neonGreen.withValues(alpha: 0.4),
                              strokeWidth: 1,
                              dashArray: [4, 4],
                            ),

                            /// Glowing dot at the touch point.
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, pct, bar, idx) =>
                                  FlDotCirclePainter(
                                radius: 5,
                                color: neonGreen,
                                strokeWidth: 2,
                                strokeColor: neonGreen.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                        )
                        .toList(),

                /// Tooltip customazation
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) =>
                      context.colors.accentHeaderGreen.withValues(alpha: 0.95),
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (List<LineBarSpot> spots) => spots
                      .map(
                        (spot) => LineTooltipItem(
                          '\$${spot.y.toStringAsFixed(2)}',
                          context.fonts.bodySm.copyWith(
                            color: neonGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              lineBarsData: [
                /// Top line stroke (current price)
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  // Neon green stroke.
                  color: neonGreen,
                  barWidth: 2.2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    checkToShowDot: (spot, barData) =>
                        spot.x.toInt() == _touchedIndex,
                    getDotPainter: (spot, pct, bar, idx) => FlDotCirclePainter(
                      radius: 5,
                      color: neonGreen,
                      strokeWidth: 2.5,
                      strokeColor: neonGreen.withValues(alpha: 0.25),
                    ),
                  ),

                  /// Gradient fill beneath the line.
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        neonGreen.withValues(alpha: 0.28),
                        neonGreen.withValues(alpha: 0.08),
                        neonGreen.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        /// Switch between different time ranges.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ChartRange.values.map(
            (range) {
              final isSelected = range == _selectedRange;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedRange = range;
                  _touchedIndex = -1;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? neonGreen.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? neonGreen.withValues(alpha: 0.5)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    range.label,
                    style: context.fonts.labelMd.copyWith(
                      color: isSelected
                          ? neonGreen
                          : context.colors.neutralMutedSilverGray,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  /// Number of data points for each range. More points = smoother curve.
  int _pointCount(ChartRange range) => switch (range) {
        ChartRange.oneHour => 60,
        ChartRange.oneDay => 96,
        ChartRange.oneWeek => 168,
        ChartRange.oneMonth => 120,
        ChartRange.all => 200,
      };

  /// Volatility scalar for each range. Longer ranges = larger swings.
  double _volatility(ChartRange range) => switch (range) {
        ChartRange.oneHour => 0.003,
        ChartRange.oneDay => 0.012,
        ChartRange.oneWeek => 0.04,
        ChartRange.oneMonth => 0.10,
        ChartRange.all => 0.25,
      };

  /// TODO: This is a temporary forced mock implementation.
  /// CoinMarketCap's free tier (Basic Plan) does not provide access to historical data endpoints
  /// (e.g., '/v2/cryptocurrency/quotes/historical' returns a 403 Forbidden error).
  /// This random-walk generator must be replaced with real API data once upgrading to a
  /// paid CMC plan (Hobbyist+) or when integrating a free chart data provider like CoinGecko.
  List<FlSpot> _generateSpots(ChartRange range) {
    final count = _pointCount(range);
    final vol = _volatility(range);

    // Use a deterministic seed so the chart doesn't flicker on rebuild.
    // Different ranges get different seeds to produce unique shapes.
    final rng = math.Random(range.index * 31 + widget.currentPrice.toInt());

    // Estimate where the price "started" by working backwards from the 24h change.
    // For non-1D ranges we scale the starting offset by a factor.
    final scaleFactor = switch (range) {
      ChartRange.oneHour => 0.04,
      ChartRange.oneDay => 1.0,
      ChartRange.oneWeek => 2.5,
      ChartRange.oneMonth => 5.0,
      ChartRange.all => 12.0,
    };
    final startPrice = widget.currentPrice /
        (1 + (widget.percentChange24h / 100) * scaleFactor);

    final spots = <FlSpot>[];
    double price = startPrice;

    for (int i = 0; i < count; i++) {
      // Gaussian-ish noise via Box-Muller approximation (cheap two-uniform version).
      final u1 = rng.nextDouble();
      final u2 = rng.nextDouble();
      final noise =
          math.sqrt(-2 * math.log(u1 + 1e-9)) * math.cos(2 * math.pi * u2);

      // Mean-reversion pull toward current price scaled by progress through the walk.
      final progress = i / count;
      final pullStrength = 0.15 * progress;
      final pull = (widget.currentPrice - price) * pullStrength;

      // Apply noise + pull; clamp to avoid negative prices.
      price = math.max(price + price * vol * noise + pull, 1.0);

      spots.add(FlSpot(i.toDouble(), price));
    }

    // Force the last point to be the exact current price so the chart always
    // ends at the live value regardless of noise accumulation.
    if (spots.isNotEmpty) {
      spots[spots.length - 1] =
          FlSpot((count - 1).toDouble(), widget.currentPrice);
    }

    return spots;
  }
}

/// Available chart time-range intervals shown as tabs below the chart.
enum ChartRange {
  oneHour('1H'),
  oneDay('1D'),
  oneWeek('1W'),
  oneMonth('1M'),
  all('ALL');

  const ChartRange(this.label);

  /// Short display label for the tab button.
  final String label;
}
