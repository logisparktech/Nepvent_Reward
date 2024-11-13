import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Screen/LoginDashboardWidget.dart';
import 'package:nepvent_reward/Utils/Global.dart';

class PointWidget extends StatefulWidget {
  const PointWidget({super.key});

  @override
  State<PointWidget> createState() => _PointWidgetState();
}

class _PointWidgetState extends State<PointWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Vendor Detail : ${vendorDetailModel.length}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Point/Rewards'),
      ),
      body: SafeArea(
        child: vendorDetailModel.isEmpty
            ? Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_sharp,
                      color: Color(0xFFDD143D),
                    ),
                    Text(
                      "No Point found",
                      style: TextStyle(
                        color: Color(0xFFDD143D),
                      ),
                    )
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
          itemCount: vendorDetailModel.length,
          itemBuilder: (context, index) {
            final vendor = vendorDetailModel[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: vendor.imageUrl,
                                // Replace with actual image URL
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    color: const Color(0xFFDD143D),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/icon/icon.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // Content Section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vendor.vendorName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                // Progress Bar
                                // Padding(
                                //   padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                //   child: Stack(
                                //     children: [
                                //       Container(
                                //         height: 8,
                                //         decoration: BoxDecoration(
                                //           color: Colors.grey[300],
                                //           borderRadius: BorderRadius.circular(4),
                                //         ),
                                //       ),
                                //       Container(
                                //         height: 8,
                                //         width: 100, // Adjust this width for progress
                                //         decoration: BoxDecoration(
                                //           color: Colors.green,
                                //           borderRadius: BorderRadius.circular(4),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    // Adjust the radius as needed
                                    child: LinearProgressIndicator(
                                      minHeight: 7,
                                      valueColor: AlwaysStoppedAnimation(
                                          Color(0xFFDD143D)),
                                      value: 0.5,
                                    ),
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                              Text(
                                      '${vendor.points} Points',
                                      style: TextStyle(
                                        color: Color(0xFFDD143D),
                                        fontWeight: FontWeight.bold,
                                      ),
                              ),
                                    // Icon
                                    IconButton(
                                      onPressed: () {
                                        // context
                                        //     .read<NepventProvider>()
                                        //     .setVendor(vendor.vendorName);
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
                                      icon: Icon(
                                        Icons.arrow_circle_right_outlined,
                                        color: Colors.brown,
                                        size: 40,
                                      ),
                                    )
                                  ],
                                ),
                        ],
                      ),
                          ),

                          // Arrow Icon Section
                          // Icon(
                          //   Icons.arrow_forward_ios,
                          //   color: Colors.grey,
                          //   size: 20,
                          // ),
                        ],
                      ),
              ),

                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(12),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey.withOpacity(0.5),
                    //         spreadRadius: 2,
                    //         blurRadius: 5,
                    //         offset: Offset(0, 3),
                    //       ),
                    //     ],
                    //   ),
                    //   child:Row(
                    //     children: [
                    //
                    //     CachedNetworkImage(imageUrl: imageUrl)
                    //     ],
                    //   )
                    //
                    //   // Padding(
                    //   //   padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    //   //   child: Column(
                    //   //     crossAxisAlignment: CrossAxisAlignment.start,
                    //   //     children: [
                    //   //       TextButton(
                    //   //         onPressed: () {
                    //   //           Navigator.push(
                    //   //             context,
                    //   //             MaterialPageRoute(
                    //   //               builder: (context) => VendorDetailWidget(
                    //   //                 discount: vendor.discount,
                    //   //                 vendorName: vendor.vendorName,
                    //   //                 imageUrl: vendor.imageUrl,
                    //   //                 address: vendor.address,
                    //   //                 description: vendor.description,
                    //   //                 phone: vendor.phone,
                    //   //                 isLogin: true,
                    //   //                 vendorId: vendor.vId,
                    //   //               ),
                    //   //             ),
                    //   //           );
                    //   //         },
                    //   //         style: TextButton.styleFrom(
                    //   //           padding: EdgeInsets.zero,
                    //   //         ),
                    //   //         child: Text(
                    //   //           vendor.vendorName,
                    //   //           style: TextStyle(
                    //   //             color: Colors.black,
                    //   //             fontSize: 18,
                    //   //             fontFamily: 'Poppins',
                    //   //             fontWeight: FontWeight.w700,
                    //   //           ),
                    //   //         ),
                    //   //       ),
                    //   //       Row(
                    //   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   //         crossAxisAlignment: CrossAxisAlignment.center,
                    //   //         children: [
                    //   //           Row(
                    //   //             children: [
                    //   //               Text(
                    //   //                 'Points :',
                    //   //                 style: TextStyle(
                    //   //                   color: Colors.grey[700],
                    //   //                   fontSize: 14,
                    //   //                   fontWeight: FontWeight.w500,
                    //   //                   fontFamily: 'Poppins',
                    //   //                 ),
                    //   //               ),
                    //   //               Text(
                    //   //                 ' ${vendor.points}',
                    //   //                 style: TextStyle(
                    //   //                   color: Colors.grey[700],
                    //   //                   fontSize: 14,
                    //   //                   fontWeight: FontWeight.w500,
                    //   //                   fontFamily: 'Poppins',
                    //   //                 ),
                    //   //               ),
                    //   //             ],
                    //   //           ),
                    //   //           ElevatedButton(
                    //   //             onPressed: () {
                    //   //               // Handle detail button press
                    //   //               print('Details of ${vendor.vendorName}');
                    //   //               context
                    //   //                   .read<NepventProvider>()
                    //   //                   .setVendor(vendor.vendorName);
                    //   //               Navigator.push(
                    //   //                 context,
                    //   //                 MaterialPageRoute(
                    //   //                   builder: (context) => LoginDashboardWidget(
                    //   //                     profileUrl: '',
                    //   //                     tabIndex: 3,
                    //   //                   ),
                    //   //                 ),
                    //   //               );
                    //   //             },
                    //   //             style: ElevatedButton.styleFrom(
                    //   //               backgroundColor: const Color(0xFFDD143D),
                    //   //               shape: RoundedRectangleBorder(
                    //   //                 borderRadius: BorderRadius.circular(8),
                    //   //               ),
                    //   //               padding: const EdgeInsets.symmetric(
                    //   //                 vertical: 10,
                    //   //                 horizontal: 16,
                    //   //               ),
                    //   //             ),
                    //   //             child: Text(
                    //   //               'Detail',
                    //   //               style: TextStyle(
                    //   //                 color: Colors.white,
                    //   //                 fontSize: 14,
                    //   //                 fontWeight: FontWeight.bold,
                    //   //                 fontFamily: 'Poppins',
                    //   //               ),
                    //   //             ),
                    //   //           ),
                    //   //         ],
                    //   //       ),
                    //   //     ],
                    //   //   ),
                    //   // ),
                    // ),
                  );
          },
        ),
      ),
    );
  }
}
