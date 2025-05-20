import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';



class BarChartRepresentation extends StatelessWidget {
  const BarChartRepresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: _generateBarGroups(),
        borderData: FlBorderData(show: false),
        alignment: BarChartAlignment.spaceBetween,
        gridData: const FlGridData(drawHorizontalLine: true, horizontalInterval: 20),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
                if (value.toInt() < months.length) {
                  return Text(months[value.toInt()], style: const TextStyle(fontSize: 10));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    final regular = [5, 8, 6, 7, 3, 5, 6, 7, 4, 2, 1, 0];
    final gold = [2, 3, 4, 2, 5, 2, 3, 1, 0, 2, 1, 0];
    final platinum = [1, 0, 2, 1, 1, 3, 2, 1, 0, 1, 0, 0];

    return List.generate(12, (index) {
      return BarChartGroupData(
        x: index,
        barsSpace: 4,
        barRods: [
          BarChartRodData(toY: regular[index].toDouble(), width: 6, color: Colors.blue),
          BarChartRodData(toY: gold[index].toDouble(), width: 6, color: Colors.amber),
          BarChartRodData(toY: platinum[index].toDouble(), width: 6, color: Colors.grey),
        ],
      );
    });
  }
}

