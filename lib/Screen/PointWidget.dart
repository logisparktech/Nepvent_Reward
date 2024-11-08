import 'package:flutter/material.dart';
import 'package:nepvent_reward/Provider/NepventProvider.dart';
import 'package:nepvent_reward/Screen/LoginDashboardWidget.dart';
import 'package:nepvent_reward/Screen/VendorDetailWidget.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:provider/provider.dart';

class PointWidget extends StatefulWidget {
  const PointWidget({super.key});

  @override
  State<PointWidget> createState() => _PointWidgetState();
}

class _PointWidgetState extends State<PointWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Vendor Detail : $vendorDetailModel');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Point/Rewards'),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: vendorDetailModel.length,
          itemBuilder: (context, index) {
            final vendor = vendorDetailModel[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VendorDetailWidget(
                                discount: vendor.discount,
                                vendorName: vendor.vendorName,
                                imageUrl: vendor.imageUrl,
                                address: vendor.address,
                                description: vendor.description,
                                phone: vendor.phone,
                                isLogin: true,
                                vendorId: vendor.vId,
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          vendor.vendorName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Points :',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                ' ${vendor.points}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle detail button press
                              print('Details of ${vendor.vendorName}');
                              context
                                  .read<NepventProvider>()
                                  .setVendor(vendor.vendorName);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginDashboardWidget(
                                    profileUrl: '',
                                    tabIndex: 3,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDD143D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                            ),
                            child: Text(
                              'Detail',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
