import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepvent_reward/Model/ProfileModel.dart';
import 'package:nepvent_reward/Screen/DashboardWidget.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool isEditable = false;
  ProfileModel? user;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  Uint8List webImage = Uint8List(8);

  // Controllers for the form fields
  final TextEditingController addressController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController secondaryNumberController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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

      // Set the address controller text
      addressController.text = profileData.address;
      districtController.text = profileData.district;
      provinceController.text = profileData.province;
      secondaryNumberController.text = profileData.secondaryNumber;

      return profileData;
    } catch (e) {
      print("Error Fetching Profile data: $e");
      return null; // Return null in case of error
    }
  }

  _updateUser() async {
    String userID = await secureStorage.read(key: 'userID') ?? '';
    try {
      final Response response = await dio.patch(
        '${urls['profile']}/$userID',
        data: {
          "userDetail": {
            "address": addressController.text.trim(),
            "province": provinceController.text.trim(),
            "district": districtController.text.trim(),
            "secondaryNumber": secondaryNumberController.text.trim(),
          },
        },
      );
      debugPrint(response.statusMessage);
      debugPrint(response.data);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFD50032),
            content: Text(response.statusMessage.toString()),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFD50032),
            content: Text('Please check your internet connection.'),
          ),
        );
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFFD50032),
          content: Text(e.response?.data['message']['reason'].toString() ??
              'Please check your internet connection.'),
        ),
      );
    } catch (error) {
      debugPrint("Error ON update : $error");
    }
  }

  _updateProfilePicture(XFile? image) async {
    FormData formData;
    String fileName = image!.path.split('/').last;
    try {
      if (!kIsWeb) {
        formData = FormData.fromMap({
          "files": await MultipartFile.fromFile(image.path, filename: fileName),
        });
      } else {
        Uint8List imageBytes = await image.readAsBytes();
        formData = FormData.fromMap({
          'files': MultipartFile.fromBytes(
            imageBytes,
            filename: image.name,
            contentType: DioMediaType('IMAGE', 'jpeg'), // Adjust as needed
          ),
        });
      }
      final Response response = await dio.post(
        urls['profilePicture']!,
        data: formData,
      );
      if (response.statusCode == 201) {
        debugPrint("profile data : ${response.data}");
        if (response.data != null &&
            response.data['data'] !=
                null && // Access the 'data' key in the response
            response.data['data'] is List &&
            response.data['data'].isNotEmpty) {
          final imageUrl = response.data['data'][0]['url'];

          debugPrint("text $imageUrl");
          await secureStorage.write(
            key: 'ProfilePic',
            value: imageUrl.toString(),
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFD50032),
            content: Text(response.statusMessage.toString()),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFD50032),
            content: Text('Please check your internet connection.'),
          ),
        );
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFFD50032),
          content: Text(e.response?.data['message']['reason'].toString() ??
              'Please check your internet connection.'),
        ),
      );
    } catch (error) {
      debugPrint("Error ON update image : $error");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    addressController.dispose();
    districtController.dispose();
    provinceController.dispose();
    secondaryNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<ProfileModel?>(
          future: _fetchProfileData(), // Call the future method
          builder:
              (BuildContext context, AsyncSnapshot<ProfileModel?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is loading
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If there is an error
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              // If no data is returned
              return Center(child: Text('No Profile Data Available'));
            } else {
              // If the data is successfully fetched
              user = snapshot.data;
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 200,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.red,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                  backgroundImage: _imageFile != null
                                      ? (kIsWeb
                                          ? MemoryImage(webImage)
                                              as ImageProvider
                                          : FileImage(_imageFile!)
                                              as ImageProvider)
                                      : user != null &&
                                              user!.avatarUrl != null &&
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
                            Positioned(
                              right: 15,
                              bottom: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFDD143D),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt_outlined,
                                  ),
                                  color: Colors.white, // Icon color
                                  onPressed: () async {
                                    if (kIsWeb) {
                                      XFile? image = await _picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (image != null) {
                                        _updateProfilePicture(image);
                                        var webImg = await image.readAsBytes();

                                        setState(() {
                                          webImage = webImg;
                                          _imageFile = File('a');
                                        });
                                      } else {
                                        debugPrint("No image Selected");
                                      }
                                    } else {
                                      XFile? image = await _picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (image != null) {
                                        _updateProfilePicture(image);
                                        var selected = File(image.path);
                                        setState(() {
                                          _imageFile = selected;
                                        });
                                      } else {
                                        debugPrint("No image Selected");
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.greenAccent,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 12, bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user!.point.toString(),
                                  // "350",
                                  style: TextStyle(
                                    color: const Color(0xFFDD143D),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: const Color(0xFFDD143D),
                                      size: 15,
                                    ),
                                    Text(
                                      " Accumulated Points ",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 12, bottom: 16, right: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 20,
                                      color: const Color(0xFFDD143D),
                                    ),
                                    Text(
                                      " Personal Information ",
                                      style: TextStyle(
                                        color: const Color(0xFFDD143D),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                  ),
                                  child: Text(
                                    "Name",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                                Text(
                                  user!.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                  ),
                                  child: Text(
                                    "Email",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                                Text(
                                  user!.email,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                  ),
                                  child: Text(
                                    "Phone Number",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                                Text(
                                  user!.phone,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                  ),
                                  child: Text(
                                    "Address",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                                isEditable
                                    ? TextFormField(
                                        controller: addressController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      )
                                    : Text(
                                        addressController.text,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                  ),
                                  child: Text(
                                    "District",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                                isEditable
                                    ? TextFormField(
                                        controller: districtController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      )
                                    : Text(
                                        districtController.text,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                  ),
                                  child: Text(
                                    "Province",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                                isEditable
                                    ? TextFormField(
                                        controller: provinceController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      )
                                    : Text(
                                        provinceController.text,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                  ),
                                  child: Text(
                                    "Secondary Number",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                                isEditable
                                    ? TextFormField(
                                        controller: secondaryNumberController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      )
                                    : Text(
                                        secondaryNumberController.text.isEmpty
                                            ? 'N/A'
                                            : secondaryNumberController.text,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                isEditable
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  isEditable = !isEditable;
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                    0xFFDD143D), // Button color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20), // Rounded edges
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 50,
                                                    vertical:
                                                        15), // Padding to enlarge the button
                                              ),
                                              child: Text(
                                                'Close',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  // Text color
                                                  fontSize: 16,
                                                  // Font size
                                                  fontWeight: FontWeight
                                                      .bold, // Bold text
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await _updateUser();
                                                setState(() {
                                                  isEditable = !isEditable;
                                                });
                                                debugPrint("Save Clicked");
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                    0xFFDD143D), // Button color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20), // Rounded edges
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 50,
                                                    vertical:
                                                        15), // Padding to enlarge the button
                                              ),
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  // Text color
                                                  fontSize: 16,
                                                  // Font size
                                                  fontWeight: FontWeight
                                                      .bold, // Bold text
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isEditable = !isEditable;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFDD143D),
                                            // Button color
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // Rounded edges
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 50,
                                                vertical:
                                                    15), // Padding to enlarge the button
                                          ),
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontSize: 16, // Font size
                                              fontWeight:
                                                  FontWeight.bold, // Bold text
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      !kIsWeb
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16.0 ,bottom: 16.0),
                              child: ElevatedButton(
                                onPressed: () async{
                                  await secureStorage.deleteAll();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DashboardWidget(
                                        tabIndex: 0,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDD143D),
                                  // Button color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), // Rounded edges
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50,
                                      vertical:
                                          15), // Padding to enlarge the button
                                ),
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.white, // Text color
                                    fontSize: 16, // Font size
                                    fontWeight: FontWeight.bold, // Bold text
                                  ),
                                ),
                              ),
                            )
                          : Material(),
                    ],
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
