import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/ClientModels/packs.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/viewmodels/packs_view_model.dart';
// import 'package:piminnovictus/views/Visitor/pack_details.dart';
import 'package:piminnovictus/views/background.dart';
import 'package:provider/provider.dart';

import 'pack_details.dart';

class PacksList extends StatefulWidget {
  @override
  _PacksListState createState() => _PacksListState();
}

class _PacksListState extends State<PacksList> {
  TextEditingController searchController = TextEditingController();

  late PacksViewModel _packsViewModel;
  List<Pack> filteredPacks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _packsViewModel = Provider.of<PacksViewModel>(context, listen: false);
    _loadPacks();
    searchController.addListener(_filterPacks);
  }

  Future<void> _loadPacks() async {
    setState(() {
      _isLoading = true;
    });

    await _packsViewModel.getAllPacks();

    setState(() {
      filteredPacks = _packsViewModel.packs;
      _isLoading = false;
    });
  }

  void _filterPacks() {
    if (_packsViewModel.packs.isEmpty) return;

    setState(() {
      String query = searchController.text.toLowerCase();
      if (query.isEmpty) {
        filteredPacks = _packsViewModel.packs;
      } else {
        filteredPacks = _packsViewModel.packs.where((pack) {
          return pack.title.toLowerCase().contains(query) ||
              pack.description.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final titleFontSize = screenWidth * 0.05;
    final searchBarWidth = screenWidth * 0.7;
    final searchBarHeight = screenHeight * 0.08;
    final contentPadding = screenWidth * 0.04;
    final packTitleSize = screenWidth * 0.04;
    final packDescriptionSize = screenWidth * 0.035;
    final imageHeight = screenHeight * 0.32;
    final spacingHeight = screenHeight * 0.02;
    final iconSize = screenWidth * 0.05;
    final borderRadius = screenWidth * 0.07;
    final descriptionPadding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate("titleall"),
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: iconSize,
        ),
      ),
      body: BlurredRadialBackground(
        isDarkMode: true,
        backgroundGradientColors: [],
        child: Padding(
          padding: EdgeInsets.all(contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: searchBarWidth,
                  height: searchBarHeight,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!
                          .translate("search_hint"),
                      hintStyle: TextStyle(
                        color: Colors.white70,
                        fontSize: packDescriptionSize,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: iconSize,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: screenWidth * 0.002,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: screenWidth * 0.002,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: screenWidth * 0.004,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.03,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: packDescriptionSize,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacingHeight),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : _packsViewModel.errorMessage.isNotEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.white70,
                                  size: iconSize * 2,
                                ),
                                SizedBox(height: spacingHeight),
                                Text(
                                  _packsViewModel.errorMessage,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: packDescriptionSize,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: spacingHeight),
                                ElevatedButton(
                                  onPressed: _loadPacks,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate("retry"),
                                    style: TextStyle(
                                        fontSize: packDescriptionSize),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.2),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(borderRadius),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : filteredPacks.isEmpty
                            ? Center(
                                child: Text(
                                  "No results found",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: packDescriptionSize,
                                  ),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _loadPacks,
                                color: Colors.white,
                                backgroundColor: Colors.transparent,
                                child: ListView.builder(
                                  itemCount: filteredPacks.length,
                                  itemBuilder: (context, index) {
                                    final pack = filteredPacks[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                pack.title,
                                                style: TextStyle(
                                                  fontSize: packTitleSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                                size: iconSize,
                                              ),
                                              onPressed: () {
                                                // Set selected pack in view model
                                                _packsViewModel
                                                    .setSelectedPack(pack);
                                                Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                        PackDetails(pack: pack),
                                                    transitionDuration:
                                                        Duration.zero,
                                                    reverseTransitionDuration:
                                                        Duration.zero,
                                                  ),
                                                );
                                              },
                                              splashColor: Colors.transparent,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: spacingHeight * 0.5),
                                        Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                borderRadius),
                                            child: Image.asset(
                                              pack.image,
                                              height: imageHeight,
                                              width: imageHeight * 1.2,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: spacingHeight * 0.5),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: descriptionPadding),
                                          child: Text(
                                            pack.description,
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: packDescriptionSize,
                                              height: 1.8,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: spacingHeight),
                                      ],
                                    );
                                  },
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
