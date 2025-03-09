// import 'dart:convert';
// import 'dart:ui'; // Pour le BackdropFilter
// import 'package:flutter/material.dart';
// import 'package:piminnovictus/Models/User.dart';
// import 'package:piminnovictus/Models/config/language/translations.dart';
// import 'package:piminnovictus/Providers/language_provider.dart';
// import 'package:piminnovictus/Services/Const.dart';
// import 'package:piminnovictus/Services/session_manager.dart';
// import 'package:piminnovictus/Views/AuthViews/login_view.dart';
// import 'package:piminnovictus/Views/AuthViews/privacy_policy.dart';
// import 'package:piminnovictus/Views/AuthViews/terms_and_conditions.dart';
// import 'package:provider/provider.dart';
// import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
// import 'package:http/http.dart' as http;
//
// import '../../Services/AuthController.dart';
//
// class EditProfile extends StatefulWidget {
//   const EditProfile({Key? key}) : super(key: key);
//
//   @override
//   _EditProfileState createState() => _EditProfileState();
// }
//
// class _EditProfileState extends State<EditProfile> {
//   // Au début de la classe _EditProfileState, ajoutez :
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _currentPasswordController =
//       TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   bool _isPasswordVisible = false;
//   bool isSaveButtonEnabled = false;
//
//   final SessionManager _sessionManager = SessionManager();
//   User? currentUser;
//   bool isPreferencesExpanded = false;
//   bool isProfileInformationsExpanded = false;
//   bool isPersonalInfoExpanded = false;
//   bool isPasswordExpanded = false;
//   bool isDarkModeExpanded = false;
//   bool isLanguageExpanded = false;
//   String selectedLanguage = 'en';
//   bool isTermsExpanded = false;
//   bool isAccountExpanded = false;
//
//   bool isSavePasswordButtonEnabled = false;
//   // Ajout de variables pour la validation des champs de mot de passe
//   bool isCurrentPasswordCorrect = false;
//   bool isNewPasswordValid = false;
//   bool isConfirmPasswordMatch = false;
//
//   //String userId = _sessionManager._keyUserId;
//
//   AuthController auth = AuthController();
//
//   String? userId;
//   @override
//   void initState() {
//     _currentPasswordController.addListener(_checkPasswordFields);
//     _newPasswordController.addListener(_checkPasswordFields);
//     _confirmPasswordController.addListener(_checkPasswordFields);
//
//     super.initState();
//     _loadUserData();
//     Future<String?> userId = _sessionManager.getUserId();
//     print("userrrrrrc  $userId");
//   }
//
//   // Update validation method to return validation state
//   bool _validatePassword(String password) {
//     // Vérifie si le mot de passe a au moins 6 caractères
//     if (password.length < 6) {
//       return false;
//     }
//     // Vérifie si le mot de passe contient au moins un caractère spécial
//     RegExp specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
//     return specialChar.hasMatch(password);
//   }
//
//   bool _isCurrentPasswordCorrect(String password) {
//     // Simulation - À remplacer par votre logique de validation réelle
//     if (currentUser != null) {
//       // Exemple: Dans un cas réel, vous feriez une vérification avec le backend
//       return password.isNotEmpty; // Validation simplifiée pour l'exemple
//     }
//     return false;
//   }
//
//   // Duplicate method removed
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _currentPasswordController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadUserData() async {
//     final user = await _sessionManager.getCurrentUser();
//     userId = await _sessionManager.getUserId();
//     if (user != null) {
//       setState(() {
//         currentUser = user;
//         _nameController.text = user.name;
//         _emailController.text = user.email ?? '';
//         _phoneController.text = user.phoneNumber ?? '';
//       });
//     }
//   }
//
//   void _checkPasswordFields() {
//     setState(() {
//       // Vérifier si le mot de passe actuel est correct
//       isCurrentPasswordCorrect =
//           _isCurrentPasswordCorrect(_currentPasswordController.text);
//
//       // Vérifier si le nouveau mot de passe est valide
//       isNewPasswordValid = _validatePassword(_newPasswordController.text);
//
//       // Vérifier si la confirmation correspond au nouveau mot de passe
//       isConfirmPasswordMatch =
//           _newPasswordController.text == _confirmPasswordController.text;
//
//       // Activer ou désactiver le bouton de sauvegarde en fonction des validations
//       isSavePasswordButtonEnabled =
//           _currentPasswordController.text.isNotEmpty &&
//               _newPasswordController.text.isNotEmpty &&
//               _confirmPasswordController.text.isNotEmpty &&
//               isCurrentPasswordCorrect &&
//               isNewPasswordValid &&
//               isConfirmPasswordMatch;
//     });
//   }
//
//   Future<void> _changePassword() async {
//     // Vérifier si les champs sont vides
//     if (_currentPasswordController.text.isEmpty ||
//         _newPasswordController.text.isEmpty ||
//         _confirmPasswordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               AppLocalizations.of(context).translate('fillAllFields') ??
//                   "Veuillez remplir tous les champs"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//     // Vérifier si le nouveau mot de passe est valide
//     if (!isNewPasswordValid) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(AppLocalizations.of(context)
//                   .translate('passwordRequirements') ??
//               "Le mot de passe doit contenir au moins 6 caractères et un caractère spécial"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     // Vérifier si la confirmation correspond
//     if (!isConfirmPasswordMatch) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Les mots de passe ne correspondent pas"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//     if (currentUser == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Utilisateur introuvable"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     String userId = currentUser!.id;
//     String currentPassword = _currentPasswordController.text;
//     String newPassword = _newPasswordController.text;
//     String confirmPassword = _confirmPasswordController.text;
//
// // Crée une instance de la classe Const
//     final constInstance = Const();
//
// // Utilise la constante url de cette instance
//     final url = '${constInstance.url}/auth/change-password';
//
//     try {
//       final response = await http.put(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'userId': userId,
//           'oldPassword': currentPassword,
//           'newPassword': newPassword,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Mot de passe modifié avec succès"),
//             backgroundColor: Colors.green,
//           ),
//         );
//         _currentPasswordController.clear();
//         _newPasswordController.clear();
//         _confirmPasswordController.clear();
//         setState(() {
//           isCurrentPasswordCorrect = false;
//           isNewPasswordValid = false;
//           isConfirmPasswordMatch = false;
//           isSavePasswordButtonEnabled = false;
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Erreur : ${response.body}"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Erreur de connexion : $error"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Future<void> _updateUserProfile() async {
//     if (currentUser == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               AppLocalizations.of(context).translate('userNotFound') ??
//                   "Utilisateur introuvable"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     // Check if any changes were made
//     if (_nameController.text == currentUser!.name &&
//         _emailController.text == currentUser!.email &&
//         _phoneController.text == currentUser!.phoneNumber) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(AppLocalizations.of(context).translate('noChanges') ??
//               "Aucune modification détectée"),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }
//
//     // Retrieve authentication token
//     final token = await _sessionManager.getToken();
//     if (token == null || token.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               AppLocalizations.of(context).translate('sessionExpired') ??
//                   "Session expirée, veuillez vous reconnecter"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       // Rediriger vers la page de connexion
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => LoginView()),
//         (route) => false,
//       );
//       return;
//     }
//     // Create Const instance for API URL
//     final constInstance = Const();
//     // Pour le développement local avec émulateur, utilisez 10.0.2.2 au lieu de 192.168.1.13
//     final url = '${constInstance.url}/auth/update-user';
//
//     try {
//       // Show loading indicator
//       setState(() {
//         isSaveButtonEnabled = false;
//       });
//
//       // Afficher un dialogue de chargement
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: Row(
//               children: [
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF29E33C)),
//                 ),
//                 SizedBox(width: 20),
//                 Text("Mise à jour en cours..."),
//               ],
//             ),
//           );
//         },
//       );
//
//       // Prepare data to update - only include fields that changed
//       final updateData = {
//         if (_nameController.text != currentUser!.name)
//           'name': _nameController.text,
//         if (_emailController.text != currentUser!.email)
//           'email': _emailController.text,
//         if (_phoneController.text != currentUser!.phoneNumber)
//           'phoneNumber': _phoneController.text,
//       };
//
//       // Debug prints
//       print("URL: $url");
//       print("Token: $token");
//       print("Update data: ${jsonEncode(updateData)}");
//
//       // Send PATCH request with increased timeout
//       final response = await http
//           .patch(
//             Uri.parse(url),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonEncode(updateData),
//           )
//           .timeout(const Duration(seconds: 30));
//
//       // Fermer le dialogue de chargement
//       Navigator.of(context).pop();
//
//       if (response.statusCode == 200) {
//         // Successful update
//         final updatedUserData = jsonDecode(response.body);
//         final updatedUser = User(
//           id: currentUser!.id,
//           name: updatedUserData['name'] ?? currentUser!.name,
//           email: updatedUserData['email'] ?? currentUser!.email,
//           phoneNumber:
//               updatedUserData['phoneNumber'] ?? currentUser!.phoneNumber,
//         );
//
//         // Update user session
//         await _sessionManager.saveUser(updatedUser);
//
//         // Update UI state
//         setState(() {
//           currentUser = updatedUser;
//           _nameController.text = updatedUser.name;
//           _emailController.text = updatedUser.email ?? '';
//           _phoneController.text = updatedUser.phoneNumber ?? '';
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//                 AppLocalizations.of(context).translate('profileUpdated') ??
//                     "Profil mis à jour avec succès"),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } else {
//         // Handle errors
//         Map<String, dynamic> errorData = {};
//         try {
//           errorData = jsonDecode(response.body);
//         } catch (_) {}
//
//         String errorMessage = errorData['message'] ??
//             "Erreur lors de la mise à jour du profil (${response.statusCode})";
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(errorMessage),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (error) {
//       // Fermer le dialogue de chargement si une erreur se produit
//       if (Navigator.of(context).canPop()) {
//         Navigator.of(context).pop();
//       }
//
//       String errorMessage = "Erreur de connexion";
//       if (error.toString().contains("SocketException") ||
//           error.toString().contains("Connection timed out")) {
//         errorMessage =
//             "Impossible de se connecter au serveur. Vérifiez votre connexion réseau et l'URL du serveur.";
//       } else {
//         errorMessage = "Erreur de connexion : $error";
//       }
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       // Re-enable save button
//       setState(() {
//         isSaveButtonEnabled = true;
//       });
//     }
//   }
//
//   // Fonction pour afficher le pop-up de confirmation
//   void _showConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Confirmer les changements'),
//           content:
//               Text('Êtes-vous sûr de vouloir enregistrer ce mot de passe ?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Ferme la boîte de dialogue
//               },
//               child: Text('Annuler'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Appelle la fonction pour enregistrer et fermer la carte
//                 _changePassword();
//                 setState(() {
//                   // Ferme la carte et rafraîchit la page
//                   isPasswordExpanded = false;
//                   // Réinitialise les champs (si nécessaire)
//                   _currentPasswordController.clear();
//                   _newPasswordController.clear();
//                   _confirmPasswordController.clear();
//                 });
//                 Navigator.of(context).pop(); // Ferme la boîte de dialogue
//               },
//               child: Text('Enregistrer'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return Scaffold(
//           body: Stack(
//             children: [
//               // Fond adapté au mode clair ou sombre
//               Positioned.fill(
//                 child:
//                     isDarkMode ? _darkModeBackground() : _lightModeBackground(),
//               ),
//               // Contenu principal avec flou d'arrière-plan
//               BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
//                 child: SafeArea(
//                   child: LayoutBuilder(builder: (context, constraints) {
//                     physics:
//                     const AlwaysScrollableScrollPhysics();
//
//                     return SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 70),
//                           // Image du profil et informations
//                           Stack(
//                             children: [
//                               const CircleAvatar(
//                                 radius: 50,
//                                 backgroundImage: AssetImage('assets/user.jpg'),
//                               ),
//                               Positioned(
//                                 bottom: 5,
//                                 right: 5,
//                                 child: Container(
//                                   padding: const EdgeInsets.all(3),
//                                   decoration: BoxDecoration(
//                                     color: Theme.of(context).iconTheme.color,
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color: const Color(0xFF29E33C),
//                                       width: 2,
//                                     ),
//                                   ),
//                                   child: const Icon(Icons.check,
//                                       color: Colors.white, size: 14),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 15),
//                           currentUser == null
//                               ? const CircularProgressIndicator()
//                               : Text(
//                                   currentUser!.name,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.normal,
//                                     color: Theme.of(context)
//                                         .textTheme
//                                         .bodyMedium
//                                         ?.color,
//                                   ),
//                                 ),
//
//                           currentUser == null
//                               ? const CircularProgressIndicator()
//                               : Text(
//                                   currentUser!.email ?? '',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.normal,
//                                     color: Theme.of(context)
//                                         .textTheme
//                                         .bodyMedium
//                                         ?.color,
//                                   ),
//                                 ),
//
//                           const SizedBox(height: 5),
//
//                           const SizedBox(height: 30),
//
//                           _buildPreferencesCard(context),
//                           const SizedBox(height: 10),
//                           // Carte Preferences intégrée
//                           _buildProfileInformationsCard(context),
//                           const SizedBox(height: 10),
//
//                           _buildTermssCard(context),
//
//                           _buildAccountCard(context),
//
//                           // Item Logout
//
//                           const SizedBox(height: 10),
//                           // Item Logout
//                           _buildMenuItem(
//                             context,
//                             icon: Icons.logout,
//                             title: AppLocalizations.of(context)
//                                 .translate('logout'),
//                             onTap: () async {
//                               // Show confirmation dialog
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   final dialogWidth =
//                                       MediaQuery.of(context).size.width * 0.8;
//                                   final dialogHeight =
//                                       MediaQuery.of(context).size.height * 0.2;
//
//                                   return Dialog(
//                                     backgroundColor: Colors.transparent,
//                                     elevation: 0,
//                                     child: Container(
//                                       width: dialogWidth,
//                                       height: dialogHeight,
//                                       decoration: BoxDecoration(
//                                         color: Theme.of(context)
//                                             .cardColor
//                                             .withOpacity(0.90),
//                                         borderRadius: BorderRadius.circular(20),
//                                         border: Border.all(
//                                           color: Colors.white.withOpacity(0.2),
//                                           width: 1,
//                                         ),
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             AppLocalizations.of(context)
//                                                 .translate("logout"),
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .titleLarge
//                                                 ?.copyWith(
//                                                   fontSize: dialogWidth * 0.06,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                           ),
//                                           SizedBox(height: dialogHeight * 0.1),
//                                           Text(
//                                             AppLocalizations.of(context)
//                                                 .translate("logoutmsg"),
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .titleLarge
//                                                 ?.copyWith(
//                                                   fontSize: dialogWidth * 0.05,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                           SizedBox(height: dialogHeight * 0.1),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               SizedBox(
//                                                 width: dialogWidth * 0.35,
//                                                 height: dialogHeight * 0.25,
//                                                 child: OutlinedButton(
//                                                   onPressed: () =>
//                                                       Navigator.pop(context),
//                                                   style:
//                                                       OutlinedButton.styleFrom(
//                                                     side: const BorderSide(
//                                                       color: Color(0xFF29E33C),
//                                                       width: 2,
//                                                     ),
//                                                     shape:
//                                                         RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               20),
//                                                     ),
//                                                     padding: EdgeInsets.zero,
//                                                   ),
//                                                   child: Text(
//                                                     AppLocalizations.of(context)
//                                                         .translate("cancel"),
//                                                     style: TextStyle(
//                                                       color: const Color(
//                                                           0xFF29E33C),
//                                                       fontSize:
//                                                           dialogWidth * 0.06,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                   width: dialogWidth * 0.04),
//                                               SizedBox(
//                                                 width: dialogWidth * 0.35,
//                                                 height: dialogHeight * 0.25,
//                                                 child: DecoratedBox(
//                                                   decoration: BoxDecoration(
//                                                     gradient:
//                                                         const LinearGradient(
//                                                       colors: [
//                                                         Color(0xFF29E33C),
//                                                         Color.fromARGB(
//                                                             255, 9, 128, 25)
//                                                       ],
//                                                       begin: Alignment.topLeft,
//                                                       end:
//                                                           Alignment.bottomRight,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20),
//                                                   ),
//                                                   child: ElevatedButton(
//                                                     onPressed: () async {
//                                                       Navigator.pop(
//                                                           context); // Close dialog
//                                                       final sessionManager =
//                                                           SessionManager();
//
//                                                       // Clear the session
//                                                       await sessionManager
//                                                           .clearSession();
//
//                                                       // Navigate to welcome page and clear all previous routes
//                                                       Navigator.of(context)
//                                                           .pushAndRemoveUntil(
//                                                         MaterialPageRoute(
//                                                             builder: (context) =>
//                                                                 LoginView()),
//                                                         (route) =>
//                                                             false, // This removes all previous routes
//                                                       );
//                                                     },
//                                                     style: ElevatedButton
//                                                         .styleFrom(
//                                                       backgroundColor:
//                                                           Colors.transparent,
//                                                       shadowColor:
//                                                           Colors.transparent,
//                                                       padding: EdgeInsets.zero,
//                                                       shape:
//                                                           RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(20),
//                                                       ),
//                                                     ),
//                                                     child: Text(
//                                                       AppLocalizations.of(
//                                                               context)
//                                                           .translate("logout"),
//                                                       style: TextStyle(
//                                                         color: Colors.white,
//                                                         fontSize:
//                                                             dialogWidth * 0.06,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                           const SizedBox(height: 30),
//                         ],
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Fond pour le mode clair
//   Widget _lightModeBackground() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             const Color(0xFF93DAB2).withOpacity(0.8),
//             Colors.white.withOpacity(0.5),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Fond pour le mode sombre
//   Widget _darkModeBackground() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           center: Alignment.center,
//           radius: 1.5,
//           colors: [
//             const Color(0xFF0A140C),
//             const Color(0xFF0D0F0D).withOpacity(0.6),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget générique pour un menu item standard
//   Widget _buildMenuItem(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     VoidCallback? onTap,
//     Widget? switchWidget,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 60,
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(17),
//           border: Border.all(
//             color: const Color(0xFF29E33C),
//             width: 0,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: Theme.of(context).iconTheme.color),
//                 const SizedBox(width: 10),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Theme.of(context).textTheme.bodyMedium?.color,
//                   ),
//                 ),
//               ],
//             ),
//             switchWidget ?? const Icon(Icons.chevron_right, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileInformationsCard(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isProfileInformationsExpanded = !isProfileInformationsExpanded;
//
//           // Réinitialiser l'expansion des sous-cartes lors de la fermeture
//           if (!isProfileInformationsExpanded) {
//             isPersonalInfoExpanded = false;
//             isPasswordExpanded = false;
//           }
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(17),
//           border: Border.all(
//             color: const Color(0xFF29E33C),
//             width: 0,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // En-tête de la carte Preferences
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.person,
//                         color: Theme.of(context).iconTheme.color),
//                     const SizedBox(width: 10),
//                     Text(
//                       AppLocalizations.of(context)
//                           .translate('profileInformation'),
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Theme.of(context).textTheme.bodyMedium?.color,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Icon(
//                   isProfileInformationsExpanded
//                       ? Icons.expand_more
//                       : Icons.chevron_right,
//                   color: Colors.grey,
//                 ),
//               ],
//             ),
//             if (isProfileInformationsExpanded) ...[
//               const SizedBox(height: 16),
//               // Sous-carte : Personal Informations
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     isPersonalInfoExpanded = !isPersonalInfoExpanded;
//                   });
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: const Color(0xFF29E33C),
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // En-tête de la sous-carte Personal Informations
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             AppLocalizations.of(context)
//                                 .translate('personalInformation'),
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color:
//                                   Theme.of(context).textTheme.bodyMedium?.color,
//                             ),
//                           ),
//                           Icon(
//                             isPersonalInfoExpanded
//                                 ? Icons.expand_more
//                                 : Icons.chevron_right,
//                             color: Colors.grey,
//                           ),
//                         ],
//                       ),
//                       if (isPersonalInfoExpanded) ...[
//                         const SizedBox(height: 15),
//                         TextField(
//                           controller: _nameController,
//                           onChanged: (value) {
//                             setState(() {
//                               isSaveButtonEnabled = value.isNotEmpty &&
//                                   (value != currentUser?.name ||
//                                       _emailController.text !=
//                                           currentUser?.email ||
//                                       _phoneController.text !=
//                                           currentUser?.phoneNumber);
//                             });
//                           },
//                           decoration: InputDecoration(
//                             labelText: AppLocalizations.of(context)
//                                 .translate('username'),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(width: 0.5),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         TextField(
//                           controller: _emailController,
//                           onChanged: (value) {
//                             setState(() {
//                               isSaveButtonEnabled = value.isNotEmpty &&
//                                   (value != currentUser?.email ||
//                                       _nameController.text !=
//                                           currentUser?.name ||
//                                       _phoneController.text !=
//                                           currentUser?.phoneNumber);
//                             });
//                           },
//                           decoration: InputDecoration(
//                             labelText:
//                                 AppLocalizations.of(context).translate('email'),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(width: 0.5),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         TextField(
//                           controller: _phoneController,
//                           onChanged: (value) {
//                             setState(() {
//                               isSaveButtonEnabled = _nameController.text !=
//                                       currentUser?.name ||
//                                   _emailController.text != currentUser?.email ||
//                                   value != currentUser?.phoneNumber;
//                             });
//                           },
//                           decoration: InputDecoration(
//                             labelText:
//                                 AppLocalizations.of(context).translate('phone'),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(width: 0.5),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             ElevatedButton(
//                               onPressed: isSaveButtonEnabled
//                                   ? () async {
//
//                                       print(11);
//                                       print(userId);
//                                       // ✅ Fonction anonyme correcte
//                                       await auth.updateUser(
//                                         userId!,
//                                         _nameController.text,
//                                         _emailController.text,
//                                         _phoneController.text,
//                                       );
//                                       // Vérifier si des modifications ont été apportées
//                                       bool isUpdated = _nameController.text !=
//                                               currentUser?.name ||
//                                           _emailController.text !=
//                                               currentUser?.email ||
//                                           _phoneController.text !=
//                                               currentUser?.phoneNumber;
//
//                                       if (isUpdated) {
//                                         // Effectuer la mise à jour si des modifications ont eu lieu
//                                         await auth.updateUser(
//                                           userId!,
//                                           _nameController.text,
//                                           _emailController.text,
//                                           _phoneController.text,
//                                         );
//                                         // Afficher le popup "User updated successfully"
//                                         showDialog(
//                                           context: context,
//                                           builder: (BuildContext context) {
//                                             return AlertDialog(
//                                               title: Text('Success'),
//                                               content: Text(
//                                                   'User updated successfully'),
//                                               actions: [
//                                                 TextButton(
//                                                   onPressed: () {
//                                                     Navigator.of(context)
//                                                         .pop(); // Ferme le popup
//                                                   },
//                                                   child: Text('OK'),
//                                                 ),
//                                               ],
//                                             );
//                                           },
//                                         );
//                                       } else {
//                                         // Afficher le popup "No update" si aucune donnée n'a été modifiée
//                                         showDialog(
//                                           context: context,
//                                           builder: (BuildContext context) {
//                                             return AlertDialog(
//                                               title: Text('No Update'),
//                                               content: Text(
//                                                   'No changes were made to the user information'),
//                                               actions: [
//                                                 TextButton(
//                                                   onPressed: () {
//                                                     Navigator.of(context)
//                                                         .pop(); // Ferme le popup
//                                                   },
//                                                   child: Text('OK'),
//                                                 ),
//                                               ],
//                                             );
//                                           },
//                                         );
//                                       }
//                                     }
//                                   : null,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: isSaveButtonEnabled
//                                     ? const Color(0xFF29E33C)
//                                     : Colors.grey,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 30, vertical: 12),
//                               ),
//                               child: Text(
//                                 AppLocalizations.of(context).translate('save'),
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Sous-carte : Password
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     isPasswordExpanded = !isPasswordExpanded;
//                   });
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: const Color(0xFF29E33C),
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // En-tête de la sous-carte Password
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             AppLocalizations.of(context).translate('password'),
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color:
//                                   Theme.of(context).textTheme.bodyMedium?.color,
//                             ),
//                           ),
//                           Icon(
//                             isPasswordExpanded
//                                 ? Icons.expand_more
//                                 : Icons.chevron_right,
//                             color: Colors.grey,
//                           ),
//                         ],
//                       ),
//                       if (isPasswordExpanded) ...[
//                         const SizedBox(height: 15),
//                         TextField(
//                           controller: _currentPasswordController,
//                           obscureText: !_isPasswordVisible,
//                           decoration: InputDecoration(
//                             hintText: AppLocalizations.of(context)
//                                 .translate('currentPassword'),
//                             filled: true,
//                             fillColor: Theme.of(context)
//                                 .inputDecorationTheme
//                                 .fillColor,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide:
//                                   BorderSide(color: Colors.white, width: 1),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color:
//                                     _currentPasswordController.text.isNotEmpty
//                                         ? (isCurrentPasswordCorrect
//                                             ? Colors.green
//                                             : Colors.red)
//                                         : Theme.of(context).primaryColor,
//                                 color: _currentPasswordController
//                                         .text.isNotEmpty
//                                     ? (isCurrentPasswordCorrect
//                                         ? Colors
//                                             .green // Vert si le mot de passe est correct
//                                         : Colors
//                                             .red) // Rouge si le mot de passe est incorrect
//                                     : Theme.of(context).primaryColor,
//                                 width: 0.5,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color: _currentPasswordController
//                                         .text.isNotEmpty
//                                     ? Colors.red
//                                     : _currentPasswordController.text.isNotEmpty
//                                         ? Theme.of(context).primaryColor
//                                         : Colors.white,
//                                     ? (isCurrentPasswordCorrect
//                                         ? Colors
//                                             .green // Vert si le mot de passe est correct
//                                         : Colors
//                                             .red) // Rouge si le mot de passe est incorrect
//                                     : Theme.of(context).primaryColor,
//                                 width: 0.5,
//                               ),
//                             ),
//                             contentPadding: EdgeInsets.only(left: 20),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _isPasswordVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: Theme.of(context).iconTheme.color,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _isPasswordVisible = !_isPasswordVisible;
//                                 });
//                               },
//                             ),
//                           ),
//                           onChanged: (value) {
//                             setState(() {
//                               isCurrentPasswordCorrect =
//                                   _isCurrentPasswordCorrect(value);
//                             });
//                             _checkPasswordFields();
//                           },
//                         ),
//
//                         const SizedBox(height: 15),
//                         TextField(
//                           controller: _newPasswordController,
//                           obscureText: !_isPasswordVisible,
//                           decoration: InputDecoration(
//                             hintText: AppLocalizations.of(context)
//                                 .translate('newPassword'),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color: _newPasswordController.text.isNotEmpty
//                                     ? (isNewPasswordValid
//                                         ? Colors.green
//                                         : Colors.red)
//                                     : Colors.white,
//                                 width: 0.5,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color: _newPasswordController.text.isNotEmpty
//                                     ? (isNewPasswordValid
//                                         ? Colors.green
//                                         : Colors.red)
//                                     : Theme.of(context).primaryColor,
//                                 width: 1.5,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color: _newPasswordController.text.isNotEmpty
//                                     ? (isNewPasswordValid
//                                         ? Colors.green
//                                         : Colors.red)
//                                     : Colors.white,
//                                 width: 0.5,
//                               ),
//                             ),
//                             contentPadding: const EdgeInsets.only(left: 20),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _isPasswordVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: Theme.of(context).iconTheme.color,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _isPasswordVisible = !_isPasswordVisible;
//                                 });
//                               },
//                             ),
//                           ),
//                           onChanged: (value) {
//                             setState(() {
//                               isNewPasswordValid = _validatePassword(value);
//                               // Vérifier si le mot de passe de confirmation correspond
//                               if (_confirmPasswordController.text.isNotEmpty) {
//                                 isConfirmPasswordMatch =
//                                     value == _confirmPasswordController.text;
//                               }
//                             });
//                             _checkPasswordFields();
//                           },
//                         ),
//                         const SizedBox(height: 15),
//                         TextField(
//                           controller: _confirmPasswordController,
//                           obscureText: !_isPasswordVisible,
//                           decoration: InputDecoration(
//                             hintText: AppLocalizations.of(context)
//                                 .translate('confirmPassword'),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color:
//                                     _confirmPasswordController.text.isNotEmpty
//                                         ? (isConfirmPasswordMatch
//                                             ? Colors.green
//                                             : Colors.red)
//                                         : Colors.white,
//                                 width: 0.5,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color:
//                                     _confirmPasswordController.text.isNotEmpty
//                                         ? (isConfirmPasswordMatch
//                                             ? Colors.green
//                                             : Colors.red)
//                                         : Theme.of(context).primaryColor,
//                                         : Colors.white,
//                                 width: 1.5,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color:
//                                     _confirmPasswordController.text.isNotEmpty
//                                         ? (isConfirmPasswordMatch
//                                             ? Colors.green
//                                             : Colors.red)
//                                         : Colors.white,
//                                 width: 0.5,
//                               ),
//                             ),
//                             contentPadding: const EdgeInsets.only(left: 20),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _isPasswordVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: Theme.of(context).iconTheme.color,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _isPasswordVisible = !_isPasswordVisible;
//                                 });
//                               },
//                             ),
//                           ),
//                           onChanged: (value) {
//                             setState(() {
//                               isConfirmPasswordMatch =
//                                   value == _newPasswordController.text;
//                             });
//                             _checkPasswordFields();
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         // Bouton "Save" aligné à droite
//                         // Bouton "Save" aligné à droite
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             ElevatedButton(
//                               onPressed: isSavePasswordButtonEnabled
//                                   ? _changePassword
//
//                                   ? () => _showConfirmationDialog(
//                                       context, _changePassword)
//                                   : null,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: isSavePasswordButtonEnabled
//                                     ? const Color(0xFF29E33C)
//                                     : Colors.grey,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 30, vertical: 12),
//                               ),
//                               child: Text(
//                                 AppLocalizations.of(context).translate('save'),
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPreferencesCard(BuildContext context) {
//     final languageProvider =
//         Provider.of<LanguageProvider>(context, listen: false);
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isPreferencesExpanded = !isPreferencesExpanded;
//           if (!isPreferencesExpanded) {
//             isDarkModeExpanded = false;
//             isLanguageExpanded = false;
//           }
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(17),
//           border: Border.all(
//             color: const Color(0xFF29E33C),
//             width: 0,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Preferences card header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.settings,
//                         color: Theme.of(context).iconTheme.color),
//                     const SizedBox(width: 10),
//                     Text(
//                       AppLocalizations.of(context).translate('preferences'),
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Theme.of(context).textTheme.bodyMedium?.color,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Icon(
//                   isPreferencesExpanded
//                       ? Icons.expand_more
//                       : Icons.chevron_right,
//                   color: Colors.grey,
//                 ),
//               ],
//             ),
//             if (isPreferencesExpanded) ...[
//               const SizedBox(height: 16),
//               // Dark Mode card
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 2.5),
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: const Color(0xFF29E33C),
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   // Changed from Row to Column to match language card structure
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(Icons.dark_mode,
//                                 color: Theme.of(context).iconTheme.color),
//                             const SizedBox(width: 10),
//                             Text(
//                               AppLocalizations.of(context)
//                                   .translate('darkMode'),
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium
//                                     ?.color,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Consumer<ThemeProvider>(
//                           builder: (context, themeProvider, child) {
//                             return Switch(
//                               value: themeProvider.isDarkMode,
//                               onChanged: (value) {
//                                 themeProvider.toggleTheme(value);
//                               },
//                               activeColor: Theme.of(context).iconTheme.color,
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
// // Language Selection card
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     isLanguageExpanded = !isLanguageExpanded;
//                   });
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: const Color(0xFF29E33C),
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.language,
//                                   color: Theme.of(context).iconTheme.color),
//                               const SizedBox(width: 10),
//                               Text(
//                                 AppLocalizations.of(context)
//                                     .translate('language'),
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium
//                                       ?.color,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Icon(
//                             isLanguageExpanded
//                                 ? Icons.expand_more
//                                 : Icons.chevron_right,
//                             color: Colors.grey,
//                           ),
//                         ],
//                       ),
//                       if (isLanguageExpanded) ...[
//                         const SizedBox(height: 15),
//                         // English Option
//                         ListTile(
//                           title: Text(
//                             AppLocalizations.of(context).translate('english'),
//                             style: TextStyle(
//                               color:
//                                   Theme.of(context).textTheme.bodyMedium?.color,
//                             ),
//                           ),
//                           onTap: () {
//                             languageProvider.setLocale(
//                                 const Locale('en')); // Set to English
//                           },
//                           trailing: languageProvider.locale.languageCode == 'en'
//                               ? Icon(Icons.check,
//                                   color: Theme.of(context).iconTheme.color)
//                               : null,
//                         ),
//                         // French Option
//                         ListTile(
//                           title: Text(
//                             AppLocalizations.of(context).translate('french'),
//                             style: TextStyle(
//                               color:
//                                   Theme.of(context).textTheme.bodyMedium?.color,
//                             ),
//                           ),
//                           onTap: () {
//                             languageProvider
//                                 .setLocale(const Locale('fr')); // Set to French
//                           },
//                           trailing: languageProvider.locale.languageCode == 'fr'
//                               ? Icon(Icons.check,
//                                   color: Theme.of(context).iconTheme.color)
//                               : null,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Save button
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTermssCard(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isTermsExpanded = !isTermsExpanded;
//           // Reset sub-cards expansion when closing
//           if (!isTermsExpanded) {
//             isDarkModeExpanded = false;
//             isLanguageExpanded = false;
//           }
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(17),
//           border: Border.all(
//             color: const Color(0xFF29E33C),
//             width: 0,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Preferences card header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.shield_outlined,
//                         color: Theme.of(context).iconTheme.color),
//                     const SizedBox(width: 10),
//                     Text(
//                       AppLocalizations.of(context).translate('termsAndPrivacy'),
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Theme.of(context).textTheme.bodyMedium?.color,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Icon(
//                   isTermsExpanded ? Icons.expand_more : Icons.chevron_right,
//                   color: Colors.grey,
//                 ),
//               ],
//             ),
//             if (isTermsExpanded) ...[
//               const SizedBox(height: 16),
//               // Terms & Conditions card
//               // Terms & Conditions card
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const TermsAndConditionsScreen(),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: const Color(0xFF29E33C),
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.description_outlined,
//                               color: Theme.of(context).iconTheme.color),
//                           const SizedBox(width: 10),
//                           Text(
//                             AppLocalizations.of(context)
//                                 .translate('termsAndConditions'),
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color:
//                                   Theme.of(context).textTheme.bodyMedium?.color,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Icon(
//                         Icons.chevron_right,
//                         color: Colors.grey,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Privacy Policy card
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const PrivacyPolicyScreen(),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: const Color(0xFF29E33C),
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.privacy_tip_outlined,
//                               color: Theme.of(context).iconTheme.color),
//                           const SizedBox(width: 10),
//                           Text(
//                             AppLocalizations.of(context)
//                                 .translate('privacyPolicy'),
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color:
//                                   Theme.of(context).textTheme.bodyMedium?.color,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Icon(
//                         Icons.chevron_right,
//                         color: Colors.grey,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAccountCard(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isAccountExpanded = !isAccountExpanded;
//           // Reset sub-cards expansion when closing
//           if (!isAccountExpanded) {
//             isDarkModeExpanded = false;
//             isLanguageExpanded = false;
//           }
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(17),
//           border: Border.all(
//             color: const Color(0xFF29E33C),
//             width: 0,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Account Management card header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.account_balance,
//                         color: Theme.of(context).iconTheme.color),
//                     const SizedBox(width: 10),
//                     Text(
//                       AppLocalizations.of(context)
//                           .translate('Account Management'),
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Theme.of(context).textTheme.bodyMedium?.color,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Icon(
//                   isAccountExpanded ? Icons.expand_more : Icons.chevron_right,
//                   color: Colors.grey,
//                 ),
//               ],
//             ),
//             if (isAccountExpanded) ...[
//               const SizedBox(height: 16),
//               GestureDetector(
//                 onTap: () {
//                   // Navigate to profile creation screen
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) => const CreateProfileScreen(),
//                   //   ),
//                   // );
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: const Color(0xFF29E33C),
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.person_add,
//                               color: Theme.of(context).iconTheme.color),
//                           const SizedBox(width: 10),
//                           Text(
//                             AppLocalizations.of(context)
//                                 .translate('Create Profile'),
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color:
//                                   Theme.of(context).textTheme.bodyMedium?.color,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Icon(
//                         Icons.chevron_right,
//                         color: Colors.grey,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 4),
//
//               // Delete Account card
//               GestureDetector(
//                 onTap: () {
//                   // Show delete account confirmation dialog
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       final dialogWidth =
//                           MediaQuery.of(context).size.width * 0.8;
//                       final dialogHeight =
//                           MediaQuery.of(context).size.height * 0.2;
//
//                       return Dialog(
//                         backgroundColor: Colors.transparent,
//                         elevation: 0,
//                         child: Container(
//                           width: dialogWidth,
//                           height: dialogHeight,
//                           decoration: BoxDecoration(
//                             color:
//                                 Theme.of(context).cardColor.withOpacity(0.90),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.2),
//                               width: 1,
//                             ),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 AppLocalizations.of(context)
//                                     .translate("Delete Account"),
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge
//                                     ?.copyWith(
//                                       fontSize: dialogWidth * 0.06,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                               ),
//                               SizedBox(height: dialogHeight * 0.1),
//                               Text(
//                                 AppLocalizations.of(context).translate(
//                                     "Are you sure you want to delete your account?"),
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge
//                                     ?.copyWith(
//                                       fontSize: dialogWidth * 0.05,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(height: dialogHeight * 0.1),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: dialogWidth * 0.35,
//                                     height: dialogHeight * 0.25,
//                                     child: OutlinedButton(
//                                       onPressed: () => Navigator.pop(context),
//                                       style: OutlinedButton.styleFrom(
//                                         side: const BorderSide(
//                                           color: Color(0xFF29E33C),
//                                           width: 2,
//                                         ),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                         ),
//                                         padding: EdgeInsets.zero,
//                                       ),
//                                       child: Text(
//                                         AppLocalizations.of(context)
//                                             .translate("cancel"),
//                                         style: TextStyle(
//                                           color: const Color(0xFF29E33C),
//                                           fontSize: dialogWidth * 0.06,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: dialogWidth * 0.04),
//                                   SizedBox(
//                                     width: dialogWidth * 0.35,
//                                     height: dialogHeight * 0.25,
//                                     child: DecoratedBox(
//                                       decoration: BoxDecoration(
//                                         gradient: const LinearGradient(
//                                           colors: [
//                                             Colors.red,
//                                             Color.fromARGB(255, 128, 9, 9)
//                                           ],
//                                           begin: Alignment.topLeft,
//                                           end: Alignment.bottomRight,
//                                         ),
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                       child: ElevatedButton(
//                                         onPressed: () async {
//                                           // Close dialog first
//                                           Navigator.pop(context);
//
//                                           // Get the current user's ID
//                                           final sessionManager =
//                                               SessionManager();
//                                           final userId =
//                                               await sessionManager.getUserId();
//
//                                           if (userId != null) {
//                                             try {
//                                               // Show loading indicator
//                                               showDialog(
//                                                 context: context,
//                                                 barrierDismissible: false,
//                                                 builder:
//                                                     (BuildContext context) {
//                                                   return Dialog(
//                                                     backgroundColor:
//                                                         Colors.transparent,
//                                                     elevation: 0,
//                                                     child: Container(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               16),
//                                                       decoration: BoxDecoration(
//                                                         color: Theme.of(context)
//                                                             .cardColor
//                                                             .withOpacity(0.9),
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(20),
//                                                       ),
//                                                       child: Column(
//                                                         mainAxisSize:
//                                                             MainAxisSize.min,
//                                                         children: [
//                                                           const CircularProgressIndicator(
//                                                             valueColor:
//                                                                 AlwaysStoppedAnimation<
//                                                                         Color>(
//                                                                     Color(
//                                                                         0xFF29E33C)),
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 16),
//                                                           Text(
//                                                             AppLocalizations.of(
//                                                                     context)
//                                                                 .translate(
//                                                                     "Deleting account..."),
//                                                             style: TextStyle(
//                                                               color: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .bodyMedium
//                                                                   ?.color,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                               );
//
//                                               // Call the method to delete user
//                                               final authController =
//                                                   AuthController();
//                                               await authController
//                                                   .deleteUserWithProfiles(
//                                                       userId);
//
//                                               // Close loading dialog
//                                               Navigator.pop(context);
//
//                                               // Show success message
//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(
//                                                 SnackBar(
//                                                   content: Text(AppLocalizations
//                                                           .of(context)
//                                                       .translate(
//                                                           "Account successfully deleted")),
//                                                   backgroundColor: Colors.green,
//                                                 ),
//                                               );
//
//                                               // Clear session
//                                               await sessionManager
//                                                   .clearSession();
//
//                                               // Navigate to login screen
//                                               Navigator.of(context)
//                                                   .pushAndRemoveUntil(
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         LoginView()),
//                                                 (route) => false,
//                                               );
//                                             } catch (e) {
//                                               // Close loading dialog if open
//                                               Navigator.of(context,
//                                                       rootNavigator: true)
//                                                   .pop();
//
//                                               // Show error message
//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(
//                                                 SnackBar(
//                                                   content: Text(
//                                                       "${AppLocalizations.of(context).translate("Error deleting account")}: $e"),
//                                                   backgroundColor: Colors.red,
//                                                 ),
//                                               );
//                                             }
//                                           } else {
//                                             // Show error message if user ID is not available
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               SnackBar(
//                                                 content: Text(AppLocalizations
//                                                         .of(context)
//                                                     .translate(
//                                                         "User session not found")),
//                                                 backgroundColor: Colors.red,
//                                               ),
//                                             );
//                                           }
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.transparent,
//                                           shadowColor: Colors.transparent,
//                                           padding: EdgeInsets.zero,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                           ),
//                                         ),
//                                         child: Text(
//                                           AppLocalizations.of(context)
//                                               .translate("Delete"),
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: dialogWidth * 0.06,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: Color(0xFF29E33C), // Changed from green to red
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.delete_forever,
//                               color: const Color.fromARGB(255, 255, 255,
//                                   255)), // Changed from white to red
//                           const SizedBox(width: 10),
//                           Text(
//                             AppLocalizations.of(context)
//                                 .translate('Delete Account'),
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color:
//                                   Theme.of(context).textTheme.bodyMedium?.color,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Icon(
//                         Icons.chevron_right,
//                         color: Colors.grey,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'dart:ui'; // Pour le BackdropFilter
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:piminnovictus/Models/User.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Services/Const.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Views/AuthViews/login_view.dart';
import 'package:piminnovictus/Views/AuthViews/privacy_policy.dart';
import 'package:piminnovictus/Views/AuthViews/terms_and_conditions.dart';
import 'package:provider/provider.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:http/http.dart' as http;

import '../../Services/AuthController.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Au début de la classe _EditProfileState, ajoutez :
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool isSaveButtonEnabled = false;
  bool isLoading = false;
  File? _image;

  final SessionManager _sessionManager = SessionManager();
  User? currentUser;
  bool isPreferencesExpanded = false;
  bool isProfileInformationsExpanded = false;
  bool isPersonalInfoExpanded = false;
  bool isPasswordExpanded = false;
  bool isDarkModeExpanded = false;
  bool isLanguageExpanded = false;
  String selectedLanguage = 'en';
  bool isTermsExpanded = false;
  bool isAccountExpanded = false;

  bool isSavePasswordButtonEnabled = false;
  // Ajout de variables pour la validation des champs de mot de passe
  bool isCurrentPasswordCorrect = false;
  bool isNewPasswordValid = false;
  bool isConfirmPasswordMatch = false;

  //String userId = _sessionManager._keyUserId;

  AuthController auth = AuthController();

  String? userId;
  @override
  void initState() {
    _currentPasswordController.addListener(_checkPasswordFields);
    _newPasswordController.addListener(_checkPasswordFields);
    _confirmPasswordController.addListener(_checkPasswordFields);

    super.initState();
    _loadUserData();
    Future<String?> userId = _sessionManager.getUserId();
    print("userrrrrrc  $userId");
  }

  // Update validation method to return validation state
  bool _validatePassword(String password) {
    // Vérifie si le mot de passe a au moins 6 caractères
    if (password.length < 6) {
      return false;
    }
    // Vérifie si le mot de passe contient au moins un caractère spécial
    RegExp specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return specialChar.hasMatch(password);
  }

  bool _isCurrentPasswordCorrect(String password) {
    // Simulation - À remplacer par votre logique de validation réelle
    if (currentUser != null) {
      // Exemple: Dans un cas réel, vous feriez une vérification avec le backend
      return password.isNotEmpty; // Validation simplifiée pour l'exemple
    }
    return false;
  }

  // Duplicate method removed

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await _sessionManager.getCurrentUser();
    userId = await _sessionManager.getUserId();
    if (user != null) {
      setState(() {
        currentUser = user;
        _nameController.text = user.name;
        _emailController.text = user.email ?? '';
        _phoneController.text = user.phoneNumber ?? '';
      });
    }
  }

  Future<void> _pickImage() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } else {
      print("Permission refusée");
    }
  }

  void _checkPasswordFields() {
    setState(() {
      // Vérifier si le mot de passe actuel est correct
      isCurrentPasswordCorrect =
          _isCurrentPasswordCorrect(_currentPasswordController.text);

      // Vérifier si le nouveau mot de passe est valide
      isNewPasswordValid = _validatePassword(_newPasswordController.text);

      // Vérifier si la confirmation correspond au nouveau mot de passe
      isConfirmPasswordMatch =
          _newPasswordController.text == _confirmPasswordController.text;

      // Activer ou désactiver le bouton de sauvegarde en fonction des validations
      isSavePasswordButtonEnabled =
          _currentPasswordController.text.isNotEmpty &&
              _newPasswordController.text.isNotEmpty &&
              _confirmPasswordController.text.isNotEmpty &&
              isCurrentPasswordCorrect &&
              isNewPasswordValid &&
              isConfirmPasswordMatch;
    });
  }

  Future<void> _changePassword() async {
    // Vérifier si les champs sont vides
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate('fillAllFields') ??
                  "Veuillez remplir tous les champs"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Vérifier si le nouveau mot de passe est valide
    if (!isNewPasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
                  .translate('passwordRequirements') ??
              "Le mot de passe doit contenir au moins 6 caractères et un caractère spécial"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Vérifier si la confirmation correspond
    if (!isConfirmPasswordMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Les mots de passe ne correspondent pas"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Utilisateur introuvable"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String userId = currentUser!.id;
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

// Crée une instance de la classe Const
    final constInstance = Const();

// Utilise la constante url de cette instance
    final url = '${constInstance.url}/auth/change-password';

    try {
      // Désactiver le bouton et montrer l'indicateur de chargement
      setState(() {
        isLoading = true;
      });

      // Afficher un dialogue de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF29E33C)),
                ),
                SizedBox(width: 20),
                Text(AppLocalizations.of(context)
                        .translate('updatingPassword') ??
                    "Mise à jour du mot de passe..."),
              ],
            ),
          );
        },
      );

      final response = await http
          .put(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'userId': userId,
              'oldPassword': currentPassword,
              'newPassword': newPassword,
            }),
          )
          .timeout(const Duration(seconds: 30));

// Fermer le dialogue de chargement
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Mot de passe modifié avec succès"),
            backgroundColor: Colors.green,
          ),
        );
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        setState(() {
          isCurrentPasswordCorrect = false;
          isNewPasswordValid = false;
          isConfirmPasswordMatch = false;
          isSavePasswordButtonEnabled = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur : ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Fermer le dialogue de chargement si une erreur se produit
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      String errorMessage = "Erreur de connexion";
      if (error.toString().contains("SocketException") ||
          error.toString().contains("Connection timed out")) {
        errorMessage =
            "Impossible de se connecter au serveur. Vérifiez votre connexion réseau et l'URL du serveur.";
      } else {
        errorMessage = "Erreur de connexion : $error";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur de connexion : $error"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Réactiver le bouton
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate('userNotFound') ??
                  "Utilisateur introuvable"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if any changes were made
    if (_nameController.text == currentUser!.name &&
        _emailController.text == currentUser!.email &&
        _phoneController.text == currentUser!.phoneNumber) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('noChanges') ??
              "Aucune modification détectée"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Retrieve authentication token
    final token = await _sessionManager.getToken();
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate('sessionExpired') ??
                  "Session expirée, veuillez vous reconnecter"),
          backgroundColor: Colors.red,
        ),
      );
      // Rediriger vers la page de connexion
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginView()),
        (route) => false,
      );
      return;
    }
    // Create Const instance for API URL
    final constInstance = Const();
    // Pour le développement local avec émulateur, utilisez 10.0.2.2 au lieu de 192.168.1.13
    final url = '${constInstance.url}/auth/update-user';

    try {
      // Show loading indicator
      setState(() {
        isSaveButtonEnabled = false;
      });

      // Afficher un dialogue de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF29E33C)),
                ),
                SizedBox(width: 20),
                Text("Mise à jour en cours..."),
              ],
            ),
          );
        },
      );

      // Prepare data to update - only include fields that changed
      final updateData = {
        if (_nameController.text != currentUser!.name)
          'name': _nameController.text,
        if (_emailController.text != currentUser!.email)
          'email': _emailController.text,
        if (_phoneController.text != currentUser!.phoneNumber)
          'phoneNumber': _phoneController.text,
      };

      // Debug prints
      print("URL: $url");
      print("Token: $token");
      print("Update data: ${jsonEncode(updateData)}");

      // Send PATCH request with increased timeout
      final response = await http
          .patch(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(updateData),
          )
          .timeout(const Duration(seconds: 30));

      // Fermer le dialogue de chargement
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        // Successful update
        final updatedUserData = jsonDecode(response.body);
        final updatedUser = User(
          id: currentUser!.id,
          name: updatedUserData['name'] ?? currentUser!.name,
          email: updatedUserData['email'] ?? currentUser!.email,
          phoneNumber:
              updatedUserData['phoneNumber'] ?? currentUser!.phoneNumber,
        );

        // Update user session
        await _sessionManager.saveUser(updatedUser);

        // Update UI state
        setState(() {
          currentUser = updatedUser;
          _nameController.text = updatedUser.name;
          _emailController.text = updatedUser.email ?? '';
          _phoneController.text = updatedUser.phoneNumber ?? '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context).translate('profileUpdated') ??
                    "Profil mis à jour avec succès"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Handle errors
        Map<String, dynamic> errorData = {};
        try {
          errorData = jsonDecode(response.body);
        } catch (_) {}

        String errorMessage = errorData['message'] ??
            "Erreur lors de la mise à jour du profil (${response.statusCode})";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Fermer le dialogue de chargement si une erreur se produit
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      String errorMessage = "Erreur de connexion";
      if (error.toString().contains("SocketException") ||
          error.toString().contains("Connection timed out")) {
        errorMessage =
            "Impossible de se connecter au serveur. Vérifiez votre connexion réseau et l'URL du serveur.";
      } else {
        errorMessage = "Erreur de connexion : $error";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Re-enable save button
      setState(() {
        isSaveButtonEnabled = true;
      });
    }
  }

  // Fonction pour afficher le pop-up de confirmation
  void _showConfirmationDialog(
      BuildContext context, Future<void> Function() changePassword) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Changes'),
          content: Text('Are you sure you want to save this password?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Appelle la fonction pour enregistrer et fermer la carte
                _changePassword();
                setState(() {
                  // Ferme la carte et rafraîchit la page
                  isPasswordExpanded = false;
                  // Réinitialise les champs (si nécessaire)
                  _currentPasswordController.clear();
                  _newPasswordController.clear();
                  _confirmPasswordController.clear();
                });
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isLoading = false;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Fond adapté au mode clair ou sombre
              Positioned.fill(
                child:
                    isDarkMode ? _darkModeBackground() : _lightModeBackground(),
              ),
              // Contenu principal avec flou d'arrière-plan
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child: SafeArea(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 70),

                          // Image du profil et informations
                          GestureDetector(
                            onTap: _pickImage,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : const AssetImage('assets/user.jpg')
                                          as ImageProvider,
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).iconTheme.color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF29E33C),
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(Icons.check,
                                        color: Colors.white, size: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          currentUser == null
                              ? const CircularProgressIndicator()
                              : Text(
                                  currentUser!.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ),
                                ),

                          currentUser == null
                              ? const CircularProgressIndicator()
                              : Text(
                                  currentUser!.email ?? '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ),
                                ),

                          const SizedBox(height: 5),

                          const SizedBox(height: 30),

                          _buildPreferencesCard(context),
                          const SizedBox(height: 10),
                          // Carte Preferences intégrée
                          _buildProfileInformationsCard(context),
                          const SizedBox(height: 10),

                          _buildTermssCard(context),

                          _buildAccountCard(context),

                          // Item Logout

                          const SizedBox(height: 10),
                          // Item Logout
                          _buildMenuItem(
                            context,
                            icon: Icons.logout,
                            title: AppLocalizations.of(context)
                                .translate('logout'),
                            onTap: () async {
                              // Show confirmation dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  final dialogWidth =
                                      MediaQuery.of(context).size.width * 0.8;
                                  final dialogHeight =
                                      MediaQuery.of(context).size.height * 0.2;

                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    child: Container(
                                      width: dialogWidth,
                                      height: dialogHeight,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.90),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate("logout"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontSize: dialogWidth * 0.06,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          SizedBox(height: dialogHeight * 0.1),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate("logoutmsg"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontSize: dialogWidth * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: dialogHeight * 0.1),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: dialogWidth * 0.35,
                                                height: dialogHeight * 0.25,
                                                child: OutlinedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: const BorderSide(
                                                      color: Color(0xFF29E33C),
                                                      width: 2,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate("cancel"),
                                                    style: TextStyle(
                                                      color: const Color(
                                                          0xFF29E33C),
                                                      fontSize:
                                                          dialogWidth * 0.06,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: dialogWidth * 0.04),
                                              SizedBox(
                                                width: dialogWidth * 0.35,
                                                height: dialogHeight * 0.25,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      colors: [
                                                        Color(0xFF29E33C),
                                                        Color.fromARGB(
                                                            255, 9, 128, 25)
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.pop(
                                                          context); // Close dialog
                                                      final sessionManager =
                                                          SessionManager();

                                                      // Clear the session
                                                      await sessionManager
                                                          .clearSession();

                                                      // Navigate to welcome page and clear all previous routes
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LoginView()),
                                                        (route) =>
                                                            false, // This removes all previous routes
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      shadowColor:
                                                          Colors.transparent,
                                                      padding: EdgeInsets.zero,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate("logout"),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            dialogWidth * 0.06,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Fond pour le mode clair
  Widget _lightModeBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF93DAB2).withOpacity(0.8),
            Colors.white.withOpacity(0.5),
          ],
        ),
      ),
    );
  }

  // Fond pour le mode sombre
  Widget _darkModeBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            const Color(0xFF0A140C),
            const Color(0xFF0D0F0D).withOpacity(0.6),
          ],
        ),
      ),
    );
  }

  // Widget générique pour un menu item standard
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? switchWidget,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFF29E33C),
            width: 0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
            switchWidget ?? const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInformationsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isProfileInformationsExpanded = !isProfileInformationsExpanded;

          // Réinitialiser l'expansion des sous-cartes lors de la fermeture
          if (!isProfileInformationsExpanded) {
            isPersonalInfoExpanded = false;
            isPasswordExpanded = false;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFF29E33C),
            width: 0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de la carte Preferences
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person,
                        color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)
                          .translate('profileInformation'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                Icon(
                  isProfileInformationsExpanded
                      ? Icons.expand_more
                      : Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
            if (isProfileInformationsExpanded) ...[
              const SizedBox(height: 16),
              // Sous-carte : Personal Informations
              GestureDetector(
                onTap: () {
                  setState(() {
                    isPersonalInfoExpanded = !isPersonalInfoExpanded;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF29E33C),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête de la sous-carte Personal Informations
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate('personalInformation'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          Icon(
                            isPersonalInfoExpanded
                                ? Icons.expand_more
                                : Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      if (isPersonalInfoExpanded) ...[
                        const SizedBox(height: 15),
                        TextField(
                          controller: _nameController,
                          onChanged: (value) {
                            setState(() {
                              isSaveButtonEnabled = value.isNotEmpty &&
                                  (value != currentUser?.name ||
                                      _emailController.text !=
                                          currentUser?.email ||
                                      _phoneController.text !=
                                          currentUser?.phoneNumber);
                            });
                          },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate('username'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _emailController,
                          onChanged: (value) {
                            setState(() {
                              isSaveButtonEnabled = value.isNotEmpty &&
                                  (value != currentUser?.email ||
                                      _nameController.text !=
                                          currentUser?.name ||
                                      _phoneController.text !=
                                          currentUser?.phoneNumber);
                            });
                          },
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context).translate('email'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _phoneController,
                          onChanged: (value) {
                            setState(() {
                              isSaveButtonEnabled = _nameController.text !=
                                      currentUser?.name ||
                                  _emailController.text != currentUser?.email ||
                                  value != currentUser?.phoneNumber;
                            });
                          },
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context).translate('phone'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: isSaveButtonEnabled
                                  ? () async {
                                      // Afficher l'indicateur de progression en changeant l'état local
                                      setState(() {
                                        isLoading =
                                            true; // Ajoutez cette variable dans votre state
                                      });
                                      // Vérifier si des modifications ont été apportées
                                      bool isUpdated = _nameController.text !=
                                              currentUser?.name ||
                                          _emailController.text !=
                                              currentUser?.email ||
                                          _phoneController.text !=
                                              currentUser?.phoneNumber;

                                      if (isUpdated) {
                                        // Effectuer la mise à jour si des modifications ont eu lieu
                                        await auth.updateUser(
                                          userId!,
                                          _nameController.text,
                                          _emailController.text,
                                          _phoneController.text,
                                        );

                                        // Cacher l'indicateur de progression
                                        setState(() {
                                          isLoading = false;
                                        });
                                        // Afficher le popup "User updated successfully"
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Success'),
                                              content: Text(
                                                  'User updated successfully'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Ferme le popup
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        // En cas d'erreur, cacher l'indicateur et afficher un message d'erreur
                                        setState(() {
                                          isLoading = false;
                                        });
                                        // Afficher le popup "No update" si aucune donnée n'a été modifiée
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('No Update'),
                                              content: Text(
                                                  'No changes were made to the user information'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Ferme le popup
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSaveButtonEnabled
                                    ? const Color(0xFF29E33C)
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
                              ),
                              child: Text(
                                AppLocalizations.of(context).translate('save'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Sous-carte : Password
              GestureDetector(
                onTap: () {
                  setState(() {
                    isPasswordExpanded = !isPasswordExpanded;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF29E33C),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête de la sous-carte Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('password'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          Icon(
                            isPasswordExpanded
                                ? Icons.expand_more
                                : Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      if (isPasswordExpanded) ...[
                        const SizedBox(height: 15),
                        TextField(
                          controller: _currentPasswordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('currentPassword'),
                            filled: true,
                            fillColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color:
                                    _currentPasswordController.text.isNotEmpty
                                        ? (isCurrentPasswordCorrect
                                            ? Colors.green
                                            : Colors.red)
                                        : Theme.of(context).primaryColor,
                                width: 0.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color:
                                    _currentPasswordController.text.isNotEmpty
                                        ? (isCurrentPasswordCorrect
                                            ? Colors.green
                                            : Colors.red)
                                        : Theme.of(context).primaryColor,
                                width: 0.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(left: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isCurrentPasswordCorrect =
                                  _isCurrentPasswordCorrect(value);
                            });
                            _checkPasswordFields();
                          },
                        ),

                        const SizedBox(height: 15),
                        TextField(
                          controller: _newPasswordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('newPassword'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _newPasswordController.text.isNotEmpty
                                    ? (isNewPasswordValid
                                        ? Colors.green
                                        : Colors.red)
                                    : Colors.white,
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _newPasswordController.text.isNotEmpty
                                    ? (isNewPasswordValid
                                        ? Colors.green
                                        : Colors.red)
                                    : Theme.of(context).primaryColor,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _newPasswordController.text.isNotEmpty
                                    ? (isNewPasswordValid
                                        ? Colors.green
                                        : Colors.red)
                                    : Colors.white,
                                width: 0.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(left: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isNewPasswordValid = _validatePassword(value);
                              // Vérifier si le mot de passe de confirmation correspond
                              if (_confirmPasswordController.text.isNotEmpty) {
                                isConfirmPasswordMatch =
                                    value == _confirmPasswordController.text;
                              }
                            });
                            _checkPasswordFields();
                          },
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('confirmPassword'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color:
                                    _confirmPasswordController.text.isNotEmpty
                                        ? (isConfirmPasswordMatch
                                            ? Colors.green
                                            : Colors.red)
                                        : Colors.white,
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color:
                                    _confirmPasswordController.text.isNotEmpty
                                        ? (isConfirmPasswordMatch
                                            ? Colors.green
                                            : Colors.red)
                                        : Colors.white,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color:
                                    _confirmPasswordController.text.isNotEmpty
                                        ? (isConfirmPasswordMatch
                                            ? Colors.green
                                            : Colors.red)
                                        : Colors.white,
                                width: 0.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(left: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isConfirmPasswordMatch =
                                  value == _newPasswordController.text;
                            });
                            _checkPasswordFields();
                          },
                        ),
                        const SizedBox(height: 20),
                        // Bouton "Save" aligné à droite
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isLoading
                                ? SizedBox(
                                    height: 48,
                                    width: 120,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: const Color(0xFF29E33C),
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: isSavePasswordButtonEnabled
                                        ? () => _showConfirmationDialog(
                                            context, _changePassword)
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isSavePasswordButtonEnabled
                                              ? const Color(0xFF29E33C)
                                              : Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('save'),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesCard(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        setState(() {
          isPreferencesExpanded = !isPreferencesExpanded;
          if (!isPreferencesExpanded) {
            isDarkModeExpanded = false;
            isLanguageExpanded = false;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFF29E33C),
            width: 0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preferences card header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.settings,
                        color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context).translate('preferences'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                Icon(
                  isPreferencesExpanded
                      ? Icons.expand_more
                      : Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
            if (isPreferencesExpanded) ...[
              const SizedBox(height: 16),
              // Dark Mode card
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2.5),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF29E33C),
                    width: 1,
                  ),
                ),
                child: Column(
                  // Changed from Row to Column to match language card structure
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.dark_mode,
                                color: Theme.of(context).iconTheme.color),
                            const SizedBox(width: 10),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('darkMode'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              ),
                            ),
                          ],
                        ),
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return Switch(
                              value: themeProvider.isDarkMode,
                              onChanged: (value) {
                                themeProvider.toggleTheme(value);
                              },
                              activeColor: Theme.of(context).iconTheme.color,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
// Language Selection card
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLanguageExpanded = !isLanguageExpanded;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF29E33C),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.language,
                                  color: Theme.of(context).iconTheme.color),
                              const SizedBox(width: 10),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('language'),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            isLanguageExpanded
                                ? Icons.expand_more
                                : Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      if (isLanguageExpanded) ...[
                        const SizedBox(height: 15),
                        // English Option
                        ListTile(
                          title: Text(
                            AppLocalizations.of(context).translate('english'),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          onTap: () {
                            languageProvider.setLocale(
                                const Locale('en')); // Set to English
                          },
                          trailing: languageProvider.locale.languageCode == 'en'
                              ? Icon(Icons.check,
                                  color: Theme.of(context).iconTheme.color)
                              : null,
                        ),
                        // French Option
                        ListTile(
                          title: Text(
                            AppLocalizations.of(context).translate('french'),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          onTap: () {
                            languageProvider
                                .setLocale(const Locale('fr')); // Set to French
                          },
                          trailing: languageProvider.locale.languageCode == 'fr'
                              ? Icon(Icons.check,
                                  color: Theme.of(context).iconTheme.color)
                              : null,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Save button
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTermssCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTermsExpanded = !isTermsExpanded;
          // Reset sub-cards expansion when closing
          if (!isTermsExpanded) {
            isDarkModeExpanded = false;
            isLanguageExpanded = false;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFF29E33C),
            width: 0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preferences card header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield_outlined,
                        color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context).translate('termsAndPrivacy'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                Icon(
                  isTermsExpanded ? Icons.expand_more : Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
            if (isTermsExpanded) ...[
              const SizedBox(height: 16),
              // Terms & Conditions card
              // Terms & Conditions card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsAndConditionsScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF29E33C),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description_outlined,
                              color: Theme.of(context).iconTheme.color),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)
                                .translate('termsAndConditions'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),

              // Privacy Policy card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF29E33C),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.privacy_tip_outlined,
                              color: Theme.of(context).iconTheme.color),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)
                                .translate('privacyPolicy'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isAccountExpanded = !isAccountExpanded;
          // Reset sub-cards expansion when closing
          if (!isAccountExpanded) {
            isDarkModeExpanded = false;
            isLanguageExpanded = false;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFF29E33C),
            width: 0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Management card header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance,
                        color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)
                          .translate('Account Management'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                Icon(
                  isAccountExpanded ? Icons.expand_more : Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
            if (isAccountExpanded) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Navigate to profile creation screen
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const CreateProfileScreen(),
                  //   ),
                  // );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF29E33C),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_add,
                              color: Theme.of(context).iconTheme.color),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)
                                .translate('Create Profile'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Delete Account card
              GestureDetector(
                onTap: () {
                  // Show delete account confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final dialogWidth =
                          MediaQuery.of(context).size.width * 0.8;
                      final dialogHeight =
                          MediaQuery.of(context).size.height * 0.2;

                      return Dialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        child: Container(
                          width: dialogWidth,
                          height: dialogHeight,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).cardColor.withOpacity(0.90),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate("Delete Account"),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontSize: dialogWidth * 0.06,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(height: dialogHeight * 0.1),
                              Text(
                                AppLocalizations.of(context).translate(
                                    "Are you sure you want to delete your account?"),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontSize: dialogWidth * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: dialogHeight * 0.1),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: dialogWidth * 0.35,
                                    height: dialogHeight * 0.25,
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Color(0xFF29E33C),
                                          width: 2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate("cancel"),
                                        style: TextStyle(
                                          color: const Color(0xFF29E33C),
                                          fontSize: dialogWidth * 0.06,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: dialogWidth * 0.04),
                                  SizedBox(
                                    width: dialogWidth * 0.35,
                                    height: dialogHeight * 0.25,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.red,
                                            Color.fromARGB(255, 128, 9, 9)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          // Close dialog first
                                          Navigator.pop(context);

                                          // Get the current user's ID
                                          final sessionManager =
                                              SessionManager();
                                          final userId =
                                              await sessionManager.getUserId();

                                          if (userId != null) {
                                            try {
                                              // Show loading indicator
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .cardColor
                                                            .withOpacity(0.9),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Color(
                                                                        0xFF29E33C)),
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(
                                                                    "Deleting account..."),
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.color,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );

                                              // Call the method to delete user
                                              final authController =
                                                  AuthController();
                                              await authController
                                                  .deleteUserWithProfiles(
                                                      userId);

                                              // Close loading dialog
                                              Navigator.pop(context);

                                              // Show success message
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(AppLocalizations
                                                          .of(context)
                                                      .translate(
                                                          "Account successfully deleted")),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );

                                              // Clear session
                                              await sessionManager
                                                  .clearSession();

                                              // Navigate to login screen
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginView()),
                                                (route) => false,
                                              );
                                            } catch (e) {
                                              // Close loading dialog if open
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();

                                              // Show error message
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "${AppLocalizations.of(context).translate("Error deleting account")}: $e"),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          } else {
                                            // Show error message if user ID is not available
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(AppLocalizations
                                                        .of(context)
                                                    .translate(
                                                        "User session not found")),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("Delete"),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: dialogWidth * 0.06,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFF29E33C), // Changed from green to red
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.delete_forever,
                              color: const Color.fromARGB(255, 255, 255,
                                  255)), // Changed from white to red
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)
                                .translate('Delete Account'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
