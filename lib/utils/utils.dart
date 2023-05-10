import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String? content) {
  if (content == null) return;
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: content,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    fontSize: 16.0,
  );
}
