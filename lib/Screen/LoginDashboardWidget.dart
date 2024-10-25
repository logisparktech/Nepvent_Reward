import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nepvent_reward/Screen/ClaimsWidget.dart';
import 'package:nepvent_reward/Screen/DashboardWidget.dart';
import 'package:nepvent_reward/Screen/HomeWidget.dart';
import 'package:nepvent_reward/Screen/ProfileWidget.dart';
import 'package:nepvent_reward/Screen/SubscriptionWidget.dart';
import 'package:nepvent_reward/Screen/VendorWidget.dart';
import 'package:nepvent_reward/Utils/Global.dart';

class LoginDashboardWidget extends StatefulWidget {
   LoginDashboardWidget({
    super.key,
    this.tabIndex,
    this.profileUrl,
  });

  final int? tabIndex;
  String? profileUrl;

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
  late String profileAvatar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.tabIndex ?? 0;
    _getProfileAvatar();
  }

  final List<Widget> _pages = [
    HomeWidget(),
    VendorWidget(),
    SubscriptionWidget(),
    ClaimsWidget(),
    ProfileWidget(),
  ];
  final List<String> _title = [
    'Home',
    'Vendor',
    'Subscription',
    'Claims',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  _getProfileAvatar() async{
    var profilePic = await secureStorage.read(key:'ProfilePic') ??'';
    // debugPrint('check check ******** $profilePic');
    profileAvatar = profilePic;
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
      profileAvatar = widget.profileUrl!;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: isWeb
              ? Row(
                  children: [
                    Image.asset(
                      'assets/images/nepvent-red-logo.png',
                      // Path to your logo image
                      height: 60, // Set the height of the logo
                    ),
                  ],
                )
              : Text(
                  _title[_selectedIndex],
                ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Row(
                children: [
                  isWeb
                      ? PopupMenuButton(
                    position: PopupMenuPosition.under,
                    color: Colors.white,
                    onSelected: (String value) {
                      if (value == 'Home') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                                  builder: (context) => LoginDashboardWidget(
                                    tabIndex: 0,
                                    profileUrl: widget.profileUrl!,
                                  ),
                                ),
                              );
                            } else if (value == 'Vendor') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginDashboardWidget(
                                    tabIndex: 1,
                                    profileUrl: widget.profileUrl!,
                                  ),
                                ),
                              );
                            } else if (value == 'Profile') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginDashboardWidget(
                                    tabIndex: 4,
                                    profileUrl: widget.profileUrl!,
                                  ),
                                ),
                              );
                            } else if (value == 'Claims') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginDashboardWidget(
                                    tabIndex: 3,
                                    profileUrl: widget.profileUrl!,
                                  ),
                                ),
                              );
                            } else if (value == 'Subscription') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginDashboardWidget(
                                    tabIndex: 2,
                                    profileUrl: widget.profileUrl!,
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
                                    Icon(MdiIcons.homeOutline),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Home'),
                              ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Vendor',
                                child: Row(
                                  children: [
                                    Icon(MdiIcons.selectGroup),
                                    SizedBox(
                                      width: 4,
                              ),
                              Text('Vendor'),
                            ],
                          ),
                        ),
                              PopupMenuItem(
                                value: 'Subscription',
                                child: Row(
                                  children: [
                                    Icon(MdiIcons.accountReactivateOutline),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text('Subscription'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Claims',
                                child: Row(
                                  children: [
                                    Icon(Icons.receipt_long_outlined),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text('Claims'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Profile',
                                child: Row(
                                  children: [
                                    Icon(MdiIcons.accountOutline),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text('Profile'),
                                  ],
                                ),
                              ),
                            ];
                          },
                          child: Icon(MdiIcons.dotsGrid,size: 30,),
                        )
                      : const Material(),
                  isWeb
                      ? Padding(
                      padding: const EdgeInsets.all(8.0),
                          child: PopupMenuButton(
                            position: PopupMenuPosition.under,
                            color: Colors.white,
                            tooltip: "Profile",
                            onSelected: (String value) async {
                              if (value == 'Profile') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginDashboardWidget(
                                        tabIndex: 4,
                                        profileUrl: widget.profileUrl!),
                                  ),
                                );
                              } else if (value == 'Logout') {
                                await secureStorage.deleteAll();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DashboardWidget(
                                      tabIndex: 0,
                                    ),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                    value: 'Profile',
                                    child: Row(
                                      children: [
                                        Icon(MdiIcons.accountOutline),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text('Profile'),
                                      ],
                                    )),
                                PopupMenuItem(
                                  value: 'Logout',
                                  child: Row(
                                    children: [
                                      Icon(MdiIcons.logout),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text('Logout'),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            child: CircleAvatar(
                              backgroundImage:profileAvatar != null &&
                                  profileAvatar.isNotEmpty
                                  ? NetworkImage(profileAvatar)
                                  : AssetImage(
                                      'assets/images/man-avatar-profile.jpeg'),
                              // Fallback to a local asset
                              onBackgroundImageError: (exception, stackTrace) {
                                print(
                                    'Failed to load network image: $exception');
                              },
                            ),
                          ),
                        )
                      : Material(),
                ],
              ),
            ),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: isMobile || isTablet
            ? BottomNavigationBar(
                items:[
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(MdiIcons.homeOutline),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(MdiIcons.selectGroup),
                    label: 'Vendors',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(MdiIcons.accountReactivateOutline),
                    label: 'Subscription',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(Icons.receipt_long_outlined),
                    label: 'Claims',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(MdiIcons.accountOutline),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Color(0xFFDD143D),
                unselectedItemColor: Colors.grey[800],
                backgroundColor: Colors.white,
                onTap: _onItemTapped,
              )
            : const Material(),
      );
    });
  }
}
