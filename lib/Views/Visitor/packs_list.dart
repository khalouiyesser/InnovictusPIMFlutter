import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/packs.dart';
// import 'package:piminnovictus/views/Visitor/pack_details.dart';
import 'package:piminnovictus/views/background.dart';

import 'pack_details.dart';

class PacksList extends StatefulWidget {
  @override
  _PacksListState createState() => _PacksListState();
}

class _PacksListState extends State<PacksList> {
  TextEditingController searchController = TextEditingController();

  // Define packs as a List<Pack>
  List<Pack> packs = [
    Pack(
        id: "1",
        title: "Basic Pack",
        image: "assets/panel.png",
        description:
        "• Unlock energy potential\n• Maximize savings\n• Smart monitoring",
        price: 999,
        panelsCount: "6",
        energyGain: "5 kWh/jour",
        co2Saved: "10 kg CO₂/jour",
        certification: "Empreinte carbone réduite"),
    Pack(
        id: '1',
        title: "Advanced Pack",
        image: "assets/background.jpg",
        description:
        "• Track energy live\n• Real-time analytics\n• Battery storage included",
        price: 1499,
        panelsCount: "8",
        energyGain: "7 kWh/jour",
        co2Saved: "15 kg CO₂/jour",
        certification: "Empreinte carbone réduite"),
    Pack(
        id: '2',        title: "Premium Pack",
        image: "assets/background.jpg",
        description:
        "• Smart automation\n• Higher efficiency\n• 24/7 customer support",
        price: 1999,
        panelsCount: "10",
        energyGain: "10 kWh/jour",
        co2Saved: "20 kg CO₂/jour",
        certification: "Empreinte carbone réduite"),
  ];

  List<Pack> filteredPacks = [];

  @override
  void initState() {
    super.initState();
    filteredPacks = packs;
    searchController.addListener(_filterPacks);
  }

  void _filterPacks() {
    setState(() {
      String query = searchController.text.toLowerCase();
      filteredPacks = packs.where((pack) {
        return pack.title.toLowerCase().contains(query) ||
            pack.description.toLowerCase().contains(query);
      }).toList();
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
          'All our Packs and Offers',
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
                      hintText: "Search Packs & Offers ...",
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
                child: filteredPacks.isEmpty
                    ? Center(
                  child: Text(
                    "No results found",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: packDescriptionSize,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredPacks.length,
                  itemBuilder: (context, index) {
                    final pack = filteredPacks[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                pack.title, // Remove the ! since it's not nullable
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
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                        PackDetails(pack: pack),
                                    transitionDuration: Duration.zero,
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
                            borderRadius:
                            BorderRadius.circular(borderRadius),
                            child: Image.asset(
                              pack.image, // Use pack.image instead of pack["image"]!
                              height: imageHeight,
                              width: imageHeight * 1.2,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: spacingHeight * 0.5),
                        Padding(
                          padding:
                          EdgeInsets.only(left: descriptionPadding),
                          child: Text(
                            pack.description, // Use pack.description instead of pack["description"]!
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
            ],
          ),
        ),
      ),
    );
  }
}