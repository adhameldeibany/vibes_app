class VendorModel{
  String id, name, exprience, imgurl;
  String? website, facebook, insta;

  VendorModel({
    required this.id,
    required this.name,
    required this.exprience,
    required this.imgurl,
    this.website,
    this.facebook,
    this.insta
  });
}