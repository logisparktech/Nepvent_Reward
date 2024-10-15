import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/HelperScreen/VendorCardWidget.dart';
import 'package:nepvent_reward/HelperScreen/VendorLimitedOfferWidget.dart';
import 'package:nepvent_reward/Model/BannerModel.dart';
import 'package:nepvent_reward/Model/VendorModel.dart';
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
  List<BannerModel> bannerData = [];
  List<VendorModel> limitedVendorData = [];
  List<VendorModel> vendorData = [];

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
    await _getBannerData();
    await _getLimitVendorData();
    await _getVendorData();
  }

  void _onDotTap(int index) {
    setState(() {
      _current = index;
    });
    _controller.animateToPage(index);
  }

  _getBannerData() async {
    try {
      final Response response = await dio.get(urls['banner']!);
      final body = response.data['data'];

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

  _getLimitVendorData() async {
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
            discount: item['discount'],
            vendorName: item['name'],
            location: item['address'],
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

  _getVendorData() async {
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
            discount: item['discount'],
            vendorName: item['name'],
            location: item['address'],
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size screen = MediaQuery.sizeOf(context);
        bool isMobile = screen.width < 700;
        bool isTablet = screen.width >= 700 && screen.width < 900;
        // bool isWeb = screen.width >= 900;
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      bottom: 16,
                    ),
                    child: Text(
                      " Enjoy the exciting offers! ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent[400],
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                      ),
                    ),
                  ),

                  // Adjust width based on the number of cards
                  SizedBox(
                    height: isMobile ? 180 : 250,
                    child: GestureDetector(
                      // this code for scrolling in web
                      onHorizontalDragUpdate: (details) {
                        // Scroll the list based on swipe gesture
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(
                            _scrollController.offset - details.delta.dx,
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
                              discount: limitedVendorData[index].discount,
                              vendorName: limitedVendorData[index].vendorName,
                              imageUrl: limitedVendorData[index].imageUrl,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      height:
                          isMobile ? screen.height / 2.7 : screen.height / 1.15,
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
                                    ? screen.height / 3.13
                                    : screen.height * 0.8,
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    // spacing: 8.0, // Space between items horizontally
                                    runSpacing: 8.0, // Space between rows
                                    children: vendorData.map((vendor) {
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSlider({
    required double height,
    required bool enlargeCenterPage,
    required bool autoPlay,
  }) {
    return Column(
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
                          child: CircularProgressIndicator(),
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
            onPageChanged: (index, reason) {
              setState(() {
                _current =
                    index; // Update the current index when the page changes
              });
            },
          ),
          carouselController: _controller,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bannerData.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _onDotTap(entry.key),
              // Tap to change slider position
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == entry.key
                        ? Colors.blueAccent // Active dot color
                        : Colors.grey, // Inactive dot color
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
