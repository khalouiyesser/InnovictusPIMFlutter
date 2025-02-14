import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GreenEnergyCard extends StatelessWidget {
  const GreenEnergyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final basePadding = screenWidth * 0.05;
        final cardPadding = screenWidth * 0.06;
        final titleFontSize = screenWidth * 0.05;
        final contentFontSize = screenWidth * 0.035;
        final iconSize = screenWidth * 0.07;
        final chartHeight = screenWidth * 0.5;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: basePadding, vertical: basePadding / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Shaping a Cleaner, Sustainable Future',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: basePadding * 2),
              Container(
                padding: EdgeInsets.all(cardPadding),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A140C).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A3A2E),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF29E33C), width: 2),
                          ),
                          child: Center(
                            child: Icon(Icons.bar_chart, color: Colors.white, size: iconSize * 0.6),
                          ),
                        ),
                        SizedBox(width: basePadding),
                        Expanded(
                          child: Text(
                            'From Fossil Fuels to Solar Power: A Sustainable Shift',
                            style: TextStyle(color: Colors.white, fontSize: contentFontSize),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: cardPadding),
                    SizedBox(
                      height: chartHeight,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text(
                                      '${value.toInt()} kWh',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: contentFontSize * 0.8,
                                      ),
                                    ),
                                  );
                                },
                                interval: 25,
                                reservedSize: 45,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
                                  if (value.toInt() < months.length) {
                                    return Text(
                                      months[value.toInt()],
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: contentFontSize * 0.8,
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              left: BorderSide(color: Colors.white, width: 1), 
                              bottom: BorderSide(color: Colors.white, width: 1),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 50),
                                FlSpot(1, 72),
                                FlSpot(2, 55),
                                FlSpot(3, 85),
                                FlSpot(4, 58),
                                FlSpot(5, 42),
                                FlSpot(6, 35),
                              ],
                              isCurved: true,
                              color: const Color(0xFF29E33C),
                              barWidth: 2,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: const Color(0xFF29E33C),
                                    strokeWidth: 0.1,
                                    strokeColor: const Color(0xFF29E33C),
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xFF4ADE80).withOpacity(0.3),
                                    const Color(0xFF4ADE80).withOpacity(0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          minY: 25,
                          maxY: 100,
                        ),
                      ),
                    ),
                    SizedBox(height: cardPadding),
                    Text(
                      'GreenEnergyChain is revolutionizing the energy landscape, slashing fossil fuel reliance and fueling the future with clean, renewable power.',
                      style: TextStyle(color: Colors.white, fontSize: contentFontSize, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
