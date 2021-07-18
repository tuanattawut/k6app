import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:k6_app/models/user_models.dart';
import 'package:k6_app/screens/Seller/loginseller.dart';
import 'package:k6_app/screens/User/main_user.dart';
import 'package:k6_app/utility/my_constant.dart';
import 'package:k6_app/utility/my_style.dart';
import 'package:k6_app/utility/normal_dialog.dart';
import 'package:k6_app/widget/User/loginfacebook.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formstate = GlobalKey<FormState>();

  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formstate,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().showLogo(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ระบบแนะนำสินค้าและร้านค้า',
                  style: MyStyle().mainTitle,
                ),
              ],
            ),
            MyStyle().mySizebox(),
            buildEmailField(),
            buildPasswordField(),
            MyStyle().mySizebox(),
            buildLoginButton(),
            buildRegisterButton(context),
            LoginFacebook(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: buildSellerButton(),
                ),
                MyStyle().mySizebox(),
                MyStyle().mySizebox(),
                Expanded(
                  flex: 1,
                  child: buildManagerButton(),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  ElevatedButton buildManagerButton() {
    return ElevatedButton(
        child: Text('สำหรับผู้จัดการ'),
        onPressed: () async {
          normalDialog(context, 'คลิกทำไมครับ');
        });
  }

  ElevatedButton buildSellerButton() {
    return ElevatedButton(
        child: Text('สำหรับผู้ขาย'),
        onPressed: () async {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (value) => LoginSeller());
          Navigator.of(context).push(route);
        });
  }

  ElevatedButton buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      child: Text('สมัครสมาชิกใหม่'),
      onPressed: () {
        print('Goto  Regis pagge');
        Navigator.pushNamed(context, '/register');
      },
    );
  }

  ElevatedButton buildLoginButton() {
    return ElevatedButton(
        child: Text('ล็อกอิน'),
        onPressed: () async {
          if (this._formstate.currentState!.validate()) {
            print('email =====> $email\npassword =====> $password');
            if (email == null ||
                email!.isEmpty ||
                !email!.contains('@') ||
                password == null ||
                password!.isEmpty ||
                password!.length < 6) {
              normalDialog(context, 'กรุณากรอกข้อมูลให้ถูกต้อง');
            } else {
              checkAuthen();
            }
          }
        });
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      onChanged: (value) => password = value.trim(),
      validator: (value) {
        if (value!.length < 6)
          return 'โปรดกรอกพาสเวิร์ด 6 ตัวขึ้นไป';
        else
          return null;
      },
      obscureText: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'พาสเวิร์ด',
        icon: Icon(Icons.lock),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      onChanged: (value) => email = value.trim(),
      validator: (value) {
        if (value!.isEmpty || !value.contains('@'))
          return 'โปรดกรอกอีเมลให้ถูกต้อง';
        else
          return null;
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'อีเมล',
        icon: Icon(Icons.email),
        hintText: 'x@x.com',
      ),
    );
  }

  Future<Null> loginWithFacebook() async {
    // FacebookLogin facebookLogin = FacebookLogin();

    // FacebookLoginResult result =
    //     await facebookLogin.logIn(['email', 'public_profile']);

    // String token = result.accessToken.token;
    // print(token);
    // String userid = result.accessToken.userId;
    // print(' USER ID ===>  $userid');

    //   FirebaseAuth.instance
    //       .signInWithCredential(FacebookAuthProvider.credential(token))
    //       .then((value) async {
    //     uid = value.user.uid;
    //     name = value.user.displayName;
    //     email = value.user.email;
    //     phone = value.user.phoneNumber;

    //     FirebaseFirestore.instance
    //         .collection('user')
    //         .doc(uid)
    //         .snapshots()
    //         .listen((event) {
    //       print('event ==> ${event.data()}');
    //       if (event.data() == null) {
    //         callTypeUserDialog();
    //       } else {
    //         Firebase.initializeApp().then((value) async {
    //           FirebaseFirestore.instance
    //               .collection('user')
    //               .doc(uid)
    //               .snapshots()
    //               .listen((event) {
    //             UserModels model = UserModels.fromMap(event.data());
    //             switch (model.typeuser) {
    //               case 'user':
    //                 Navigator.pushNamed(context, '/homepage');
    //                 break;
    //               case 'seller':
    //                 Navigator.pushNamed(context, '/homeseller');
    //                 break;
    //               case 'manager':
    //                 Navigator.pushNamed(context, '/homemanager');
    //                 break;
    //               default:
    //             }
    //           });
    //         });
    //       }
    //     });
    //   });
    //   print('Token = $token');
    //   switch (result.status) {
    //     case FacebookLoginStatus.error:
    //       print("Error");
    //       break;

    //     case FacebookLoginStatus.cancelledByUser:
    //       print("CancelledByUser");
    //       break;

    //     case FacebookLoginStatus.loggedIn:
    //       print('login');
    //       break;
    //   }
  }

  Future<Null> checkAuthen() async {
    String url =
        '${MyConstant().domain}/projectk6/getUserWhereUser.php?isAdd=true&email=$email';
    print('url ===>> $url');
    try {
      Response response = await Dio().get(url);
      print('res = $response');

      var result = json.decode(response.data);
      print('result = $result');
      if (result == null) {
        normalDialog(context, 'ไม่พบอีเมลนี้ในระบบ กรุณาลองใหม่อีกครั้ง');
      } else {
        for (var map in result) {
          UserModel userModel = UserModel.fromJson(map);
          if (password == userModel.password) {
            //Navigator.pushNamed(context, '/homepage');
            MaterialPageRoute route = MaterialPageRoute(
              builder: (value) => Homepage(
                usermodel: userModel,
              ),
            );
            Navigator.of(context).push(route);
            break;
          } else {
            normalDialog(context, 'พาสเวิร์ดผิด กรุณา ลองอีกครั้ง ');
          }
        }
      }
    } catch (e) {
      normalDialog(context, 'ผิดพลาด');
      print('Have e Error ===>> ${e.toString()}');
    }
  }
}
