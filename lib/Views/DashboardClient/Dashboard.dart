import 'package:flutter/material.dart';
import 'package:piminnovictus/Views/bachground.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class DashboardPage extends StatelessWidget {
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
                              Padding(
                                padding:
                                    EdgeInsets.only(right: screenWidth * 0.1),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Welcome Back!',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    Text('Khaled Guedria',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
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
                          const SizedBox(height: 11),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: padding),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10 Février, 2025',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: padding),
                            child: const Row(
                              children: [
                                Icon(Icons.wb_sunny,
                                    color: Colors.yellow, size: 20),
                                SizedBox(width: 8),
                                Text('23°C',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14)),
                              ],
                            ),
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
                                    const Text('Energy Usages',
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
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
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
                                _buildInfoCard('Total Energy', '36.2 Kwh',
                                    Icons.lightbulb),
                                _buildInfoCard(
                                    'Consumed', '28.2 Kwh', Icons.flash_on),
                                _buildInfoCard(
                                    'Capacity', '42.0 Kwh', Icons.battery_full),
                                _buildInfoCard(
                                    'CO2 Reduction', '28.2 Kwh', Icons.eco),
                              ],
                            ),
                          ),
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
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF151F1A).withOpacity(0.78),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
