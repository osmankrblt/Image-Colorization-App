import 'dart:convert';
import 'dart:io';
import 'constants.dart';
import 'detection_page.dart';
import "detector.dart";
import 'extensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DetectionPage();
  }
}
