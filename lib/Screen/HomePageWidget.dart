import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/HelperScreen/VendorLimitedOfferWidget.dart';
import 'package:nepvent_reward/Model/HomePageBanner.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final CarouselSliderController _controller = CarouselSliderController();
  final ScrollController _scrollController = ScrollController();
  late int _selectedIndex = 0;
  int _current = 0;
  late int numberOfCards;
  late double cardWidth;

  @override
  void initState() {
    super.initState();
  }

  void _onDotTap(int index) {
    setState(() {
      _current = index; // Manually set the current index when tapping on a dot
    });
    _controller.animateToPage(index);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<HomePageBanner> imgList = [
    HomePageBanner(
      imageUrl:
          'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      url: 'https://menu.nepvent.com',
    ),
    HomePageBanner(
      imageUrl:
          'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=600',
      url: 'https://menu.nepvent.com/',
    ),
    HomePageBanner(
      imageUrl:
          'https://images.pexels.com/photos/769289/pexels-photo-769289.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      url: 'https://menu.nepvent.com',
    ),
  ];

  final List<Map<String, String>> vendors = [
    {
      'discount': '20%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/1639556/pexels-photo-1639556.jpeg?auto=compress&cs=tinysrgb&w=600'
    },
    {
      'discount': '10%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/1211887/pexels-photo-1211887.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'discount': '10%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/803963/pexels-photo-803963.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'discount': '15%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/262959/pexels-photo-262959.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'discount': '15%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/1211887/pexels-photo-1211887.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'discount': '15%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/1211887/pexels-photo-1211887.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'discount': '15%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/1211887/pexels-photo-1211887.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'discount': '15%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/2983101/pexels-photo-2983101.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'discount': '15%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/1211887/pexels-photo-1211887.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'discount': '15%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/1211887/pexels-photo-1211887.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'discount': '15%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/1211887/pexels-photo-1211887.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'discount': '15%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/1211887/pexels-photo-1211887.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'discount': '15%',
      'vendorName': 'Name of Vendor',
      'image':
          'https://images.pexels.com/photos/1211887/pexels-photo-1211887.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size screen = MediaQuery.sizeOf(context);
        bool isMobile = screen.width < 700;
        bool isTablet = screen.width >= 700 && screen.width < 900;
        bool isWeb = screen.width >= 900;
        //for Card View Vendor Offer
        if (isMobile) {
          numberOfCards = 2;
          cardWidth = screen.width / numberOfCards;
        } else if (isTablet) {
          numberOfCards = 3;
          cardWidth = screen.width / numberOfCards;
        } else {
          numberOfCards = 4;
          cardWidth = screen.width / numberOfCards;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            title: isWeb
                ? Row(
                    children: [
                      Image.asset(
                        'assets/images/nepvent-red-logo.png',
                        // Path to your logo image
                        height: 40, // Set the height of the logo
                      ),
                    ],
                  )
                : const Text("Home"),
            actions: [
              isWeb
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu_rounded),
                      ),
                    )
                  : const Material(),
              isWeb
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          // Your login logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[200],
                          foregroundColor: Colors.redAccent[400],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(
                            color: Color(0xFFD50032),
                          ),
                        ),
                        child: const Text("Get Started"),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Your login logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5, // Shadow effect
                        ),
                        child: const Text("LOGIN"),
                      ),
                    ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (isMobile)
                    buildSlider(
                      height: 250.0,
                      enlargeCenterPage: false,
                      autoPlay: true,
                    )
                  else if (isTablet)
                    buildSlider(
                      height: 300.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                    )
                  else
                    buildSlider(
                      height: 325.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      bottom: 16,
                    ),
                    child: Text(
                      " Enjoy the exciting offers! ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent[400],
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                      ),
                    ),
                  ),

                  // Adjust width based on the number of cards
                  SizedBox(
                    height: isMobile ? 180 : 300,
                    child: GestureDetector(
                      // this code for scrolling in web
                      onHorizontalDragUpdate: (details) {
                        // Scroll the list based on swipe gesture
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(
                            _scrollController.offset - details.delta.dx,
                          );
                        }
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: vendors.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: cardWidth,
                            child: VendorLimitedOfferWidget(
                              discount: vendors[index]['discount']!,
                              vendorName: vendors[index]['vendorName']!,
                              imageUrl: vendors[index]['image']!,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 150,
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: isMobile || isTablet
              ? BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.business_outlined),
                      label: 'Vendors',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.amber[800],
                  onTap: _onItemTapped,
                )
              : const Material(),
        );
      },
    );
  }

  Widget buildSlider({
    required double height,
    required bool enlargeCenterPage,
    required bool autoPlay,
  }) {
    return Column(
      children: [
        CarouselSlider(
          items: imgList
              .map((item) => GestureDetector(
                    onTap: () async {
                      // Open URL when tapped
                      final Uri uri = Uri.parse(item.url);
                      if (!await launchUrl(
                        uri,
                        mode: LaunchMode.platformDefault, // Open in external browser
                        webViewConfiguration: const WebViewConfiguration(
                          enableJavaScript: true,
                          enableDomStorage: true,
                        ),
                      )) {
                        throw Exception('Could not launch ${item.url}');
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            width: 1000,
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            height: height,
            autoPlay: autoPlay,
            enlargeCenterPage: enlargeCenterPage,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current =
                    index; // Update the current index when the page changes
              });
            },
          ),
          carouselController: _controller,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _onDotTap(entry.key),
              // Tap to change slider position
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == entry.key
                        ? Colors.blueAccent // Active dot color
                        : Colors.grey, // Inactive dot color
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
