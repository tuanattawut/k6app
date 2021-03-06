import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(message),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        )
      ],
    ),
  );
}

Future<void> normalDialog2(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        leading: Image.asset('images/logo.png'),
        title: Text(title),
        subtitle: Text(message),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        )
      ],
    ),
  );
}

Future<Null> alertLocationService(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: ListTile(
        title: Text(title),
        subtitle: Text(message),
      ),
      actions: [
        TextButton(
            onPressed: () async {
              // Navigator.pop(context);
              await Geolocator.openLocationSettings();
              exit(0);
            },
            child: Text('OK'))
      ],
    ),
  );
}

Future<Null>? showLoade(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 7), child: Text("กำลังโหลด...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<Null>? showSend(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text("กำลังส่ง...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
