import 'package:flutter/material.dart';
import 'package:piminnovictus/views/Background.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardPage extends StatefulWidget {

    @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {

    // Initial data for the chart
  List<FlSpot> weekDataPoints = [
    const FlSpot(0, 3000),
    const FlSpot(1, 5000),
    const FlSpot(2, 4000),
    const FlSpot(3, 7000),
    const FlSpot(4, 6000),
    const FlSpot(5, 3000),
    const FlSpot(6, 4000),
  ];

  List<FlSpot> monthDataPoints = [
    const FlSpot(0, 10000),
    const FlSpot(1, 15000),
    const FlSpot(2, 80000),
    const FlSpot(3, 20000),
  ];

  List<FlSpot> yearDataPoints = [
    const FlSpot(0, 25000),
    const FlSpot(1, 30000),
    const FlSpot(2, 28000),
    const FlSpot(3, 35000),
    const FlSpot(4, 29000),
    const FlSpot(5, 12000),
    const FlSpot(6, 10000),
    const FlSpot(7, 25000),
    const FlSpot(8, 30000),
    const FlSpot(9, 28000),
    const FlSpot(10, 35000),
    const FlSpot(11, 40000),
  ];

  // Set default period to week
  late List<FlSpot> currentDataPoints;

  int selectedPeriodIndex = 0; // 0 - Week, 1 - Month, 2 - Year

  @override
  void initState() {
    super.initState();
    currentDataPoints = weekDataPoints; // Default to week
  }

    // Toggle buttons to switch between Week, Month, and Year
  void updateChart(int index) {
    setState(() {
      selectedPeriodIndex = index;
      switch (index) {
        case 0:
          currentDataPoints = weekDataPoints;
          break;
        case 1:
          currentDataPoints = monthDataPoints;
          break;
        case 2:
          currentDataPoints = yearDataPoints;
          break;
      }
    });
  }
double getMaxY(List<FlSpot> dataPoints) {
  return (dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.2); 
  // Multiply by 1.2 for some padding above the highest point
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1412),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              double padding = screenWidth * 0.05;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlurredRadialBackground(
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF29E33C),
                                    width: 3,
                                  ),
                                ),
                                child: const CircleAvatar(
                                  radius: 24,
                                  backgroundImage:
                                      AssetImage('assets/user.jpg'),
                                ),
                              ),
                              const Text('10 Février, 2025',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14)),
                              Row(
                                children: [
                                  _buildIconButton(Icons.search),
                                  const SizedBox(width: 16),
                                  Stack(
                                    children: [
                                      _buildIconButton(Icons.notifications),
                                      Positioned(
                                        right: 6,
                                        top: 6,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: const Size(200, 200),
                                  painter: CircularProgressPainter(0.85),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 18),
                                    const Text('Central Energy',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16)),
                                    const SizedBox(height: 1),
                                    const Text('85%',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.normal)),
                                    const SizedBox(height: 20),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.green, width: 2),
                                      ),
                                      child: const Icon(Icons.bolt,
                                          color: Colors.green, size: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          buildCardRow(context),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: GridView.count(
                              childAspectRatio:
                                  1.6, // Adjust the aspect ratio as needed
                              crossAxisCount: screenWidth > 600
                                  ? 4
                                  : 2, // More columns for wider screens
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              shrinkWrap:
                                  true, // Permet au GridView de s'ajuster à son contenu
                              physics:
                                  const NeverScrollableScrollPhysics(), // Désactive le défilement interne du GridView
                              children: [
                                _buildInfoCard('Total Energy', '85000 Kwh',Icons.lightbulb),
                                _buildInfoCard(
                                    'Capacity', '100000.0 Kwh', Icons.battery_full),
                                _buildInfoCard(
                                      'Monthly Sold', '22309 Kwh', Icons.flash_on),
                                _buildInfoCard(
                                      'Monthly Bought', '10102 Kwh', Icons.flash_on),
                                _buildInfoCard(
                                    'CO2 Reduction', '48 tCO₂', Icons.eco),
                                _buildInfoCard(
                                    'Monthly Income', '3,250.56 TND', Icons.attach_money),
                              ],
                            ),
                          ),
                          buildLineChart(context),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 40.0,
      height: 40.0,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 26,
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF151F1A).withOpacity(0.78),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF29E33C), size: 23),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build the cards
  Widget buildCard(BuildContext context, String title, int transactions, String number, String percentChange) {
    return Card(
      color: const Color(0xFF151F1A).withOpacity(0.78),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.27, // Use context from parameter
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white70,fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "$transactions",
                style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 1),
            const Center(
              child: Text(
                "Transactions",
                style: TextStyle(color: Colors.white70,fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "$percentChange",
                  style: TextStyle(fontSize: 13, color: percentChange.startsWith("+") ? Colors.green : Colors.red),
                ),
                const SizedBox(width: 2),
                Text(
                  "vs last $title",
                  style: TextStyle(fontSize: 9, color: percentChange.startsWith("+") ? Colors.green : Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Main widget to place the cards horizontally
  Widget buildCardRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildCard(context,"Week", 72, "+5", "+4%"),
          buildCard(context,"Month", 289, "-2", "-1%"),
          buildCard(context,"Year", 3468, "+10", "+7%"),
        ],
      ),
    );
  }



  Widget buildLineChart(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45, // 45% of screen height
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF151F1A).withOpacity(0.78),
        //borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Toggle buttons inside the container at the top
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              isSelected: [
                selectedPeriodIndex == 0,
                selectedPeriodIndex == 1,
                selectedPeriodIndex == 2,
              ],
              onPressed: updateChart,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Week',style: TextStyle(color: Colors.white, fontSize: 12),),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Month',style: TextStyle(color: Colors.white, fontSize: 12),),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Year',style: TextStyle(color: Colors.white, fontSize: 12),),
                ),
              ],
            ),
          ),
          
          // Line chart below the toggle buttons and the cards
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: getMaxY(currentDataPoints), // Dynamically set maxY 
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${(value / 1000).toStringAsFixed(0)}K', // Divide by 1000 and add "K" // Show the data point value on the left side
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        String title = '';
                        if (selectedPeriodIndex == 0) {
                          // Week: Show days of the week
                          final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          title = daysOfWeek[value.toInt()];
                        } else if (selectedPeriodIndex == 1) {
                          // Month: Show weeks (Week 1, Week 2, Week 3, Week 4)
                          final weeksOfMonth = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
                          title = weeksOfMonth[value.toInt()]; // Use modulo to cycle through weeks
                        } else if (selectedPeriodIndex == 2) {
                          // Year: Show months
                          final monthsOfYear = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                          title = monthsOfYear[value.toInt()];
                        }
                        return Text(
                          title,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: currentDataPoints,
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.lightGreen],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [Colors.lightGreen.withOpacity(0.3), Colors.transparent],
                      ),
                    ),
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class CircularProgressPainter extends CustomPainter {
  
  final double progress;
  CircularProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF29E33C), Colors.white70],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 - 7;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.radians(135),
      math.radians(270),
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.radians(135),
      math.radians(270 * progress),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

