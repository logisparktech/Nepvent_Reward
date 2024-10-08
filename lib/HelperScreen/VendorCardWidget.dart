import 'package:flutter/material.dart';

class VendorWidget extends StatelessWidget {
  final int discount;
  final String vendorName;
  final String imageUrl;
  final String address; // Added address property

  const VendorWidget({
    super.key,
    required this.discount,
    required this.vendorName,
    required this.imageUrl,
    required this.address, // Added this argument
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Background Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: 315,
                  height: 200,
                ),
              ),
              // Discount Tag
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDD143D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$discount% Off',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Vendor Name
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              top: 4.0,
            ),
            child: Text(
              vendorName,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              top: 4.0,
            ),
            child: Text(
              address,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600
              ),
            ),
          ),

        ],
      ),
    );
  }
}
