import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nepvent_reward/Model/VendorModel.dart';
import 'package:nepvent_reward/Screen/Design/HelperScreen/VendorCardWidget.dart';
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
  String? _selectedOrder= 'DESC';
  late bool _isLogin;
  List<VendorModel> filteredItems = [];
  List<VendorModel> vendorData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getVendorData();
    _checkToken();
    searchController.addListener(() {
      setState(() {});
    });
  }

  Future<List<VendorModel>> _getVendorData() async {
    try {
      Map<String, dynamic>? queryParams;
      if (_selectedFilter != null && _selectedOrder != null) {
        queryParams = {
          'sortKey': _selectedFilter,
          'sort': _selectedOrder,
        };
      } else {
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
            : ''; // Default image URL

        debugPrint("Vendor Id 🪪🪪🪪: ${item['_id']}");
        newVendorData.add(
          VendorModel(
            imageUrl: imageUrl,
            discount: item['discount'],
            vendorName: item['name'],
            location: item['address'],
            description: item['description'],
            phone: item['phone'],
            vId: item['_id'],
          ),
        );
      });
      return newVendorData;
    } catch (e) {
      print("Error Fetching vendor data: $e");
      throw e; // Rethrow the error to handle it in FutureBuilder
    }
  }
  _checkToken() async {
    var token = await secureStorage.read(key: 'token') ?? '';
    _isLogin = token.isNotEmpty; // Set to true if token is not empty, false otherwise
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            padding: EdgeInsets.only(left: 15),
            shrinkWrap: true,
            children: [
              Center(
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    MdiIcons.chevronDown,
                    color: Color(0xFFDD153C),
                    size: 40,
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
              StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: const Text('Discount'),
                        leading: Radio(
                          value: 'discount',
                          groupValue: _selectedFilter,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedFilter = value;
                            });
                            // Navigator.pop(context);
                            _getVendorData();
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Name'),
                        leading: Radio(
                          value: 'name',
                          groupValue: _selectedFilter,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedFilter = value;
                            });
                            // Navigator.pop(context);
                            _getVendorData();
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Created At'),
                        leading: Radio(
                          value: 'createdAt',
                          groupValue: _selectedFilter,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedFilter = value;
                            });
                            // Navigator.pop(context);
                            _getVendorData();
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Updated At'),
                        leading: Radio(
                          value: 'updatedAt',
                          groupValue: _selectedFilter,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedFilter = value;
                            });
                            // Navigator.pop(context);
                            _getVendorData();
                          },
                        ),
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
                              groupValue: _selectedOrder,
                              onChanged: _selectedFilter == null
                                  ? null // Disable if no filter selected
                                  : (String? value) {
                                setState(() {
                                  _selectedOrder = value!;
                                });
                                // Navigator.pop(context);
                                _getVendorData();
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Descending'),
                            leading: Radio(
                              value: 'DESC',
                              groupValue: _selectedOrder,
                              onChanged: _selectedFilter == null
                                  ? null // Disable if no filter selected
                                  : (String? value) {
                                setState(() {
                                  _selectedOrder = value!;
                                });
                                // Navigator.pop(context);
                                _getVendorData();
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              debugPrint("Clear All Button Clicked ");
                              setState(() {
                                _selectedFilter = null;
                                _selectedOrder = 'DESC';
                              });
                              _getVendorData();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFDD153C),
                              foregroundColor: Colors.white,
                              padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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
                  );
                },
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      debugPrint('$_selectedOrder');
      setState(() {});
    });
  }


  // _searchFilterData() {
  //   if (searchController.text.isNotEmpty) {
  //     List<VendorModel> filteredList = vendorData
  //         .where((vendor) => vendor.vendorName
  //             .toLowerCase()
  //             .contains(searchController.text.toLowerCase()))
  //         .toList();
  //     setState(() {
  //       filteredItems = filteredList;
  //     });
  //   } else {
  //     setState(() {
  //       filteredItems =
  //           vendorData; // Reset to original data when search text is empty
  //     });
  //   }
  // }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: LayoutBuilder(builder: (context, constraints) {
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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.only(left: 15),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Filter By",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFDD153C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState!.closeDrawer();
                        },
                        icon: Icon(
                          MdiIcons.closeCircleOutline,
                          color: Color(0xFFDD153C),
                          size: 40,
                        ),
                      ),
                    ],
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
                            _selectedOrder = value!;
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
                            _selectedOrder = value!;
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
                        _selectedOrder = 'DESC';
                        _getVendorData();
                        _scaffoldKey.currentState!.closeDrawer();
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
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 1600, // Equivalent to max-width: 1600px
                ),
                width: MediaQuery.sizeOf(context)
                    .width, // Equivalent to width: 100%
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, bottom: 8.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                        focusNode: FocusNode(),
                        controller: searchController,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                          hintText: 'Search Vendor',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFD2D7DE),
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
                          fillColor: Colors.white,
                          // Set background color to white
                          prefixIcon: Icon(
                            MdiIcons.magnify,
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: 100, // Set the button width
                            child: ElevatedButton(
                              onPressed: () {
                                debugPrint("Filter Button Clicked ");
                                kIsWeb
                                    ? (_scaffoldKey.currentState!.isDrawerOpen
                                            ? Navigator.of(context)
                                                .pop() // Close the drawer
                                            : _scaffoldKey.currentState!
                                                .openDrawer() // Open the drawer
                                        )
                                    : _openFilterModal();
                              },
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.blue,
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(MdiIcons.tuneVariant),
                                  // Icon on the left
                                  SizedBox(width: 8),
                                  // Space between icon and text
                                  Text("Filter"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _selectedFilter == null
                            ? Material()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black38,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _selectedFilter = null;
                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red, // Set icon color
                                          // size: 24, // Set icon size
                                        ),
                                      ),
                                      Text(
                                        _selectedFilter!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black, // Set text color
                                        ),
                                      ),
                                      _selectedOrder != null
                                          ? _selectedOrder == 'ASC'
                                              ? Icon(Icons.arrow_upward)
                                              : Icon(Icons.arrow_downward)
                                          : Material(),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                    Expanded(
                      child: FutureBuilder<List<VendorModel>>(
                        future: _getVendorData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: const Color(0xFFDD143D),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No vendors found.'));
                          } else {
                            List<VendorModel> filteredItems = snapshot.data!
                                .where((vendor) => vendor.vendorName
                                    .toLowerCase()
                                    .contains(
                                        searchController.text.toLowerCase()))
                                .toList();
                            return Padding(
                              padding: kIsWeb
                                  ? const EdgeInsets.only(bottom: 16)
                                  : const EdgeInsets.only(bottom: 1),
                              child: SingleChildScrollView(
                                child: SizedBox(
                                  width: screen.width,
                                  height: !kIsWeb?( filteredItems.length/2)*295: null,
                                  child: kIsWeb
                                      ? Wrap(
                                          runSpacing: 8.0,
                                          children: filteredItems.map((vendor) {
                                            return SizedBox(
                                              width: vendorCardWidth,
                                              child: VendorCardWidget(
                                                discount: vendor.discount,
                                                vendorName: vendor.vendorName,
                                                imageUrl: vendor.imageUrl,
                                                address: vendor.location,
                                                description: vendor.description,
                                                phone: vendor.phone,
                                                isLogin: _isLogin,
                                                vendorId: vendor.vId,
                                              ),
                                            );
                                          }).toList(),
                                        )
                                      : Wrap(
                                          runSpacing: 8.0,
                                          children: filteredItems.map((vendor) {
                                            debugPrint(
                                                "Vendor Id 🆔🆔: ${vendor.vId}");
                                            return SizedBox(
                                              width: vendorCardWidth,
                                              child: VendorCardWidget(
                                                discount: vendor.discount,
                                                vendorName: vendor.vendorName,
                                                imageUrl: vendor.imageUrl,
                                                address: vendor.location,
                                                description: vendor.description,
                                                phone: vendor.phone,
                                                isLogin: _isLogin,
                                                vendorId: vendor.vId,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
