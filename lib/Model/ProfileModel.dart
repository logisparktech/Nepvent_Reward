class ProfileModel {
  final String id;
  final int point;
  final String memberId;
  final String name;
  final String email;
  final String phone;
  final String district;
  final String address;
  final String province;
  final String secondaryNumber;
  final String avatarUrl;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.point,
    required this.phone,
    required this.district,
    required this.address,
    required this.province,
    required this.secondaryNumber,
    required this.avatarUrl,
    required this.memberId,
  });
}
