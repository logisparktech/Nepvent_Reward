import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/HelperScreen/VendorCardWidget.dart';
import 'package:nepvent_reward/Model/VendorModel.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

class VendorWidget extends StatefulWidget {
  const VendorWidget({super.key});

  @override
  State<VendorWidget> createState() => _VendorWidgetState();
}

class _VendorWidgetState extends State<VendorWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  late int numberOfCards;
  late int crossAxisCount;
  late double cardWidth;
  late double childAspectRatio;
  late double vendorCardWidth;
  late double cardHeight;
  String? _selectedFilter;
  String? _selectedOrder;
  List<VendorModel> filteredItems = [];
  List<VendorModel> vendorData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getVendorData();
    searchController.addListener(() {
      _searchFilterData();
    });
  }

  _getVendorData() async {
    try {
      Map<String, dynamic>? queryParams;
      if (_selectedFilter != null && _selectedOrder!=null) {
        queryParams = {
          'sortKey': _selectedFilter,
          'sort': _selectedOrder,
        };
      }else{
        queryParams = {
          'sortKey': _selectedFilter,
        };
      }
      debugPrint("Query Parameter : $queryParams");
      final Response response = await dio.get(
        urls['AllVendor']!,
        queryParameters: queryParams,
      );

      final body = response.data['data'];
      List<VendorModel> newVendorData = [];
      body['items'].forEach((item) {
        String imageUrl = (item['assets'] != null && item['assets'].isNotEmpty)
            ? item['assets'][0]['url']
            : 'https://images.pexels.com/photos/1639556/pexels-photo-1639556.jpeg?auto=compress&cs=tinysrgb&w=600'; // Default image URL
        newVendorData.add(
          VendorModel(
            imageUrl: imageUrl,
            discount: item['discount'],
            vendorName: item['name'],
            location: item['address'],
          ),
        );
      });
      setState(() {
        vendorData = newVendorData;
        filteredItems = vendorData;
      });
    } catch (e) {
      print("Error Fetching  vendor data: $e");
    }
  }

  _searchFilterData() {
    if (searchController.text.isNotEmpty) {
      List<VendorModel> filteredList = vendorData
          .where((vendor) => vendor.vendorName
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
      setState(() {
        filteredItems = filteredList;
      });
    } else {
      setState(() {
        filteredItems =
            vendorData; // Reset to original data when search text is empty
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Size screen = MediaQuery.sizeOf(context);
      bool isMobile = screen.width < 700;
      bool isTablet = screen.width >= 700 && screen.width < 900;
      // bool isWeb = screen.width >= 900;
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
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.only(left: 15),
            children: [
              DrawerHeader(
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState!.closeEndDrawer();
                    },
                    icon: Icon(
                      Icons.close_outlined,
                      color: Color(0xFFDD153C),
                      size: 50,
                    ),
                  ),
                ),
              ),
              Text(
                "Filter By",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFDD153C),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                children: [
                  ListTile(
                    title: const Text('Discount'),
                    leading: Radio(
                      value: 'discount',
                      // toggleable: true,
                      groupValue: _selectedFilter,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedFilter = value;
                          _getVendorData();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Name'),
                    leading: Radio(
                      value: 'name',
                      // toggleable: true,
                      groupValue: _selectedFilter,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedFilter = value;
                          _getVendorData();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Created At'),
                    leading: Radio(
                      value: 'createdAt',
                      // toggleable: true,
                      groupValue: _selectedFilter,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedFilter = value;
                          _getVendorData();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Updated At'),
                    leading: Radio(
                      value: 'updatedAt',
                      // toggleable: true,
                      groupValue: _selectedFilter,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedFilter = value;
                          _getVendorData();
                        });
                      },
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Text('Selected: $_selectedFilter'),
                  // ),
                ],
              ),
              Text(
                "Sort Order",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFDD153C),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                children: [
                  ListTile(
                    title: const Text('Ascending'),
                    leading: Radio(
                      value: 'ASC',
                      // toggleable: true,
                      groupValue: _selectedOrder,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOrder = value;
                          _getVendorData();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Descending'),
                    leading: Radio(
                      value: 'DESC',
                      // toggleable: true,
                      groupValue: _selectedOrder,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOrder = value;
                          _getVendorData();
                        });
                      },
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Text('Selected: $_selectedOrder'),
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  alignment: Alignment.center,
                  width: 150, // Set the button width
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      // Open the drawer when the button is pressed
                      debugPrint("Filter Button Clicked ");
                      _selectedFilter = null;
                      _selectedOrder = null;
                      _getVendorData();
                      _scaffoldKey.currentState!.closeEndDrawer();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDD153C),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        // side: BorderSide(
                        //   color: Colors.black,
                        // ),
                      ),
                    ),
                    child: Text(
                      "Clear All",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // FilterDrawerWidget(
        //   scaffoldKey: _scaffoldKey,
        // ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, bottom: 8.0, right: 8.0, left: 8.0),
                child: TextFormField(
                  controller: searchController,
                  autofocus: false,
                  obscureText: false,
                  onChanged: (searchData) {
                    _searchFilterData();
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),

                    hintText: 'Search Vendor',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: const Color(0xFF57636C),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFDD143D),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFFDD143D),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFFDD143D),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    // fillColor: const Color(0xFF22222E),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                  ),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: const Color(0xFF57636C),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  width: 100, // Set the button width
                  child: ElevatedButton(
                    onPressed: () {
                      // Open the drawer when the button is pressed
                      debugPrint("Filter Button Clicked ");
                      if (_scaffoldKey.currentState!.isEndDrawerOpen) {
                        Navigator.of(context)
                            .pop(); // Close the end drawer if open
                      } else {
                        _scaffoldKey.currentState!
                            .openEndDrawer(); // Open the end drawer
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.blue,
                      foregroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_alt_outlined), // Icon on the left
                        SizedBox(width: 8), // Space between icon and text
                        Text("Filter"),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                    height:
                    isMobile ? screen.height * 0.645 : screen.height * 0.76,
                    child: SingleChildScrollView(
                      child: Wrap(
                        // spacing: 8.0, // Space between items horizontally
                        runSpacing: 8.0, // Space between rows
                        children: filteredItems.map((vendor) {
                          return SizedBox(
                            width: vendorCardWidth,
                            // height: cardHeight,
                            child: VendorCardWidget(
                              discount: vendor.discount,
                              vendorName: vendor.vendorName,
                              imageUrl: vendor.imageUrl,
                              address: vendor.location,
                            ),
                          );
                        }).toList(),
                      ),
                    )),
              )
            ],
          ),
        ),
      );
    });
  }
}
