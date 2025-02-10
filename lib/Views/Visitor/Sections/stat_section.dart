import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/views/background.dart';

class GreenEnergyCard extends StatelessWidget {
  const GreenEnergyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20), // Reduced top padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child:  Text(
                'Shaping a Cleaner, Sustainable Future ',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0A140C).withOpacity(0.4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and Title
                  Row(
                    children: [
                     Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A3A2E),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF29E33C),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.bar_chart,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'From Fossil Fuels to Solar Power:A Sustainable Shift',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Chart
                  SizedBox(
                    height: 250,
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
                                      fontSize: 12,
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
                                      fontSize: 12,
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
  show: true,
  border: Border(
    left: BorderSide(color:Colors.white, width: 1), // Axe Y
    bottom: BorderSide(color: Colors.white, width: 1), // Axe X
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
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  const Text(
                    'GreenEnergyChain is revolutionizing the energy landscape, slashing fossil fuel reliance and fueling the future with clean, renewable power.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Button
                 ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}