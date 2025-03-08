import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/ViewModels/WalletViewModel.dart';
import 'package:piminnovictus/Views/DashboardClient/TransactionCard.dart';
import 'package:piminnovictus/Views/bachground.dart';
import 'package:provider/provider.dart';
// Import pour la classe User personnalisée
import 'package:piminnovictus/Models/User.dart';

// N'oublie pas d'ajouter table_calendar dans ton pubspec.yaml
import 'package:table_calendar/table_calendar.dart';

const kGreen = Color(0xFF29E33C);
const double padding = 16.0;

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final SessionManager _sessionManager = SessionManager();
  User? currentUser;

  //ajbouni
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  Future<void> _loadWalletData() async {
    String? privateKey = await secureStorage.read(key: 'privateKey');
    String? accountId = await secureStorage.read(key: 'accountId');

    if (accountId != null && privateKey != null) {
      print('-****************AAA***********************-');
      print('Account ID: $accountId');
      print('Private Key: $privateKey');
      print('-****************AAA***********************-');
    } else {
      print('-****************AAA***********************-');
      print('No stored wallet credentials found.');
      print('-****************AAA***********************-');
    }

    final walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    walletViewModel.fetchTokenBalance(accountId!);

     WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletViewModel>(context, listen: false).loadTransactions(accountId);
    });

  }


  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadWalletData();
  }

  Future<void> _loadUserData() async {
    final user = await _sessionManager.getCurrentUser();
    if (user != null) {
      setState(() {
        currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletViewModel = Provider.of<WalletViewModel>(context);

    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            // Fond d'écran flouté
            BlurredRadialBackground(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0),
                    ), // Décalage pour éviter le chevauchement du bouton

                    // Header (avatar + nom)
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage(
                            'assets/user.jpg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: currentUser == null
                              ? const CircularProgressIndicator()
                              : Text(
                                  currentUser!.name,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Solde principal centré et responsive
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${walletViewModel.tokenBalance} GREENO", // Concatenate values properly
                            style: TextStyle(
                              color: kGreen,
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(double.tryParse(walletViewModel.tokenBalance) ?? 0) * 0.25} DT ', 
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage(
                            'assets/Bitcoin.png',
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(  // Ensure text does not overflow
                          child: Text(
                            AppLocalizations.of(context).translate(
                              'For every generated 1000KW \nyou\'ll get 1 GRE',
                            ),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: screenWidth * 0.04,
                              color: const Color.fromARGB(227, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Text(
                      AppLocalizations.of(context)
                          .translate('listOfTransaction'),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),


SizedBox(
  height: MediaQuery.of(context).size.height, // or any specific height
  child: Column(
    mainAxisSize: MainAxisSize.min, 
    children: [
      if (walletViewModel.isLoading)
        Center(child: CircularProgressIndicator())
      else if (walletViewModel.transactions.isEmpty)
        Center(child: Text("No transactions found"))
      else
        Flexible(
        fit: FlexFit.loose,// Ensures the ListView takes the remaining space
          child: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: walletViewModel.transactions.length,
            itemBuilder: (context, index) {
              return TransactionCard(transaction: walletViewModel.transactions[index]);
            },
          ),
        ),
    ],
  ),
),


                    // Coins Activity Tracking (Titre + Calendrier)
                    /*Text(
                      AppLocalizations.of(context)
                          .translate('coinsActivityTracking'),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),*/
                    const SizedBox(height: 16),

                    // Le calendrier dynamique
                    //const CalendarWithTracking(),

                    const SizedBox(height: 32),

                    // Statistic (titre + chart)

                    const SizedBox(height: 16),
                    //const _ChartSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Bouton d'action (sent, receive, buy)
// -----------------------------------------------------------------------------
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      borderRadius: BorderRadius.circular(15), // Arrondi cohérent avec la Card
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.cardColor.withOpacity(0.70), // Fond semi-transparent
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.11) ??
                    MyThemes.primaryColor.withOpacity(0.11),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(23), // Arrondi élégant
            ),
            child: Icon(
              icon,
              color: kGreen,
              size: 28, // Taille ajustée pour une meilleure lisibilité
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: screenWidth * 0.04,
              color: theme.textTheme.titleMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SECTION CHART (exemple simulé)
// -----------------------------------------------------------------------------
class _ChartSection extends StatelessWidget {
  const _ChartSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    // Placeholder chart
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.75), // Fond semi-transparent
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la section "Wallet"
          Text(
            AppLocalizations.of(context).translate('walletOverview'),
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),
          // Graphique
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: theme.cardColor.withOpacity(0.70),
              borderRadius: BorderRadius.circular(18),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.toInt()}',
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        List<String> days = [
                          AppLocalizations.of(context).translate('mon'),
                          AppLocalizations.of(context).translate('tue'),
                          AppLocalizations.of(context).translate('wed'),
                          AppLocalizations.of(context).translate('thu'),
                          AppLocalizations.of(context).translate('fri'),
                          AppLocalizations.of(context).translate('sat'),
                          AppLocalizations.of(context).translate('sun')
                        ];
                        return Text(
                          days[value.toInt() % days.length],
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3.0),
                      const FlSpot(1, 4.0),
                      const FlSpot(2, 3.5),
                      const FlSpot(3, 5.0),
                      const FlSpot(4, 2.5),
                      const FlSpot(5, 4.8),
                      const FlSpot(6, 3.6),
                    ],
                    isCurved: true,
                    color: Color(0xFF2E8F00),
                    barWidth: 4,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFF2E8F00).withOpacity(0.1),
                    ),
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

// -----------------------------------------------------------------------------
// CALENDRIER AVEC table_calendar + TRACKING
// -----------------------------------------------------------------------------
class CalendarWithTracking extends StatefulWidget {
  const CalendarWithTracking({Key? key}) : super(key: key);

  @override
  State<CalendarWithTracking> createState() => _CalendarWithTrackingState();
}

class _CalendarWithTrackingState extends State<CalendarWithTracking> {
  // Date focus et date sélectionnée
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Pour changer le format (mois, 2 semaines, semaine)
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Exemple de data : un Map<DateTime, double> indiquant le trackingLevel
  // de chaque jour. A adapter à ta source de données réelle.
  final Map<DateTime, double> _trackingData = {
    // DateTime(année, mois, jour) : trackingLevel
    DateTime(2025, 2, 1): 0.1,
    DateTime(2025, 2, 2): 0.8,
    DateTime(2025, 2, 3): 0.2,
    DateTime(2025, 2, 4): 1.0,
    DateTime(2025, 2, 13): 0.7,
    DateTime(2025, 2, 18): 0.5,
    // Ajoute autant de dates/valeurs que tu veux
  };

  // Cette fonction récupère le niveau de tracking pour un jour donné
  double _getTrackingLevelForDay(DateTime day) {
    // On ignore l'heure, minute, seconde en comparant juste la date
    final DateTime pureDate = DateTime(day.year, day.month, day.day);
    final theme = Theme.of(context);

    return _trackingData[pureDate] ?? 0.0; // par défaut 0.0 si pas de data
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.70), // Fond semi-transparent
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.11) ??
                  MyThemes.primaryColor.withOpacity(0.11),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(23), // Arrondi élégant
          ),
          child: TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            locale: Provider.of<LanguageProvider>(context).locale.languageCode,
            availableCalendarFormats: {
              CalendarFormat.month:
                  AppLocalizations.of(context).translate('month'),
              CalendarFormat.twoWeeks:
                  AppLocalizations.of(context).translate('twoWeeks'),
              CalendarFormat.week:
                  AppLocalizations.of(context).translate('week'),
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            // Styles d'entête (le mois, les flèches, etc.)
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              leftChevronIcon: Icon(Icons.arrow_left, color: kGreen),
              rightChevronIcon: Icon(Icons.arrow_right, color: kGreen),
              titleTextStyle: const TextStyle(
                color: kGreen,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Style du calendrier
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultTextStyle: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              weekendTextStyle: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              todayDecoration: BoxDecoration(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: kGreen.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final trackingLevel = _getTrackingLevelForDay(day);
                final bool isSelected = isSameDay(day, _selectedDay);
                return _buildDayCell(day, isSelected, trackingLevel);
              },
              todayBuilder: (context, day, focusedDay) {
                final trackingLevel = _getTrackingLevelForDay(day);
                final bool isSelected = isSameDay(day, _selectedDay);
                return _buildDayCell(day, isSelected, trackingLevel,
                    isToday: true);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Légende "Less / More"
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context).translate('less'),
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              AppLocalizations.of(context).translate('more'),
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: kGreen,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Construit la cellule d'un jour, avec la date et le cercle de tracking
  Widget _buildDayCell(
    DateTime day,
    bool isSelected,
    double trackingLevel, {
    bool isToday = false,
  }) {
    final dateString = day.day.toString();
    // Ne pas afficher le cercle si la date est après aujourd'hui
    if (day.isAfter(DateTime.now())) {
      trackingLevel = 0.0;
    }

    // Couleur de fond si sélectionné ou si c'est "today"
    Color dayCircleColor = Colors.transparent;
    if (isSelected) {
      dayCircleColor = kGreen.withOpacity(0.4);
    } else if (isToday) {
      dayCircleColor = kGreen.withOpacity(0.2);
    }

    // Calcul taille et opacité du cercle de tracking
    final double circleSize = 4.0 + (trackingLevel * 6.0);
    final theme = Theme.of(context);

    // De 6 à 12
    final Color circleColor = kGreen.withOpacity(0.3 + (0.7 * trackingLevel));
    // De 0.3 à 1.0

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: dayCircleColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              dateString,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.bodyMedium?.color
                        ?.withOpacity(0.7), // 🔹 Correction ici
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Le cercle de tracking en dessous

          // Affichage du cercle de tracking seulement si la date n'est pas après aujourd'hui
          if (!day.isAfter(DateTime.now()))
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
