// ignore_for_file: file_names

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/screens/profile/components/BMI_line_chart/bmi_points.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget(
      {super.key, required this.points, required this.bottomTitles});

  final List<BMIPoint> points;
  final List<String> bottomTitles;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: true,
              dotData: const FlDotData(show: true),
              barWidth: 3,
              gradient: LinearGradient(colors: [
                ColorTween(begin: kPrimaryColor, end: kTextColor).lerp(0.2)!,
                ColorTween(begin: kPrimaryColor, end: kTextColor).lerp(0.2)!,
              ]),
              shadow: const Shadow(
                  color: Colors.green, blurRadius: 7, offset: Offset(7, 18)),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    ColorTween(begin: kPrimaryColor, end: kTextColor)
                        .lerp(0.2)!
                        .withOpacity(0.3),
                    ColorTween(begin: kPrimaryColor, end: kTextColor)
                        .lerp(0.2)!
                        .withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ],
          gridData: const FlGridData(
            show: false,
            // drawVerticalLine: true,
            // horizontalInterval: 5,
            // verticalInterval: 0.5,
            // getDrawingHorizontalLine: (value) {
            //   return const FlLine(
            //     color: kBackgroundColor,
            //     strokeWidth: 1,
            //   );
            // },
            // getDrawingVerticalLine: (value) {
            //   return const FlLine(
            //     color: kBackgroundColor,
            //     strokeWidth: 1,
            //   );
            // },
          ),
          minY: 0,
          maxY: 50,
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: kTextColor),
              bottom: BorderSide(color: kTextColor),
            ),
          ),
          // backgroundColor: Colors.amber[100],
          titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
              axisNameWidget: Text(
                "BMI Chart",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              axisNameSize: 33,
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 10,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < bottomTitles.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(bottomTitles[index],
                          style: const TextStyle(
                            color: kTextColor,
                            fontSize: 10,
                          )),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
