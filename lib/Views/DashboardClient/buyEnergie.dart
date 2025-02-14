import 'package:flutter/material.dart';
import 'dart:math';
import 'package:piminnovictus/Views/DashboardClient/EnergyPurchaseConfirmation.dart';

class BuyEnergiePage extends StatefulWidget {
  @override
  _BuyEnergiePageState createState() => _BuyEnergiePageState();
}

class _BuyEnergiePageState extends State<BuyEnergiePage> {
  int _currentStep = 0;
  double _quantity = 20;
  double _coin = 0.0;
  List<String> _codeDigits = List.filled(4, "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A140C),
      body: SafeArea(
        child: SingleChildScrollView(
          // Ajout du ScrollView
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              _buildEnergyIndicator(),
              const SizedBox(height: 20),
              _buildStepProgress(),
              const SizedBox(height: 20),
              _buildStepContent(),
              const SizedBox(height: 30),
              _buildNavigationButtons(),
              const SizedBox(
                  height:
                      20), // Pour éviter que les boutons soient collés en bas
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnergyIndicator() {
    return Column(
      children: [
        const Text(
          "Power your home with clean energy!",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30),
        Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(150, 150),
              painter: CircularProgressPainter(0.7),
            ),
            const Column(
              children: [
                Text("Total Energy",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                Text("70%",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        SizedBox(height: 50),
      ],
    );
  }

  Widget _buildStepProgress() {
    List<IconData> icons = [
      Icons.signal_cellular_alt,
      Icons.lock,
      Icons.check_circle
    ];
    return Column(
      children: [
        const Text("Get Started in 3 Steps",
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(icons.length, (index) {
            bool isActive = index == _currentStep;
            return Row(
              children: [
                if (index != 0)
                  Container(
                      width: 100,
                      height: 2,
                      color:
                          isActive ? const Color(0xFF29E33C) : Colors.white70),
                CircleAvatar(
                  backgroundColor:
                      isActive ? const Color(0xFF29E33C) : Colors.white70,
                  radius: 18,
                  child: Icon(icons[index], color: Colors.white),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 27),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (_currentStep == 0) _buildQuantitySelector(),
            if (_currentStep == 1) _buildCodeInput(),
            if (_currentStep == 2) _buildConfirmation(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      children: [
        const Text("Enter Energy Quantity",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: Colors.grey[800], borderRadius: BorderRadius.circular(16)),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter quantity en KW ",
                hintStyle: TextStyle(color: Colors.white54)),
            onChanged: (value) {
              setState(() {
                _quantity = double.tryParse(value) ?? 0;
                _coin = _quantity * 2.5;
              });
            },
          ),
        ),
        const SizedBox(height: 15),
        Text("Equivalent in Coins: $_coin",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCodeInput() {
    return Column(
      children: [
        const Text("Enter your Code", style: TextStyle(color: Colors.white)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) => _buildCodeBox(index)),
        ),
      ],
    );
  }

  Widget _buildCodeBox(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.grey[700], borderRadius: BorderRadius.circular(8)),
      child: TextField(
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(counterText: "", border: InputBorder.none),
        onChanged: (value) {
          setState(() {
            _codeDigits[index] = value;
          });
        },
      ),
    );
  }

  Widget _buildConfirmation() {
    return const Column(
      children: [
        Text(
            "Your payment with coins has been successfully processed. Thank you for choosing clean solar energy !",
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(" Check your email for the details!",
            style: TextStyle(color: Color(0xFF29E33C))),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Opacity(
            opacity: _currentStep == 0 ? 0 : 1.0,
            child: ElevatedButton(
              onPressed: _currentStep > 0
                  ? () => setState(() => _currentStep--)
                  : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              child: const Text("Back",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_currentStep < 2) {
                  _currentStep++;
                } else {
                  // Naviguer vers la page de confirmation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EnergyPurchaseConfirmationPage(
                            energyAmount: _quantity)),
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF29E33C),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
            child: const Text("Next",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

// Classe pour dessiner l'indicateur circulaire
class CircularProgressPainter extends CustomPainter {
  final double percentage;

  CircularProgressPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.green.shade300, Colors.green.shade800],
      ).createShader(
          Rect.fromCircle(center: Offset(0, 0), radius: size.width / 2))
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 - 5;

    canvas.drawCircle(center, radius, backgroundPaint);

    double startAngle = -pi / 2;
    double sweepAngle = 2 * pi * percentage;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
