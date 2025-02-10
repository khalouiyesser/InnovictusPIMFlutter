import 'package:flutter/material.dart';
import 'package:piminnovictus/views/Visitor/pack_details.dart';
import 'package:piminnovictus/views/background.dart';

class PacksList extends StatefulWidget {
  @override
  _PacksListState createState() => _PacksListState();
}

class _PacksListState extends State<PacksList> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> packs = [
    {
      "title": "Basic Pack",
      "image": "assets/panel.png",
      "description": "Unlock energy potential...Maximize savings...Easy installation...Smart monitoring...",
    },
    {
      "title": "Advanced Pack",
      "image": "assets/background.jpg",
      "description": "Track energy live...\nReal-time analytics...\nEnhanced performance...\nBattery storage included...",
    },
    {
      "title": "Premium Pack",
      "image": "assets/background.jpg",
      "description": "Smart automation...\nHigher efficiency...\nAI-based tracking...\n24/7 customer support...",
    },
  ];

  List<Map<String, String>> filteredPacks = [];

  @override
  void initState() {
    super.initState();
    filteredPacks = packs; // Initialiser la liste avec tous les packs
    searchController.addListener(_filterPacks);
  }

  void _filterPacks() {
    setState(() {
      String query = searchController.text.toLowerCase();
      filteredPacks = packs.where((pack) {
        return pack["title"]!.toLowerCase().contains(query) ||
               pack["description"]!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('All our Packs and Offers'),
          backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: BlurredRadialBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Search Bar**
              Center(
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search Packs & Offers ...",
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // **List of Packs**
              Expanded(
                child: filteredPacks.isEmpty
                    ? Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
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
                                  Text(
                                    pack["title"]!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                 IconButton(
  icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
  onPressed: () {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PackDetails(pack: pack),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  },
  splashColor: Colors.transparent,
),
                                ],
                              ),
                              SizedBox(height: 10),

                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  pack["image"]!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),

                              Text(
                                pack["description"]!,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              SizedBox(height: 20),
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
