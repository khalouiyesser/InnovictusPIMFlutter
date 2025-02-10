import 'package:flutter/material.dart';

class SubscriptionCarousel extends StatefulWidget {
  const SubscriptionCarousel({Key? key}) : super(key: key);

  @override
  State<SubscriptionCarousel> createState() => _SubscriptionCarouselState();
}

class _SubscriptionCarouselState extends State<SubscriptionCarousel> {
  late PageController _pageController;
  int _currentPage = 1;

  final List<SubscriptionPlan> plans = [
    SubscriptionPlan(
      title: 'pack  service',
      price: '400 TND',
      features: ['Realtime Monotoring', 'Energy Transfert feature', 'Sell&Buy Energy'],
      color: const Color.fromARGB(255, 44, 75, 47),
    ),
    SubscriptionPlan(
      title: 'pack 16 pannel',
      price: '\6000 TND',
      features: ['All Basic Features', 'Feature 4', 'Feature 5', 'Feature 6'],
      color: const Color.fromARGB(255, 71, 81, 229),
    ),
    SubscriptionPlan(
      title: 'pack pro',
      price: '\7500 TND',
      features: ['All Premium Features', 'Feature 7', 'Feature 8', 'Feature 9'],
      color: Colors.green,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.75,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/Pulse.png",
              fit: BoxFit.cover,
            ),
          ),
          
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 500,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                            value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                          }
                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001),
                            alignment: Alignment.center,
                            child: child,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Colored Header Section
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  color: plans[index].color,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child:Column(children: [ 
                                  Text(
                                  plans[index].title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                  Center(

                                    child: Image.asset(
                                                    "assets/pannelplan.png",
                                                    height: 70,
                                                  )),
                                        
                             

                                ])
                              ),
                              // Card Content
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        plans[index].price,
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Column(
                                        children:
                                        
                                         plans[index].features.map((feature) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Row(
        children: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                ),
                child: const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 16,
                ),
            ),
            Expanded(
                child: Text(
                    feature,
                    style: const TextStyle(fontSize: 16),
                ),
            ),])
                                        )).toList(),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Add subscription logic here
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: plans[index].color,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 40,
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: const Text(
                                          'Subscribe',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    plans.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionPlan {
  final String title;
  final String price;
  final List<String> features;
  final Color color;

  SubscriptionPlan({
    required this.title,
    required this.price,
    required this.features,
    required this.color,
  });
}