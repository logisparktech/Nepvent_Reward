class VendorDetailModel {
  final String vendorName;
  final String address;
  final String imageUrl;
  final String description;
  final String phone;
  final int points;
  final int discount;
  final String vId;

  VendorDetailModel({
    required this.vendorName,
    required this.points,
    required this.vId,
    required this.address,
    required this.description,
    required this.phone,
    required this.imageUrl,
    required this.discount,
  });
}
