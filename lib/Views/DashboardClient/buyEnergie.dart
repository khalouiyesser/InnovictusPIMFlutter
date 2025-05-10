import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Models/Transaction%20.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Services/Const.dart';
import 'package:piminnovictus/Services/profile_service.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Services/socket_service.dart';
import 'package:piminnovictus/ViewModels/WalletViewModel.dart';
import 'package:piminnovictus/Views/DashboardClient/Bottom_bar.dart';
import 'dart:math';
import 'package:piminnovictus/Views/DashboardClient/EnergyPurchaseConfirmation.dart';
import 'package:piminnovictus/Views/bachground.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BuyEnergiePage extends StatefulWidget {
  @override
  _BuyEnergiePageState createState() => _BuyEnergiePageState();
}

class _BuyEnergiePageState extends State<BuyEnergiePage> {
  int _currentStep = 0;
  double _quantity = 20;
  double _coin = 0.0;
  List<String> _codeDigits = List.filled(4, "");

// Instantiate ProfileService (make sure to pass the base URL and session manager properly)
final profileService = ProfileService(
  baseUrl: Const().url, // Your base URL here
  sessionManager: SessionManager(),
);

  get screenWidth => MediaQuery.of(context).size.width;

String? accountId;
String? privateKey;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  Future<void> _loadWalletData() async {
     this.privateKey = await secureStorage.read(key: 'privateKey');
     this.accountId = await secureStorage.read(key: 'accountId');

    if (accountId != null && privateKey != null) {
      print('-****************CCC***********************-');
      print('Account ID: $accountId');
      print('Private Key: $privateKey');
      print('-****************CCC***********************-');
    } else {
      print('-****************CCC***********************-');
      print('No stored wallet credentials found.');
      print('-****************CCC***********************-');
    }

  fetchTokenBalance(accountId.toString(),privateKey.toString());
  }

String _tokenBalance = "0";
String get tokenBalance => _tokenBalance;
final String baseBcUrl = "${Const().urlBlockChain}";
Future<void> fetchTokenBalance(String operatorAccountId, String operatorPrivateKey) async {
  try {
    final uri = Uri.parse(
      "$baseBcUrl/tokenBalance"
      "?operatorAccountId=$operatorAccountId&operatorPrivateKey=$operatorPrivateKey",
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _tokenBalance = data["balance"].toString();
      
    } else {
      throw Exception("Failed to fetch balance: ${response.reasonPhrase}");
    }
  } catch (error) {
    print("❌ Error fetching token balance: $error");
  }
}

/*
Future<bool> handleTransferAndSendTokens(double quantity) async {
  try {
    final List<dynamic> usersList =
        await profileService.transfer(quantity.toString());

    print("✅ Received users list: $usersList");

    for (var user in usersList) {
      final int amount = user['amount'];
      final double price = amount * 0.25;

      final String? receiverId = user['wallet'];

      if (receiverId == null) {
        print("⚠️ Skipping user with no wallet: $user");
        continue;
      }

      final result = await profileService.transaction(
        senderId: this.accountId.toString(),
        receiverId: receiverId,
        amount: price,
        senderPrivateKey: this.privateKey.toString(),
      );
      print("🔁 Transaction result for Greeno: $result");
      
    }

    return true; // ✅ Success
  } catch (e) {
    print("❌ Error during transfer and token distribution: $e");
    return false; // ❌ Failure
  }
}
*/
// Updated method to handle transfers in a single batch transaction
Future<bool> handleTransferAndSendTokens(double quantity) async {
  try {
    final List<dynamic> usersList = await profileService.transfer(quantity.toString());
    print("✅ Received users list: $usersList");

    // Filter out users without wallets and prepare batch data
    final List<String> validReceiverIds = [];
    final List<double> validAmounts = [];

    for (var user in usersList) {
      final int amount = user['amount'];
      final double price = amount * 2.5;
      final String? receiverId = user['wallet'];

      if (receiverId == null || receiverId.isEmpty) {
        print("⚠️ Skipping user with no wallet: $user");
        continue;
      }

      validReceiverIds.add(receiverId);
      validAmounts.add(price);
    }

    // If there are valid receivers, process the batch transaction
    if (validReceiverIds.isNotEmpty) {
      final result = await profileService.transaction(
        senderId: this.accountId.toString(),
        receiverIds: validReceiverIds,
        amounts: validAmounts,
        senderPrivateKey: this.privateKey.toString(),
      );
      
      print("🔁 Batch transaction result for Greeno tokens: $result");
      return true; // ✅ Success
    } else {
      print("⚠️ No valid recipients found for token distribution");
      return false; // No transactions were made
    }
  } catch (e) {
    print("❌ Error during transfer and token distribution: $e");
    return false; // ❌ Failure
  }
}
////////////////
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage;

Future<bool> _checkPassword() async {
    String? storedPassword = await secureStorage.read(key: 'walletPassword');
    print("**************_check Wallet Password Srarted ********************");
    String enteredPassword = _passwordController.text.trim();

    if (storedPassword == null) {
      setState(() {
        print(
            "**************_check Wallet Password: storedPassword == null ********************");
        _errorMessage = "No password found. Please create one first.";
      });
      return false;
    } else if (enteredPassword == storedPassword) {
      setState(() {
        _errorMessage = null;
      });
      print(
          "**************_check Wallet Password: enteredPassword == storedPassword ********************");
      return true;
    } else {
      setState(() {
        print(
            "**************_check Wallet Password: Incorrect password. Please try again. ********************");
        _errorMessage = "Incorrect password. Please try again.";
      });
      return false;
    }
    print("**************_check Wallet Password ENDED ********************");
  }

  late WebSocketChannel channel;
  final SocketService _socketService = SocketService();
  double surplusAvail = 0.0;

@override
  void initState() {
    super.initState();
    _loadWalletData();
    //fetchTokenBalance(this.accountId.toString(),this.privateKey.toString());
    _socketService.connectToSocket((data) {
      if (mounted) {
        setState(() {
          surplusAvail = data['totalSurplusAvail'] is num
              ? double.parse((data['totalSurplusAvail'] as num).toStringAsFixed(2))
              : 0.0;
        });
      }
      print("-----------------------------print(surplusAvail);---------------------------------");
      print(surplusAvail);
    });
  }

  @override
  Widget build(BuildContext context) {


    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    // Récupérer le ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    final theme = themeProvider.currentTheme ??
        ThemeData
            .light(); // Ajouter une valeur par défaut au cas où le thème est null

    return Scaffold(
      extendBody: true,

      backgroundColor: theme
          .scaffoldBackgroundColor, // Ajout d'une couleur de fond par défaut
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            BlurredRadialBackground(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    _buildEnergyIndicator(theme),
                    const SizedBox(height: 20),
                    _buildStepProgress(theme),
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
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyIndicator(ThemeData theme) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).translate("power_home_title"),
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: screenWidth * 0.05,
          ),
        ),
        SizedBox(height: 30),
        Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(200, 200),
              painter: CircularProgressPainter(0.7),
            ),
            Column(
              children: [
                Text(
                  AppLocalizations.of(context).translate("total_energy"),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    color: theme.textTheme.titleMedium?.color?.withOpacity(0.7),
                  ),
                ),
                Text(
                  //"250KW",
                  '${this.surplusAvail} ${AppLocalizations.of(context).translate('KW')}',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontSize: screenWidth * 0.1,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 50),
      ],
    );
  }

  Widget _buildStepProgress(ThemeData theme) {
    List<IconData> icons = [
      Icons.signal_cellular_alt,
      Icons.lock,
      Icons.check_circle
    ];
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).translate("get_started_steps"),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: screenWidth * 0.04,
          ),
        ),
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
                    color: isActive
                        ? theme.colorScheme.primary
                        : Color.fromARGB(255, 162, 162,
                            162), // Utilisation de colorScheme.secondary
                  ),
                CircleAvatar(
                  backgroundColor: isActive
                      ? theme.colorScheme.secondary
                      : Color.fromARGB(255, 171, 171,
                          171), // Utilisation de colorScheme.secondary
                  radius: 18,
                  child: Icon(
                    icons[index],
                    color: theme.colorScheme.primary ?? MyThemes.primaryColor,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    final theme = Theme.of(context);
    return Card(
      color: theme.cardColor.withOpacity(0.90),
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
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).translate("enter_energy_quantity"),
          style: theme.textTheme.titleMedium
              ?.copyWith(fontSize: screenWidth * 0.04),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.70),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.90) ??
                  MyThemes.primaryColor.withOpacity(0.11),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            style: theme.textTheme.bodyLarge,
            
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText:
                  AppLocalizations.of(context).translate("enter_quantity_hint"),
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                fontSize: screenWidth * 0.03,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _quantity = double.tryParse(value) ?? 0;
                _coin = _quantity * 2.5;
              });
            },
          ),
        ),
        const SizedBox(height: 15),
        Text(
          AppLocalizations.of(context)
              .translate("equivalent_coins")
              .replaceAll("{coin}", _coin.toString()),
          style: theme.textTheme.titleMedium
              ?.copyWith(fontSize: screenWidth * 0.04),
        ),
      ],
    );
  }

  Widget _buildCodeInput() {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          // AppLocalizations.of(context).translate("enter_code"),
          "Enter Your Wallet Password",
          style: theme.textTheme.titleMedium
              ?.copyWith(fontSize: screenWidth * 0.04),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(1, (index) => _buildCodeBox(index)),
        ),
      ],
    );
  }
/*
  Widget _buildCodeBox(int index) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.70),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.88) ??
              MyThemes.primaryColor.withOpacity(0.11),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyLarge,
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
   }*/

///
Widget _buildCodeBox(int index) {
  final theme = Theme.of(context);

  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.cardColor.withOpacity(0.70),
            hintText: 'Password',
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              fontSize: screenWidth * 0.03,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: theme.iconTheme.color,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: screenWidth * 0.04,
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    ),
  );
}


  Widget _buildConfirmation() {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          AppLocalizations.of(context).translate("payment_success"),
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: screenWidth * 0.04,
          ),
        ),
        const SizedBox(height: 10),
        // Text(
        //   AppLocalizations.of(context).translate("check_email"),
        //   style: TextStyle(color: const Color(0xFF29E33C)),
        // ),
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
              child: Text(AppLocalizations.of(context).translate("back"),
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() async {
                if (_currentStep == 0) {
                  bool hasEnough = this._coin < double.parse(this._tokenBalance);
                  print("fffffffffffffffffffffffffffffffffffffffffff   "+this._tokenBalance);
                  bool thersEnoughSur = this._quantity <= this.surplusAvail && this._quantity > 0  ;

                  if (!hasEnough || !thersEnoughSur) {
                    String message = '';

                    if (!hasEnough && !thersEnoughSur) {
                      message = "Not enough coins AND not enough surplus.";
                    } else if (!hasEnough) {
                      message = "You don't have enough coins.";
                    } else if (!thersEnoughSur) {
                      message = "Not enough surplus available.";
                    }

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Validation Error"),
                        content: Text(message),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                }
                 if (_currentStep == 1) {
                if (await _checkPassword()) {
                    // do something if password is valid
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Invalid Password"),
                        content: Text(_errorMessage ?? "Incorrect password. Please try again."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("OK"),
                          )
                        ],
                      ),
                    );
                    return;
                  }
              }
                if (_currentStep < 2) {
                  _currentStep++;
                }
                else {
                print("---------------------------------------------------- preseeeeeed");
                bool success = await handleTransferAndSendTokens(_quantity);
                if (success) {
                  // ✅ Navigate to confirmation page only if successful
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          //EnergyPurchaseConfirmationPage(energyAmount: _quantity),
                          BottomNavBarExample(),
                    ),
                  );
                } else {
                  // ❌ Show error dialog instead
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Transaction Failed",
                          style: TextStyle(color: Colors.red),
                        ),
                        content: const Text("Something went wrong!! Your coins still on your wallet"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("OK",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
                          ),
                        ],
                      );
                    },
                  );
                }}
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF29E33C),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
            child: Text(AppLocalizations.of(context).translate("next"),
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
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2,
        backgroundPaint);

    Paint foregroundPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    double sweepAngle = 2 * pi * percentage;
    canvas.drawArc(
        Offset(0, 0) & size, -pi / 2, sweepAngle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
