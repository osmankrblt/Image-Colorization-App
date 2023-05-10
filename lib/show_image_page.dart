import 'dart:io';
import 'package:image_colorizer/utils/utils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  late Uint8List imgBytes;

  ImageScreen({
    Key? key,
    required this.imgBytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
            onPressed: () async {
              var status = await Permission.manageExternalStorage.status;
              if (status.isDenied) {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.manageExternalStorage,
                  Permission.storage,
                ].request();
              }

              if (await Permission.location.isRestricted) {}

              final result = await ImageGallerySaver.saveImage(
                Uint8List.fromList(
                  imgBytes,
                ),
                quality: 80,
                name: DateTime.now().toString(),
              );
              Navigator.of(context).pop();
              showToast("Image saved successfully");
            },
          )
        ],
        backgroundColor: Colors.black,
      ),
      body: Material(
        color: Colors.black,
        child: Center(
          child: Container(
            color: Colors.black,
            child: showImageRectangle(
              imgBytes,
              500,
            ),
          ),
        ),
      ),
    );
  }
}

Widget showImageRectangle(Uint8List imgBytes, int maxWidthForCache) {
  return imgBytes != []
      ? Image.memory(
          imgBytes,
          fit: BoxFit.contain,
        )
      : Container(
          width: 480,
          height: 250,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.rectangle,
          ),
          child: const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 100,
          ),
        );
}
