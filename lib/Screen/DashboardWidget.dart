import 'package:flutter/material.dart';
import 'package:nepvent_reward/Screen/HomeWidget.dart';
import 'package:nepvent_reward/Screen/Web/LoginForWebWidget.dart';
import 'package:nepvent_reward/Screen/LoginWidget.dart';
import 'package:nepvent_reward/Screen/VendorWidget.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({
    super.key,
    this.tabIndex,
  });

  final int? tabIndex;

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
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
        appBar: 


        AppBar(
          backgroundColor: Colors.white,
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
                            builder: (context) => const DashboardWidget(
                              tabIndex: 0,
                            ),
                          ),
                        );
                      } else if (value == 'Vendor') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardWidget(
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const LoginForWebWidget(),
                        //   ),
                        // );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LoginForWebWidget();
                          },
                        );
                        // debugPrint("Login Clicked")
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[200],
                        foregroundColor: Color(0xFFD50032),
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
                      child: const Text("Get Started",style: TextStyle(fontFamily: 'poppiens'),),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Your login logic here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginWidget(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color(0xFFD50032),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 5, // Shadow effect
                      ),
                      child: const Text("LOGIN"),
                    ),
                  ),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: isMobile || isTablet
            ? BottomNavigationBar(
          backgroundColor: Colors.white,
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
                selectedItemColor:  Color(0xFFD50032),
                onTap: _onItemTapped,
              )
            : const Material(),
      );
    });
  }
}
