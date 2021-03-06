import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  String idProduct;
  String idShop;
  String idSubcategory;
  String nameproduct;
  String price;
  String detail;
  String image;
  String regdate;
  ProductModel({
    required this.idProduct,
    required this.idShop,
    required this.idSubcategory,
    required this.nameproduct,
    required this.price,
    required this.detail,
    required this.image,
    required this.regdate,
  });

  ProductModel copyWith({
    String? idProduct,
    String? idShop,
    String? idSubcategory,
    String? nameproduct,
    String? price,
    String? detail,
    String? image,
    String? regdate,
  }) {
    return ProductModel(
      idProduct: idProduct ?? this.idProduct,
      idShop: idShop ?? this.idShop,
      idSubcategory: idSubcategory ?? this.idSubcategory,
      nameproduct: nameproduct ?? this.nameproduct,
      price: price ?? this.price,
      detail: detail ?? this.detail,
      image: image ?? this.image,
      regdate: regdate ?? this.regdate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idProduct': idProduct,
      'idShop': idShop,
      'idSubcategory': idSubcategory,
      'nameproduct': nameproduct,
      'price': price,
      'detail': detail,
      'image': image,
      'regdate': regdate,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      idProduct: map['id_products'],
      idShop: map['id_shop'],
      idSubcategory: map['id_subcategory'],
      nameproduct: map['nameproduct'],
      price: map['price'],
      detail: map['detail'],
      image: map['image'],
      regdate: map['regdate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(idProduct: $idProduct, idShop: $idShop, idCategory: $idSubcategory, nameproduct: $nameproduct, price: $price, detail: $detail, image: $image,regdate:$regdate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.idProduct == idProduct &&
        other.idShop == idShop &&
        other.idSubcategory == idSubcategory &&
        other.nameproduct == nameproduct &&
        other.price == price &&
        other.detail == detail &&
        other.image == image &&
        other.regdate == regdate;
  }

  @override
  int get hashCode {
    return idProduct.hashCode ^
        idShop.hashCode ^
        idSubcategory.hashCode ^
        nameproduct.hashCode ^
        price.hashCode ^
        detail.hashCode ^
        image.hashCode ^
        regdate.hashCode;
  }
}
