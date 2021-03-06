import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:k6_app/models/seller_model.dart';
import 'package:k6_app/models/shop_model.dart';
import 'package:k6_app/models/user_models.dart';
import 'package:k6_app/utility/my_constant.dart';
import 'package:k6_app/utility/my_style.dart';
import 'package:k6_app/utility/normal_dialog.dart';
import 'package:k6_app/screens/User/chatpage.dart';

class DetailShop extends StatefulWidget {
  final ShopModel shopModel;
  final UserModel userModel;
  DetailShop({required this.shopModel, required this.userModel});

  @override
  _DetailShopState createState() => _DetailShopState();
}

class _DetailShopState extends State<DetailShop> {
  ShopModel? shopModels;
  String? idSeller, idUser, name;
  SellerModel? sellerModel;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    setState(() {
      shopModels = widget.shopModel;
      userModel = widget.userModel;
      //print('url ==> ${productModel?.image}');
      readSeller();

      idSeller = shopModels!.idSeller;
      idUser = userModel!.idUser;
    });
  }

  Future<Null> readSeller() async {
    idSeller = shopModels!.idSeller;
    String url =
        '${MyConstant().domain}/api/getSellerfromidSeller.php?isAdd=true&id_seller=$idSeller';
    Response response = await Dio().get(url);

    //print(response);
    var result = json.decode(response.data);
    //print('result = $result');

    for (var map in result) {
      setState(() {
        sellerModel = SellerModel.fromMap(map);
        name = sellerModel!.firstname;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sellerModel == null
          ? MyStyle().showProgress()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  MyStyle().showTitleH2('รูปผู้ขาย: '),
                  imageSeller(),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () {
                              checkFollow();
                            },
                            icon: Icon(Icons.add),
                            label: Text('ติดตาม')),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        MyStyle().showTitleH2('ชื่อผู้ขาย: '),
                        Text(
                          sellerModel!.firstname + '  ' + sellerModel!.lastname,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        MyStyle().showTitleH2('ชื่อร้าน: '),
                        Text(
                          shopModels!.nameshop,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        MyStyle().showTitleH2('เบอร์โทรติดต่อ: '),
                        Text(
                          sellerModel!.phone,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyStyle().showTitleH2('รูปร้าน: '),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: showImage(),
                  ),
                ]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(
              builder: (value) => ChatPage(
                    sellerModel: sellerModel!,
                    userModel: userModel!,
                  ));
          Navigator.of(context).push(route);
        },
        child: const Icon(Icons.chat),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget showImage() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Image.network(
          '${MyConstant().domain}/upload/shop/${shopModels!.image}',
          fit: BoxFit.contain,
        ));
  }

  Widget imageSeller() {
    return Center(
      child: CircleAvatar(
        radius: 100,
        child: ClipOval(
            child: Image.network(
          '${MyConstant().domain}/upload/seller/${sellerModel!.image}',
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        )),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Future<Null> checkFollow() async {
    String url =
        '${MyConstant().domain}/api/checkfollow.php?isAdd=true&id_user=$idUser&id_seller=$idSeller';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        addfollow();
      } else {
        unfollow();
      }
    } catch (e) {}
  }

  Future<Null> addfollow() async {
    String url =
        '${MyConstant().domain}/api/addFollow.php?isAdd=true&id_user=$idUser&id_seller=$idSeller';

    try {
      Response response = await Dio().get(url);
      //print('res = $response');

      if (response.toString() == 'true') {
        normalDialog(context, 'ติดตาม $name แล้ว');
      } else {
        normalDialog(context, 'ล้มเหลว ลองอีกครั้ง');
      }
    } catch (e) {}
  }

  Future<Null> unfollow() async {
    String url =
        '${MyConstant().domain}/api/unFollow.php?isAdd=true&id_user=$idUser&id_seller=$idSeller';

    try {
      Response response = await Dio().get(url);
      //print('res = $response');

      if (response.toString() == 'true') {
        normalDialog(context, 'ยกเลิกติดตาม $name แล้ว');
      } else {
        normalDialog(context, 'ล้มเหลว ลองอีกครั้ง');
      }
    } catch (e) {}
  }
}
