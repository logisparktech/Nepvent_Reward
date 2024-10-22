import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Screen/DashboardWidget.dart';
import 'package:nepvent_reward/Screen/LoginDashboardWidget.dart';
import 'package:nepvent_reward/Screen/LoginWidget.dart';
import 'package:nepvent_reward/Utils/Global.dart';

class VendorDetailWidget extends StatefulWidget {
  const VendorDetailWidget({
    super.key,
    required this.discount,
    required this.vendorName,
    required this.imageUrl,
    required this.address,
    required this.description,
    required this.phone,
    required this.isLogin,
  });

  final bool isLogin;
  final int discount;
  final String vendorName;
  final String imageUrl;
  final String address;
  final String description;
  final String phone;

  @override
  State<VendorDetailWidget> createState() => _VendorDetailWidgetState();
}

class _VendorDetailWidgetState extends State<VendorDetailWidget> {
  late String profileAvatar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfileAvatar();
  }

  void _onItemTapped(int index) {
    _navigateToLoginDashboard(index);
  }

  void _navigateToLoginDashboard(int tabIndex) {
    widget.isLogin
        ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginDashboardWidget(
                tabIndex: tabIndex,
                profileUrl: profileAvatar,
              ),
            ),
          )
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardWidget(
                tabIndex: tabIndex,
              ),
            ),
          );
  }

  _getProfileAvatar() async {
    var profilePic = await secureStorage.read(key: 'ProfilePic') ?? '';
    // debugPrint('check check ******** $profilePic');

    setState(() {
      profileAvatar = profilePic;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    bool isMobile = screen.width < 700;
    bool isTablet = screen.width >= 700 && screen.width < 900;
    bool isWeb = screen.width >= 900;

    return Scaffold(
      appBar: widget.isLogin
          ? AppBar(
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
                  : Text('Vendor'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Row(
                    children: [
                      isWeb
                          ? PopupMenuButton(
                              onSelected: (String value) {
                                if (value == 'Home') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginDashboardWidget(
                                        tabIndex: 0,
                                        profileUrl: profileAvatar,
                                      ),
                                    ),
                                  );
                                } else if (value == 'Vendor') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginDashboardWidget(
                                        tabIndex: 1,
                                        profileUrl: profileAvatar,
                                      ),
                                    ),
                                  );
                                } else if (value == 'Profile') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginDashboardWidget(
                                        tabIndex: 4,
                                        profileUrl: profileAvatar,
                                      ),
                                    ),
                                  );
                                } else if (value == 'Claims') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginDashboardWidget(
                                        tabIndex: 3,
                                        profileUrl: profileAvatar,
                                      ),
                                    ),
                                  );
                                } else if (value == 'Subscription') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginDashboardWidget(
                                        tabIndex: 2,
                                        profileUrl: profileAvatar,
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
                                    ),
                                  ),
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
                                  PopupMenuItem(
                                    value: 'Subscription',
                                    child: Row(
                                      children: [
                                        Icon(Icons.subscriptions_outlined),
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
                                        Icon(Icons.person),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text('Profile'),
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
                              child: PopupMenuButton(
                                tooltip: "Profile",
                                onSelected: (String value) async {
                                  if (value == 'Profile') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LoginDashboardWidget(
                                                tabIndex: 4,
                                                profileUrl: profileAvatar),
                                      ),
                                    );
                                  } else if (value == 'Logout') {
                                    await secureStorage.deleteAll();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DashboardWidget(
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
                                            Icon(Icons.person_2_sharp),
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
                                          Icon(Icons.logout_sharp),
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
                                  backgroundImage: profileAvatar != null &&
                                          profileAvatar.isNotEmpty
                                      ? NetworkImage(profileAvatar)
                                      : AssetImage(
                                          'assets/images/man-avatar-profile.jpeg'),
                                  // Fallback to a local asset
                                  onBackgroundImageError:
                                      (exception, stackTrace) {
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
            )
          : AppBar(
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
                      'vendor',
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginWidget(),
                              ),
                            );
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
              SizedBox(
                width: screen.width,
                height: 350,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Center(
                    child: Transform.scale(
                      scale: 0.8,
                      child: CircularProgressIndicator(
                        color: const Color(0xFFDD143D),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: kIsWeb
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            widget.vendorName,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        kIsWeb
                            ? buildContainerForWeb(widget.discount)
                            : buildContainerForMobile(widget.discount),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            widget.address,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.call,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            widget.phone,
                            // '9869432555',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        widget.description,
                        // textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: !widget.isLogin
          ? isMobile || isTablet
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
                  selectedItemColor: Colors.amber[800],
                  onTap: _onItemTapped,
                )
              : const Material()
          : isMobile || isTablet
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
                    BottomNavigationBarItem(
                      icon: Icon(Icons.subscriptions_outlined),
                      label: 'Subscription',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.receipt_long_outlined),
                      label: 'Claims',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_3_outlined),
                      label: 'Profile',
                    ),
                  ],
                  // currentIndex: _selectedIndex,
                  selectedItemColor: Color(0xFFDD143D),
                  unselectedItemColor: Colors.grey[800],
                  onTap: _onItemTapped,
                )
              : const Material(),
    );
  }

  Container buildContainerForMobile(int discount) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFDD143D), // Background color
        shape: BoxShape.circle, // Circular shape
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$discount%',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'OFF',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainerForWeb(int discount) {
    return Container(
      width: 120,
      // height: 80,

      decoration: BoxDecoration(
        color: const Color(0xFFDD143D), // Background color
        shape: BoxShape.rectangle, // Circular shape
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Center(
          child: Text(
            '$discount% OFF ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
