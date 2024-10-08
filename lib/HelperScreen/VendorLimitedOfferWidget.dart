import 'package:flutter/material.dart';

class VendorLimitedOfferWidget extends StatelessWidget {
  final int discount;
  final String vendorName;
  final String imageUrl;

  const VendorLimitedOfferWidget({
    super.key,
    required this.discount,
    required this.vendorName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Discount Tag
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:Color(0xFFDD143D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$discount% Off',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Vendor Name
          Positioned(
            bottom: 8,
            left: 8,
            child: Text(
              vendorName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: Offset(1, 1),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
