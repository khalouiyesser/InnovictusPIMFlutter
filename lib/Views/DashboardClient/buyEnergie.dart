import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Models/Transaction%20.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/TransferStateProvider.dart';
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
  double _progressPercent = 0.0;
  List<String> _codeDigits = List.filled(4, "");
bool _isLoadingSurplus = true;
  // Instantiate ProfileService (make sure to pass the base URL and session manager properly)
  final profileService = ProfileService(
    baseUrl: Const().url, // Your base URL here
    sessionManager: SessionManager(),
  );

  get screenWidth => MediaQuery.of(context).size.width;

  String? accountId;
  String? privateKey;
  String? userId;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  Future<void> _loadWalletData() async {
    this.privateKey = await secureStorage.read(key: 'privateKey');
    this.accountId = await secureStorage.read(key: 'accountId');
this.userId = await SessionManager().getUserId();    
    // Update the transfer state provider with current userId
    if (userId != null) {
      final transferProvider = Provider.of<TransferStateProvider>(context, listen: false);
      transferProvider.setUserId(userId!);
    }
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

    fetchTokenBalance(accountId.toString(), privateKey.toString());
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
        setState(() {
          _tokenBalance = data["balance"].toString();
        });
      } else {
        throw Exception("Failed to fetch balance: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("❌ Error fetching token balance: $error");
    }
  }


// Fixed method to handle transfers in a single batch transaction
Future<bool> handleTransferAndSendTokens(double quantity) async {
  try {
    final List<dynamic> usersList = await profileService.transfer(quantity.toString());
    print("✅ Received users list: $usersList");

    // Filter out users without wallets and prepare batch data
    final List<String> validReceiverIds = [];
    final List<double> validsPrices = [];
    double comission = 0.0 ;

    for (var user in usersList) { 
      // Cast or convert numeric values to double explicitly
      final double powers = (user['amount'] is int) 
          ? (user['amount'] as int).toDouble() 
          : (user['amount'] as double);
          
      final double price = powers;  // No need for conversion here
      final String? receiverId = user['wallet'];

      if (receiverId == null || receiverId.isEmpty) {
        print("⚠️ Skipping user with no wallet: $user");
        continue;
      }

      validReceiverIds.add(receiverId);
      validsPrices.add(price);

      
    }

      print("token recivers  ");
      print("validReceiverIds $validReceiverIds");
      print("validReceiverIds $validReceiverIds");


      comission = quantity * 0.02 ;
      // Rounding logic
      int x = comission.floor();
      double decimalPart = comission - x;

      if (decimalPart >= 0.4) {
        comission = x + 1;
        validReceiverIds.add("0.0.5492800");
        validsPrices.add(comission);
      } else {
        comission = x.toDouble();
        validReceiverIds.add("0.0.5492800");
        validsPrices.add(comission);
      }
      print("----------------------------------------------------- comission : $comission");
      // validsPrices.add(comission);
      print("token recievers with our comission");
      print("validReceiverIds 22 $validReceiverIds");
      print("validReceiverIds 22 $validReceiverIds");
      


    // If there are valid receivers, process the batch transaction
    if (validReceiverIds.isNotEmpty) {
      final result = await profileService.transaction(
        senderId: this.accountId.toString(),
        receiverIds: validReceiverIds,
        prices: validsPrices,
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
  }

  late SocketService _socketService;
  double surplusAvail = 0.0;

@override
@override
  void initState() {
    super.initState();
    _loadWalletData().then((_) {
      final transferProvider = Provider.of<TransferStateProvider>(context, listen: false);

      if (userId != null) {
        _fetchSurplusAmount(userId!); // Call API only after userId is set

        _socketService = SocketService();
      _socketService.connectToSocket(
  userId!, // Pass userId as the first argument
  (data) {
    if (mounted) {
      setState(() {
        // You can update state here if needed for battery stats
      });
    }
  },
  onAvailableAmountReceived: (currentAmount) {
    if (mounted) {
      setState(() {
        surplusAvail = double.parse(currentAmount.toStringAsFixed(2));
        _isLoadingSurplus = false;
      });
    }
  },
  transferStateProvider: transferProvider,
);

      //   _socketService.connectToSocket(
      //     (data) {
      //       if (mounted) {
      //         setState(() {});
      //       }
      //     },
      //     onAvailableAmountReceived: (currentAmount) {
      //       if (mounted) {
      //         setState(() {
      //           surplusAvail = double.parse(currentAmount.toStringAsFixed(2));
      // _isLoadingSurplus = false;
      //         });
      //       }
      //     },
      //     transferStateProvider: transferProvider,
      //   );

        _socketService.socket.on('transferProgress', (data) {
          if (mounted && data is Map<String, dynamic> && data.containsKey('progress_percent')) {
            setState(() {
              _progressPercent = (data['progress_percent'] as num).toDouble() / 100;
            });
          }
        });

        _socketService.socket.on('transferComplete', (_) {
          if (mounted) {
            setState(() {
              _progressPercent = 0.0;
            });
          }
        });
      } else {
        setState(() {
          _errorMessage = 'User ID not found. Please log in again.';
          _isLoadingSurplus = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }
Future<void> _fetchSurplusAmount(String userId) async {
    try {
      final uri = Uri.parse('${Const().url}/surplus/amount?userId=$userId');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data.containsKey('data')) {
          setState(() {
            surplusAvail = (data['data'] as num).toDouble();
            _isLoadingSurplus = false;
          });
        } else {
          print('❌ Invalid response data: $data');
          setState(() {
            _errorMessage = 'Failed to load surplus amount.';
            _isLoadingSurplus = false;
          });
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
        setState(() {
          _errorMessage = 'Failed to fetch surplus amount: ${response.reasonPhrase}';
          _isLoadingSurplus = false;
        });
      }
    } catch (error) {
      print('❌ Error fetching surplus amount: $error');
      setState(() {
        _errorMessage = 'Error fetching surplus amount: $error';
        _isLoadingSurplus = false;
      });
    }
  } @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.currentTheme ?? ThemeData.light();
    
    // Listen to transfer state changes
    final transferProvider = Provider.of<TransferStateProvider>(context);
    final bool isTransferInProgress = transferProvider.state != TransferState.idle;

    return Scaffold(
      extendBody: true,
      backgroundColor: theme.scaffoldBackgroundColor,
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Overlay that blocks interaction when a transfer is in progress
            if (isTransferInProgress)
              _buildTransferOverlay(transferProvider, theme),
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
                        : Color.fromARGB(255, 162, 162, 162),
                  ),
                CircleAvatar(
                  backgroundColor: isActive
                      ? theme.colorScheme.secondary
                      : Color.fromARGB(255, 171, 171, 171),
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
                _coin = _quantity ;
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
      ],
    );
  }
 Widget _buildTransferOverlay(TransferStateProvider provider, ThemeData theme) {
  String message = provider.getStateMessage();
  String subtitle;
  Color statusColor;

  switch (provider.state) {
    case TransferState.transferring:
      statusColor = Colors.blue;
      subtitle = "Transfert d'énergie en cours.";
      break;
    case TransferState.receiving:
      statusColor = Colors.green;
      subtitle = "Réception d'énergie en cours.";
      break;
    case TransferState.systemBusy:
      statusColor = Colors.orange;
      subtitle = "Opération de transfert en cours par d'autres utilisateurs.";
      break;
    default:
      statusColor = theme.colorScheme.primary;
      subtitle = "Traitement en cours...";
  }

  return Container(
    color: Colors.black.withOpacity(0.7),
    width: double.infinity,
    height: double.infinity,
    child: Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cercle de progression avec pourcentage
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(80, 80),
                    painter: CircularProgressPainter(_progressPercent), // Utiliser _progressPercent
                  ),
                  Text(
                    "${(_progressPercent * 100).toStringAsFixed(1)}%", // Afficher le pourcentage
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
Widget _buildNavigationButtons() {
  final transferProvider = Provider.of<TransferStateProvider>(context);
  final bool isTransferInProgress = transferProvider.state != TransferState.idle;

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Opacity(
          opacity: _currentStep == 0 ? 0 : 1.0,
          child: ElevatedButton(
            onPressed: isTransferInProgress ? null : (_currentStep > 0 ? () => setState(() => _currentStep--) : null),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: Text(
              AppLocalizations.of(context).translate("back"),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: isTransferInProgress
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context).translate("operation_in_progress")),
                      content: Text(transferProvider.getStateMessage()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(AppLocalizations.of(context).translate("ok")),
                        ),
                      ],
                    ),
                  );
                }
              : () async {
                  if (_currentStep == 0) {
                    bool hasEnough = _coin <= double.parse(_tokenBalance);
                    bool thersEnoughSur = _quantity <= surplusAvail && _quantity > 0;

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
                    setState(() => _currentStep++);
                  } else if (_currentStep == 1) {
                    if (await _checkPassword()) {
                      setState(() => _currentStep++);
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
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    bool success = await handleTransferAndSendTokens(_quantity);
                    if (success) {
                      // Wait for transferComplete before navigating (handled by provider)
                      // Navigation will occur after transferComplete resets the state
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Transaction Failed", style: TextStyle(color: Colors.red)),
                          content: Text("Something went wrong! Your coins are still in your wallet."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("OK", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF29E33C),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: Text(
            AppLocalizations.of(context).translate("next"),
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ),
  );
}
}// Classe pour dessiner l'indicateur circulaire
class CircularProgressPainter extends CustomPainter {
    final double percentage;

  CircularProgressPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    // Cercle de fond
    Paint backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, backgroundPaint);

    // Cercle de progression
    Paint foregroundPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    double sweepAngle = 2 * pi * percentage.clamp(0.0, 1.0); // Limiter entre 0 et 1
    canvas.drawArc(
        Offset(0, 0) & size, -pi / 2, sweepAngle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true; // Repaint à chaque changement

  }