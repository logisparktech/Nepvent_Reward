import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nepvent_reward/Model/NotificationModel.dart';
import 'package:nepvent_reward/Screen/ClaimsWidget.dart';
import 'package:nepvent_reward/Screen/DashboardWidget.dart';
import 'package:nepvent_reward/Screen/HomeWidget.dart';
import 'package:nepvent_reward/Screen/NotificationWidget.dart';
import 'package:nepvent_reward/Screen/ProfileWidget.dart';
import 'package:nepvent_reward/Screen/SubscriptionWidget.dart';
import 'package:nepvent_reward/Screen/VendorWidget.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

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
  late String currentUserId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.tabIndex ?? 0;
    _getProfileAvatar();
    _getNotificationData();
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

  Future _getNotificationData() async {
    try {
      final Response response = await dio.get(urls['Notification']!);
      final body = response.data['data']['data'];
      // debugPrint(" *********** Notification Body ***********  $body");

      List<NotificationModel> newNotificationData = [];
      body.forEach((item) {
        List<NotificationPicture> pictures =
            (item['notificationPicture'] as List)
                .map((pic) => NotificationPicture(
                      id: pic['_id'],
                      url: pic['url'],
                    ))
                .toList();

        newNotificationData.add(
          NotificationModel(
            id: item['_id'],
            notificationPicture: pictures,
            viewedUser: item['viewedUser'],
            title: item['title'],
            content: item['content'],
            date: DateTime.parse(item['date']),
            time: item['time'],
            redirectedUrl: item.containsKey('redirectedUrl')
                ? item['redirectedUrl']
                : '',
          ),
        );
      });

      setState(() {
        notificationModel = newNotificationData;
      });

      // log('****** notification Data  ******* : $notificationModel');
    } catch (e) {
      print("Error Fetching notification data: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  _getProfileAvatar() async{
    var profilePic = await secureStorage.read(key:'ProfilePic') ??'';
    currentUserId = await secureStorage.read(key: 'userID') ?? '';
    profileAvatar = profilePic;
  }

  void _markAsSeen(String id) async {
    debugPrint('id :$id');
    debugPrint('current user :$currentUserId');
    try {
      final Response response =
          await dio.post('${urls['ViewNotification']}/$id/$currentUserId');
      if (response.statusCode == 201) {
        setState(() {
          notificationModel = notificationModel.map((notification) {
            if (notification.id == id) {
              notification.viewedUser.add(currentUserId);
            }
            return notification;
          }).toList();
        });
      }
    } on DioException catch (err) {
      debugPrint('notification View Dio Error :$err');
    } catch (err) {
      debugPrint('notification View Error :$err');
    }
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
        backgroundColor: Colors.white,
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
            kIsWeb
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PopupMenuButton(
                      tooltip: 'Notification',
                      position: PopupMenuPosition.under,
                      color: Colors.white,
                      onSelected: (String value) {
                        _markAsSeen(value);
                        debugPrint('Notification Value: $value');
                      },
                      itemBuilder: (BuildContext context) {
                        return notificationModel.map((notification) {
                          final bool isSeen =
                              notification.viewedUser.contains(currentUserId);

                          return PopupMenuItem(
                            value: notification.id.toString(),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, bottom: 4.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notification.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            notification.content,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (!isSeen)
                                    SizedBox(
                                      width: 10,
                                      child: Center(
                                        child: Icon(
                                          MdiIcons.circle,
                                          size: 10,
                                          color: Color(0xFFD50032),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList();
                      },
                      child: Icon(
                        MdiIcons.bell,
                        size: 30,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationWidget(),
                        ),
                      );
                    },
                    icon: Icon(
                      MdiIcons.bell,
                      size: 30,
                    ),
                  ),
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
