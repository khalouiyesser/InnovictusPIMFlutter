import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StepForm(),
    );
  }
}

class StepForm extends StatefulWidget {
  @override
  _StepFormState createState() => _StepFormState();
}

class _StepFormState extends State<StepForm> {
  int _currentStep = 0;
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Card(
          color: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Get Started on 3 Steps",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 20),
                _buildProgressIndicator(),
                SizedBox(height: 30),
                _buildStepContent(),
                SizedBox(height: 30),
                _buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor:
                  _currentStep >= index ? Colors.green : Colors.grey,
            ),
            if (index < 2) ...[
              SizedBox(width: 10),
              Container(
                width: 40,
                height: 2,
                color: _currentStep > index ? Colors.green : Colors.grey,
              ),
              SizedBox(width: 10),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildQuantityField();
      case 1:
        return _buildCodeField();
      case 2:
        return _buildInformation();
      default:
        return Container();
    }
  }

  Widget _buildQuantityField() {
    return Column(
      children: [
        Text("Quantité", style: TextStyle(color: Colors.white)),
        SizedBox(height: 10),
        TextField(
          controller: _quantityController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: "Entrer la quantité",
            hintStyle: TextStyle(color: Colors.white70),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildCodeField() {
    return Column(
      children: [
        Text("Enter your code", style: TextStyle(color: Colors.white)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                width: 50,
                height: 50,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInformation() {
    return Text("Information",
        style: TextStyle(color: Colors.white, fontSize: 18));
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        if (_currentStep < 2) {
          setState(() {
            _currentStep++;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      child: Text(_currentStep == 2 ? "Confirm" : "Next"),
    );
  }
}
