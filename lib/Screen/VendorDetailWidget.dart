import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Model/CustomerInsightsModel.dart';
import 'package:nepvent_reward/Screen/DashboardWidget.dart';
import 'package:nepvent_reward/Screen/LoginDashboardWidget.dart';
import 'package:nepvent_reward/Screen/LoginWidget.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

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
    required this.vendorId,
  });

  final bool isLogin;
  final int discount;
  final String vendorName;
  final String imageUrl;
  final String address;
  final String description;
  final String phone;
  final String vendorId;

  @override
  State<VendorDetailWidget> createState() => _VendorDetailWidgetState();
}

class _VendorDetailWidgetState extends State<VendorDetailWidget> {
  String? profileAvatar;

  // CustomerInsights? customerInsights;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfileAvatar();
    _getCustomerInsights();
  }

  // void _onItemTapped(int index) {
  //   _navigateToLoginDashboard(index);
  // }
  //
  // void _navigateToLoginDashboard(int tabIndex) {
  //   widget.isLogin
  //       ? Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => LoginDashboardWidget(
  //               tabIndex: tabIndex,
  //               profileUrl: profileAvatar,
  //             ),
  //           ),
  //         )
  //       : Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => DashboardWidget(
  //               tabIndex: tabIndex,
  //             ),
  //           ),
  //         );
  // }
  Future<CustomerInsights?> _getCustomerInsights() async {
    if (!widget.isLogin) {
      debugPrint('🙅‍♂️🙅‍♂️🙅‍♂️ User Not Login');
      return null;
    }

    try {
      final Response response =
          await dio.get('${urls['customerInsights']}${widget.vendorId}');
      final body = response.data['data'];
      debugPrint('CustomerInsights : $body');
      return CustomerInsights(
        totalInvoices: body['totalInvoices'],
        totalAmount: body['totalAmount'].toString(),
        totalPoints: body['totalPoints'].toString(),
        redeemDiscountPoints: body['redeemDiscountPoints'].toString(),
        totalDiscount: body['totalDiscount'].toString(),
      );
    } catch (error) {
      debugPrint("error in Customer Insights :  $error");
      return null;
    }
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
      backgroundColor: Colors.white,
      appBar: widget.isLogin
          ? AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: kIsWeb ? false : true,
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
                                          profileAvatar!.isNotEmpty
                                      ? NetworkImage(profileAvatar!)
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
        child: SizedBox(
          height: screen.height,
          child: Stack(
            children: [
              SingleChildScrollView(
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
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 1600, // Equivalent to max-width: 1600px
                      ),
                      width: MediaQuery.sizeOf(context)
                          .width, // Equivalent to width: 100%
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: kIsWeb ? screen.width / 2.5 : null,
                                  // height: 105,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        child: Row(
                                          mainAxisAlignment: kIsWeb
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16),
                                              child: SizedBox(
                                                width: kIsWeb
                                                    ? null
                                                    : screen.width * 0.67,
                                                child: Text(
                                                  widget.vendorName,
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            kIsWeb
                                                ? buildContainerForWeb(
                                                    widget.discount)
                                                : buildContainerForMobile(
                                                    widget.discount),
                                          ],
                                        ),
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
                                          ),
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
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                widget.isLogin
                                    ? kIsWeb
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Container(
                                              width: 1,
                                              height: 100,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : Material()
                                    : Material(),
                                widget.isLogin
                                    ? kIsWeb
                                        ? FutureBuilder<CustomerInsights?>(
                                            future: _getCustomerInsights(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(child: CircularProgressIndicator());
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else if (snapshot.hasData) {
                                                final insights = snapshot.data!;
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      height: 100,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "Total Spending",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            insights
                                                                .redeemDiscountPoints,
                                                            style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: const Color(
                                                                  0xFFDD143D),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 150,
                                                      height: 100,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "Points Earned",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            insights
                                                                .totalPoints,
                                                            style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: const Color(
                                                                  0xFFDD143D),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 150,
                                                      height: 100,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "Discount Claim",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            insights
                                                                .totalDiscount,
                                                            style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: const Color(
                                                                  0xFFDD143D),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    TextButton.icon(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                LoginDashboardWidget(
                                                              profileUrl: '',
                                                              tabIndex: 3,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      iconAlignment:
                                                          IconAlignment.end,
                                                      label: Text(
                                                        "Detail",
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      icon: Icon(
                                                        Icons.arrow_forward,
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }
                                              return Material(); // Fallback if no data
                                            },
                                          )
                                        : Material()
                                    : Material(),
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
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              widget.isLogin
                  ? kIsWeb
                      ? Material()
                      : Positioned(
                          left: 8,
                          right: 8,
                          bottom: 16,
                          child: FutureBuilder<CustomerInsights?>(
                              future: _getCustomerInsights(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  final insights = snapshot.data!;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 25.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDD143D),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),

                                      // Optional background color
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            // color: Colors.lightBlue,
                                            width: 100,
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Total Spending",
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  insights.totalAmount,
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            // color: Colors.lightBlue,
                                            width: 100,
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Points Earned",
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  insights.totalPoints,
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            // color: Colors.lightBlue,
                                            width: 110,
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Discount Claim",
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  insights.redeemDiscountPoints,
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginDashboardWidget(
                                                    profileUrl: '',
                                                    tabIndex: 3,
                                                  ),
                                                ),
                                              );
                                            },
                                            iconAlignment: IconAlignment.end,
                                            label: Text(
                                              "Detail",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return Material();
                              }),
                        )
                  : Material(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: !widget.isLogin
      //     ? isMobile || isTablet
      //         ? BottomNavigationBar(
      //             items: const <BottomNavigationBarItem>[
      //               BottomNavigationBarItem(
      //                 icon: Icon(Icons.home),
      //                 label: 'Home',
      //               ),
      //               BottomNavigationBarItem(
      //                 icon: Icon(Icons.business_outlined),
      //                 label: 'Vendors',
      //               ),
      //             ],
      //             selectedItemColor: Colors.amber[800],
      //             onTap: _onItemTapped,
      //           )
      //         : const Material()
      //     : isMobile || isTablet
      //         ? BottomNavigationBar(
      //             items: const <BottomNavigationBarItem>[
      //               BottomNavigationBarItem(
      //                 icon: Icon(Icons.home),
      //                 label: 'Home',
      //               ),
      //               BottomNavigationBarItem(
      //                 icon: Icon(Icons.business_outlined),
      //                 label: 'Vendors',
      //               ),
      //               BottomNavigationBarItem(
      //                 icon: Icon(Icons.subscriptions_outlined),
      //                 label: 'Subscription',
      //               ),
      //               BottomNavigationBarItem(
      //                 icon: Icon(Icons.receipt_long_outlined),
      //                 label: 'Claims',
      //               ),
      //               BottomNavigationBarItem(
      //                 icon: Icon(Icons.person_3_outlined),
      //                 label: 'Profile',
      //               ),
      //             ],
      //             // currentIndex: _selectedIndex,
      //             selectedItemColor: Color(0xFFDD143D),
      //             unselectedItemColor: Colors.grey[800],
      //             onTap: _onItemTapped,
      //           )
      //         : const Material(),
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
              discount == -1 ? 'FREE' : '$discount%',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (discount !=
                -1) // This will only show "OFF" if discount is not -1
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
            discount == -1 ? 'FREE' : '$discount% OFF',
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
