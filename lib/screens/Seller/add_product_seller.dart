import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k6_app/models/shop_model.dart';
import 'package:k6_app/utility/my_constant.dart';
import 'package:k6_app/utility/my_style.dart';
import 'package:k6_app/utility/normal_dialog.dart';

class AddProduct extends StatefulWidget {
  AddProduct({required this.shopModel});
  final ShopModel shopModel;
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String? nameProduct, price, detail, image, idcategory;

  File? file;
  List categoryItemList = [];
  List subcategoryItemList = [];
  String? selectedValue, subValue;
  ShopModel? shopModel;
  String? idshop;

  @override
  void initState() {
    super.initState();
    shopModel = widget.shopModel;
    readCategory();
  }

  Future<Null> readCategory() async {
    String api = '${MyConstant().domain}/api/getCategory.php';
    await Dio().get(api).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          categoryItemList.add(item);
        });
      }
    });

    //print(categoryItemList);
  }

  Future<Null> readsubCategory() async {
    String api =
        '${MyConstant().domain}/api/getSubcategoryfromidCategory.php?isAdd=true&id_category=$selectedValue';
    await Dio().get(api).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          subcategoryItemList.add(item);
        });
      }
    });
    // print(subcategoryItemList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการสินค้า'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: <Widget>[
              showTitleFood('รูปสินค้า'),
              groupImage(),
              showTitleFood('รายละเอียดสินค้า'),
              nameForm(),
              MyStyle().mySizebox(),
              dropdowncategory(),
              dropdownsubcategory(),
              detailForm(),
              MyStyle().mySizebox(),
              priceForm(),
              MyStyle().mySizebox(),
              saveButton(),
              MyStyle().mySizebox(),
            ],
          ),
        ),
      ),
    );
  }

  Row dropdowncategory() {
    return Row(
      children: [
        DropdownButton(
          hint: Text('เลือกประเภทสินค้า'),
          value: selectedValue,
          items: categoryItemList.map((list) {
            return DropdownMenuItem(
              value: list['id_category'].toString(),
              child: Text(list['namecategory']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedValue = value.toString();
              readsubCategory();
              print(selectedValue);
              dropdownsubcategory();
            });
          },
        ),
      ],
    );
  }

  Row dropdownsubcategory() {
    return Row(
      children: [
        DropdownButton(
          hint: Text('เลือกประเภทสินค้าย่อย'),
          value: subValue,
          items: subcategoryItemList.map((sublist) {
            return DropdownMenuItem(
              value: sublist['id_subcategory'].toString(),
              child: Text(sublist['namesubcategory']),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              subValue = newValue;
              // print(subValue);
            });
          },
        ),
      ],
    );
  }

  ElevatedButton saveButton() {
    return ElevatedButton(
      child: Text('บันทึกข้อมูล'),
      onPressed: () {
        if (nameProduct == null ||
            nameProduct!.isEmpty ||
            price == null ||
            price!.isEmpty ||
            detail == null ||
            detail!.isEmpty) {
          normalDialog(context, 'โปรดกรอกให้ครบทุกช่องด้วย');
        } else if (file == null) {
          normalDialog(context, 'โปรดเลือกรูปภาพด้วย');
        } else if (subValue == null) {
          normalDialog(context, 'โปรดเลือกหมวดหมู่');
        } else {
          uploadImage();
          showLoade(context);
        }
      },
    );
  }

  Future<Null> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'product_$i.jpg';
    //print('nameImage = $nameImage, pathImage = ${file!.path}');

    String url = '${MyConstant().domain}/upload/saveImageProduct.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) async {
        // print('Response ===>>> $value');
        image = '$nameImage';
        // print('urlImage = $image');
        await addProduct();
      });
    } catch (e) {}
  }

  Future<Null> addProduct() async {
    idshop = shopModel!.idShop;
    Navigator.pop(context);
    String url =
        '${MyConstant().domain}/api/addProduct.php?isAdd=true&id_shop=$idshop&id_subcategory=$subValue&nameproduct=$nameProduct&detail=$detail&price=$price&image=$image';

    try {
      Response response = await Dio().get(url);
      //print('res = $response');

      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ผิดพลาดโปรดลองอีกครั้ง');
      }
    } catch (e) {}
  }

  TextFormField nameForm() {
    return TextFormField(
      onChanged: (value) => nameProduct = value.trim(),
      decoration: InputDecoration(
        labelText: 'ชื่อสินค้า :',
      ),
    );
  }

  TextFormField priceForm() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) => price = value.trim(),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
        labelText: 'ราคาสินค้า :',
        suffixText: 'บาท',
      ),
    );
  }

  TextFormField detailForm() {
    return TextFormField(
      onChanged: (value) => detail = value.trim(),
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'รายละเอียดสินค้า :',
      ),
    );
  }

  Column groupImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          child: file == null
              ? Image.asset('images/productmenu.png')
              : Image.file(file!),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () => chooseImage(ImageSource.camera),
              label: Text('ถ่ายภาพ'),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.image),
              onPressed: () => chooseImage(ImageSource.gallery),
              label: Text('เลือกจากคลัง'),
            ),
          ],
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );

      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  Widget showTitleFood(String string) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          MyStyle().showTitleH2(string),
        ],
      ),
    );
  }
}
