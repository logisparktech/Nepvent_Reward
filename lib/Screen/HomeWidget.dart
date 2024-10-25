import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nepvent_reward/Model/BannerModel.dart';
import 'package:nepvent_reward/Model/VendorModel.dart';
import 'package:nepvent_reward/Screen/Design/HelperScreen/VendorCardWidget.dart';
import 'package:nepvent_reward/Screen/Design/HelperScreen/VendorLimitedOfferWidget.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final CarouselSliderController _controller = CarouselSliderController();
  final ScrollController _scrollController = ScrollController();
  int _current = 0;
  late int numberOfCards;
  late int crossAxisCount;
  late double cardWidth;
  late double childAspectRatio;
  late double vendorCardWidth;
  late double cardHeight;
  late bool _isLogin;
  List<BannerModel> bannerData = [];
  List<VendorModel> limitedVendorData = [];
  List<VendorModel> vendorData = [];
  bool _isDownloading = true;

  @override
  void initState() {
    super.initState();
    _callAPI();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _callAPI() async {
    setState(() {
      _isDownloading = true; // Set loading to true before API calls
    });
    await _getBannerData();
    await _getLimitVendorData();
    await _getVendorData();
    await _checkToken();

    setState(() {
      _isDownloading = false; // Set loading to false after data is fetched
    });
  }

  void _onDotTap(int index) {
    setState(() {
      _current = index;
    });
    _controller.animateToPage(index);
  }

  Future _getBannerData() async {
    try {
      final Response response = await dio.get(urls['banner']!);
      final body = response.data['data'];
      // debugPrint("banner Body $body ");

      List<BannerModel> newBannerData = [];
      body['items'].forEach((item) {
        newBannerData.add(
          BannerModel(
            url: item['redirectUrl'],
            imageUrl: item['image']['url'],
          ),
        );
      });
      setState(() {
        bannerData = newBannerData;
      });
    } catch (e) {
      print("Error Fetching banner: $e");
    }
  }

  Future _getLimitVendorData() async {
    try {
      final Response response = await dio.get(urls['limitVendor']!);
      final body = response.data['data'];
      List<VendorModel> newVendorData = [];
      body['items'].forEach((item) {
        String imageUrl = (item['assets'] != null && item['assets'].isNotEmpty)
            ? item['assets'][0]['url']
            : 'https://images.pexels.com/photos/1639556/pexels-photo-1639556.jpeg?auto=compress&cs=tinysrgb&w=600'; // Default image URL
        newVendorData.add(
          VendorModel(
            imageUrl: imageUrl,
            discount: item['discount'] as int,
            vendorName: item['name'],
            location: item['address'],
            description: item['description'],
            phone: item['phone'],
          ),
        );
      });
      setState(() {
        limitedVendorData = newVendorData;
      });
    } catch (e) {
      print("Error Fetching limited vendor data: $e");
    }
  }

  Future _getVendorData() async {
    try {
      final Response response = await dio.get(urls['vendor']!);

      final body = response.data['data'];
      List<VendorModel> newVendorData = [];
      body['items'].forEach((item) {
        String imageUrl = (item['assets'] != null && item['assets'].isNotEmpty)
            ? item['assets'][0]['url']
            : 'https://images.pexels.com/photos/1639556/pexels-photo-1639556.jpeg?auto=compress&cs=tinysrgb&w=600'; // Default image URL
        newVendorData.add(
          VendorModel(
            imageUrl: imageUrl,
            discount: item['discount'] as int,
            vendorName: item['name'],
            location: item['address'],
            description: item['description'],
            phone: item['phone'],
          ),
        );
      });
      setState(() {
        vendorData = newVendorData;
      });
    } catch (e) {
      print("Error Fetching  vendor data: $e");
    }
  }

  _checkToken() async {
    var token = await secureStorage.read(key: 'token') ?? '';
    _isLogin =
        token.isNotEmpty; // Set to true if token is not empty, false otherwise
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
          double maxWidth = screen.width > 1600 ? 1600 : screen.width;
          numberOfCards = 4;
          cardWidth = maxWidth / numberOfCards;
          crossAxisCount = 6;
          vendorCardWidth = screen.width / crossAxisCount;
          cardHeight = screen.height / crossAxisCount;
        }

        if (_isDownloading) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child:  CircularProgressIndicator(
                color: const Color(0xFFDD143D),
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (isMobile)
                    buildSlider(
                      height: 250.0,
                      enlargeCenterPage: false,
                      autoPlay: true,
                    )
                    else if (isTablet)
                      buildSlider(
                        height: 300.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                      )
                    else
                      buildSlider(
                        height: 400.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                      ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 1600, // Equivalent to max-width: 1600px
                      ),
                      width: MediaQuery.sizeOf(context)
                          .width, // Equivalent to width: 100%

                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 16,
                            ),
                            child: Text(
                              " Enjoy the exciting offers! ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFDD143D),
                                fontWeight: FontWeight.w600,
                                fontSize: 26,
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SizedBox(
                                  // width: screen.width,
                                  height: isMobile ? 180 : 250,
                                  child: GestureDetector(
                                    // this code for scrolling in web
                                    onHorizontalDragUpdate: (details) {
                                      // Scroll the list based on swipe gesture
                                      if (_scrollController.hasClients) {
                                        _scrollController.jumpTo(
                                          _scrollController.offset -
                                              details.delta.dx,
                                        );
                                      }
                                    },
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: limitedVendorData.length,
                                      physics: const ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          width: cardWidth,
                                          child: VendorLimitedOfferWidget(
                                            discount: limitedVendorData[index]
                                                .discount,
                                            vendorName: limitedVendorData[index]
                                                .vendorName,
                                            imageUrl: limitedVendorData[index]
                                                .imageUrl,
                                            address: limitedVendorData[index]
                                                .location,
                                            description:
                                                limitedVendorData[index]
                                                    .description,
                                            phone:
                                                limitedVendorData[index].phone,
                                            isLogin: _isLogin,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: (isMobile ? 180 : 250) / 2 - 24,
                                left: 8,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFDD143D),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      if (_scrollController.hasClients) {
                                        _scrollController.jumpTo(
                                          (_scrollController.offset + cardWidth)
                                              .clamp(
                                            0.0,
                                            _scrollController
                                                .position.maxScrollExtent,
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      MdiIcons.chevronLeft,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: (isMobile ? 180 : 250) / 2 - 24,
                                // Adjusting for vertical centering (24 is half the height of the button)
                                right: 8,
                                // Adjusting the left position for the forward button
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFDD143D),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      if (_scrollController.hasClients) {
                                        _scrollController.jumpTo(
                                          (_scrollController.offset - cardWidth)
                                              .clamp(
                                            0.0,
                                            _scrollController
                                                .position.maxScrollExtent,
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      MdiIcons.chevronRight,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: SizedBox(
                              height: isMobile
                                  ? cardHeight * vendorData.length / 3.2
                                  : cardHeight * vendorData.length / 2.3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    // This ensures the text starts from the left
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                      ),
                                      child: Text(
                                        "Featured Vendors",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: SizedBox(
                                      height: isMobile
                                          ? cardHeight *
                                                  vendorData.length /
                                                  3.2 -
                                              42
                                          : cardHeight *
                                              vendorData.length /
                                              2.5,
                                      child: Wrap(
                                        // spacing: 8.0, // Space between items horizontally
                                        runSpacing: 8.0,
                                        // Space between rows
                                        children: vendorData.map((vendor) {
                                          return SizedBox(
                                            width: vendorCardWidth,
                                            // height: cardHeight,
                                            child: VendorCardWidget(
                                              discount: vendor.discount,
                                              vendorName: vendor.vendorName,
                                              imageUrl: vendor.imageUrl,
                                              address: vendor.location,
                                              description: vendor.description,
                                              phone: vendor.phone,
                                              isLogin: _isLogin,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildSlider({
    required double height,
    required bool enlargeCenterPage,
    required bool autoPlay,
  }) {
    return Stack(
      children: [
        CarouselSlider(
          items: bannerData
              .map(
                (item) => GestureDetector(
                  onTap: () async {
                    // Open URL when tapped
                    final Uri uri = Uri.parse(item.url);
                    if (!await launchUrl(
                      uri,
                      mode: LaunchMode.platformDefault,
                      // Open in external browser
                      webViewConfiguration: const WebViewConfiguration(
                        enableJavaScript: true,
                        enableDomStorage: true,
                      ),
                    )) {
                      throw Exception('Could not launch ${item.url}');
                    }
                  },
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
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
                ),
              )
              .toList(),
          options: CarouselOptions(
            height: height,
            autoPlay: autoPlay,
            enlargeCenterPage: enlargeCenterPage,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 1.0,
            scrollDirection: Axis.vertical,
            scrollPhysics: NeverScrollableScrollPhysics(),
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          carouselController: _controller,
        ),
        Positioned(
          top: kIsWeb ?130 : 60,
          right: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bannerData.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _onDotTap(entry.key),
              // Tap to change slider position
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                    width: 16.0,
                    height: 16.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,

                        // _current == entry.key
                        //     ? Colors.blue // Active border color
                        //     : Colors.grey, // Inactive border color
                        width: 2.0, // You can adjust the width of the border
                      ),
                    ),
                ),
              ),
            );
          }).toList(),
          ),
        )
      ],
    );
  }
}
