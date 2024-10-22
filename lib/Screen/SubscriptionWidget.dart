import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Model/ProfileModel.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

class SubscriptionWidget extends StatefulWidget {
  const SubscriptionWidget({super.key});

  @override
  State<SubscriptionWidget> createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends State<SubscriptionWidget> {
  ProfileModel? user;

  Future<ProfileModel?> _fetchProfileData() async {
    String userID = await secureStorage.read(key: 'userID') ?? '';
    String profilePic = '';

    try {
      final Response response = await dio.get('${urls['profile']}/$userID');
      final body = response.data['data'];

      var vendorLoyaltyPoints = body['vendorLoyaltyPoints'] as List;
      int totalPoints = vendorLoyaltyPoints
          .where((pointData) =>
              pointData is Map && pointData.containsKey('points'))
          .map((pointData) => pointData['points'] as int)
          .fold(0, (sum, points) => sum + points);

      if (body['displayPicture']?.containsKey('url') == true) {
        profilePic = body['displayPicture']['url'].toString();
      }
      // Create ProfileModel instance
      ProfileModel profileData = ProfileModel(
        id: body['_id'],
        name: body['name'],
        email: body['email'],
        point: totalPoints,
        phone: body['phone'],
        district: body['userDetail']['district'],
        address: body['userDetail']['address'],
        province: body['userDetail']['province'],
        secondaryNumber: body['userDetail']['secondaryNumber'],
        avatarUrl: profilePic,
        memberId: body['membershipId'],
      );

      return profileData;
    } catch (e) {
      print("Error Fetching Profile data: $e");
      return null; // Return null in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    bool isMobile = screen.width < 700;
    bool isTablet = screen.width >= 700 && screen.width < 900;
    bool isWeb = screen.width >= 900;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<ProfileModel?>(
          future: _fetchProfileData(), // Call the future method
          builder:
              (BuildContext context, AsyncSnapshot<ProfileModel?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is loading
              return Center(
                child:  CircularProgressIndicator(
                  color: const Color(0xFFDD143D),
                ),
              );
            } else if (snapshot.hasError) {
              // If there is an error
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              // If no data is returned
              return Center(child: Text('No Profile Data Available'));
            } else {
              // If the data is successfully fetched
              user = snapshot.data;

              return Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: isWeb ? screen.width / 3 : screen.width,
                    height: isWeb ? screen.height / 1.8 : screen.height -300,
                    decoration: BoxDecoration(
                      // color: Colors.greenAccent,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 15,
                              ),
                              Text(
                                " Membership No.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            user!.memberId.toString(),
                            style: TextStyle(
                              color: Color(0xFFD50032),
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 16),
                            child: Center(
                              child: SizedBox(
                                width: 200,
                                height: 150,
                                child: CircleAvatar(
                                  backgroundImage: user!.avatarUrl != null &&
                                          user!.avatarUrl.isNotEmpty
                                      ? NetworkImage(user!.avatarUrl)
                                      : AssetImage(
                                          'assets/images/man-avatar-profile.jpeg'),
                                  onBackgroundImageError:
                                      (exception, stackTrace) {
                                    print(
                                        'Failed to load network image: $exception');
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                Text(
                                  "Name",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              user!.name,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.call,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                Text(
                                  "Contact",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              user!.phone,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.email_outlined,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              user!.email,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                Text(
                                  "Address",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              '${user!.address}, ${user!.district}, ${user!.province}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
