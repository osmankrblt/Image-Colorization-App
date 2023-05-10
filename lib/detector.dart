import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'utils/utils.dart';

class Detector {
  Future<dynamic> predict(File image) async {
    List<int> imageBytes = image.readAsBytesSync();

    String base64Image = base64Encode(imageBytes);

    try {
      http.Response response = await http.post(
          Uri.parse('http://192.168.0.105:5000/predict'),
          body: <String, String>{
            'file': base64Image,
          },
          headers: <String, String>{
            "Connection": "Keep-Alive",
          });
      if (response.statusCode == 200) {
      } else {
        showToast('A network error occurred');
      }

      Uint8List result = base64.decode(response.body);

      return result;
    } catch (e) {
      debugPrint(e.toString());

      showToast(e.toString());
    }
  }
}
