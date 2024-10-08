import 'package:flutter/material.dart';
import 'package:nepvent_reward/Screen/HomeWidget.dart';
import 'package:nepvent_reward/Screen/VendorWidget.dart';

class LoginDashboardWidget extends StatefulWidget {
  const LoginDashboardWidget({
    super.key,
    this.tabIndex,
  });

  final int? tabIndex;

  @override
  State<LoginDashboardWidget> createState() => _LoginDashboardWidgetState();
}

class _LoginDashboardWidgetState extends State<LoginDashboardWidget> {
  late int _selectedIndex;
  late int numberOfCards;
  late int crossAxisCount;
  late double cardWidth;
  late double childAspectRatio;
  late double vendorCardWidth;
  late double cardHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.tabIndex ?? 0;
  }

  final List<Widget> _pages = [
    HomeWidget(),
    VendorWidget(),
  ];
  final List<String> _title = [
    'Home',
    'Vendor',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Size screen = MediaQuery.sizeOf(context);
      bool isMobile = screen.width < 700;
      bool isTablet = screen.width >= 700 && screen.width < 900;
      bool isWeb = screen.width >= 900;
      //for Card View Vendor Offer
      if (isMobile) {
        numberOfCards = 2;
        cardWidth = screen.width / numberOfCards;
        crossAxisCount = 2;
        vendorCardWidth = screen.width / crossAxisCount;
        cardHeight = screen.height / crossAxisCount;
      } else if (isTablet) {
        numberOfCards = 3;
        cardWidth = screen.width / numberOfCards;
        crossAxisCount = 4;
        vendorCardWidth = screen.width / crossAxisCount;
        cardHeight = screen.height / crossAxisCount;
      } else {
        numberOfCards = 4;
        cardWidth = screen.width / numberOfCards;
        crossAxisCount = 6;
        vendorCardWidth = screen.width / crossAxisCount;
        cardHeight = screen.height / crossAxisCount;
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          automaticallyImplyLeading: false,
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
              : Text(
                  _title[_selectedIndex],
                ),
          actions: [
            isWeb
                ? PopupMenuButton(
                    onSelected: (String value) {
                      if (value == 'Home') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginDashboardWidget(
                              tabIndex: 0,
                            ),
                          ),
                        );
                      } else if (value == 'Vendor') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginDashboardWidget(
                              tabIndex: 1,
                            ),
                          ),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                            value: 'Home',
                            child: Row(
                              children: [
                                Icon(Icons.home),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Home'),
                              ],
                            )),
                        PopupMenuItem(
                          value: 'Vendor',
                          child: Row(
                            children: [
                              Icon(Icons.business_outlined),
                              SizedBox(
                                width: 4,
                              ),
                              Text('Vendor'),
                            ],
                          ),
                        ),
                      ];
                    },
                    child: Icon(Icons.menu_sharp),
                  )
                : const Material(),
            isWeb
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: () {
                        // Your login logic here

                        // debugPrint("Login Clicked")
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
                : Material(),
          ],
        ),
        body: _pages[_selectedIndex],
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
    });
  }
}
