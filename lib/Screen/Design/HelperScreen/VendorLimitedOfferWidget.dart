import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Screen/VendorDetailWidget.dart';

class VendorLimitedOfferWidget extends StatelessWidget {
  final int discount;
  final String vendorName;
  final String imageUrl;
  final String address;
  final String description;
  final String phone;
  final String vendorId;
  final bool isLogin;

  const VendorLimitedOfferWidget({
    super.key,
    required this.discount,
    required this.vendorName,
    required this.imageUrl,
    required this.address,
    required this.description,
    required this.phone,
    required this.isLogin,
    required this.vendorId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorDetailWidget(
                discount: discount,
                vendorName: vendorName,
                imageUrl: imageUrl,
                address: address,
                description: description,
                phone: phone,
                isLogin: isLogin,
                vendorId: vendorId,
              ),
            ),
          );
        },
        child: Stack(
          children: [
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
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
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/icon/icon.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Discount Tag
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFDD143D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  discount == -1 ? 'FREE Items' : '$discount% OFF',
                  textAlign: TextAlign.center,
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
      ),
    );
  }
}
