import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/ClientModels/packs.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class CreateProfileDialog extends StatefulWidget {
  final List<Pack> packs;

  const CreateProfileDialog({
    Key? key,
    required this.packs,
  }) : super(key: key);

  @override
  State<CreateProfileDialog> createState() => _CreateProfileDialogState();
}

class _CreateProfileDialogState extends State<CreateProfileDialog> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedImagePath;
  int _currentStep = 0;
  Pack? _selectedPack;

  Future<void> _pickImage() async {
    setState(() {
      _selectedImagePath = 'assets/user.jpg';
    });
  }

  Widget _buildProfileInfoStep(
      BuildContext context, double dialogWidth, double dialogHeight) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: dialogHeight * 0.08),
            Text(
              'Créer un nouveau profil',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: dialogWidth * 0.06,
                color: theme.textTheme.titleMedium?.color?.withOpacity(0.7),
              ),
            ),
            SizedBox(height: dialogHeight * 0.1),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: dialogWidth * 0.12,
                backgroundColor:
                    Color.fromARGB(255, 117, 117, 117).withOpacity(0.1),
                backgroundImage: _selectedImagePath != null
                    ? AssetImage(_selectedImagePath!)
                    : null,
                child: _selectedImagePath == null
                    ? Icon(Icons.camera_alt,
                        size: dialogWidth * 0.08,
                        color: Colors.white.withOpacity(0.7))
                    : null,
              ),
            ),
            SizedBox(height: dialogHeight * 0.1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: dialogWidth * 0.08),
              child: TextField(
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nom du profil',
                  labelStyle: theme.textTheme
                      .bodySmall, // ou : theme.textTheme.bodySmall?.copyWith(color: Colors.white)
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.90) ??
                          MyThemes.primaryColor.withOpacity(0.11),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            SizedBox(height: dialogHeight * 0.08),
            Text('Tapez suivant pour sélectionner un pack',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontSize: dialogWidth * 0.044)),
            SizedBox(height: dialogHeight * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: dialogWidth * 0.40,
                  height: dialogHeight * 0.07,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF29E33C),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Annuler',
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
                  width: dialogWidth * 0.40,
                  height: dialogHeight * 0.07,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF29E33C),
                          Color.fromARGB(255, 9, 128, 25)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isNotEmpty) {
                          setState(() => _currentStep = 1);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Suivant',
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
            SizedBox(height: dialogHeight * 0.02),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dialogWidth = constraints.maxWidth * 0.8;
          final dialogHeight = constraints.maxHeight * 0.6;

          return Container(
            width: dialogWidth,
            height: dialogHeight,
            padding: EdgeInsets.symmetric(
              horizontal: dialogWidth * 0.04,
              vertical: dialogHeight * 0.02,
            ),
            decoration: BoxDecoration(
              color: theme.cardColor.withOpacity(0.90),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: _currentStep == 0
                ? _buildProfileInfoStep(context, dialogWidth, dialogHeight)
                : _buildPackSelectionStep(context, dialogWidth, dialogHeight),
          );
        },
      ),
    );
  }

  Widget _buildPackSelectionStep(
      BuildContext context, double dialogWidth, double dialogHeight) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => setState(() => _currentStep = 0),
            ),
            Text(
              'Sélectionner un pack',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: dialogWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: dialogHeight * 0.02),
            itemCount: widget.packs.length,
            itemBuilder: (context, index) {
              final pack = widget.packs[index];
              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: dialogHeight * 0.01,
                  horizontal: dialogWidth * 0.04,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor.withOpacity(0.90),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Color.fromRGBO(41, 227, 60, 1).withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      pack.image,
                      width: dialogWidth * 0.12,
                      height: dialogWidth * 0.12,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    pack.title,
                    style: TextStyle(
                      color:
                          theme.textTheme.titleMedium?.color?.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${pack.panelsCount} panels • ${pack.energyGain}',
                    style: TextStyle(
                      color:
                          theme.textTheme.titleMedium?.color?.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    setState(() => _selectedPack = pack);
                    Navigator.pop(context, {
                      'name': _nameController.text,
                      'imagePath': _selectedImagePath,
                      'selectedPack': pack,
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
