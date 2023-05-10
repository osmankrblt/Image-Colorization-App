import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_colorizer/show_image_page.dart';
import 'package:image_colorizer/utils/utils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constants.dart';
import "detector.dart";
import 'extensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetectionPage extends StatefulWidget {
  DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  XFile? selectedImage = null;

  late Detector detector;

  late Uint8List colorfulImage;

  bool isLoading = false;
  bool bottomVisibility = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    detector = Detector();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomVisibility
          ? IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.black,
                size: 35,
              ),
              onPressed: () {
                showResult(
                  context.dynamicHeight(
                    0.4,
                  ),
                );
                setState(() {});
              },
            )
          : SizedBox(),
      appBar: AppBar(
        title: const Text(
          "Image Colorizer",
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          showImage(
            context.dynamicHeight(
              0.5,
            ),
          ),
          showButtons(
            context.dynamicHeight(
              0.05,
            ),
          ),
        ],
      ),
    );
  }

  Container showButtons(double height) {
    return Container(
      height: height,
      child: ElevatedButton(
        child: const Text(
          "Gallery",
        ),
        onPressed: () async {
          await pickImage(
            ImageSource.gallery,
          );
          if (selectedImage != null) {
            await detectImage();
          }
        },
      ),
    );
  }

  showResult(double height) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: height,
              child: isLoading && colorfulImage == null
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageScreen(
                                    imgBytes: colorfulImage,
                                  ),
                                ),
                              );
                            },
                            child: Image.memory(
                              colorfulImage,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.download_rounded,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            var status =
                                await Permission.manageExternalStorage.status;
                            if (status.isDenied) {
                              Map<Permission, PermissionStatus> statuses =
                                  await [
                                Permission.manageExternalStorage,
                                Permission.storage,
                              ].request();
                            }

                            if (await Permission.location.isRestricted) {}

                            final result = await ImageGallerySaver.saveImage(
                              Uint8List.fromList(
                                colorfulImage,
                              ),
                              quality: 80,
                              name: DateTime.now().toString(),
                            );
                            Navigator.of(context).pop();

                            showToast("Image saved successfully");
                          },
                        ),
                      ],
                    ),
            ),
          );
        });
  }

  Container showImage(double height) {
    return Container(
      height: height,
      child: selectedImage != null
          ? Container(
              margin: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(
                    File(
                      selectedImage!.path,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              margin: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                ),
              ),
            ),
    );
  }

  pickImage(source) async {
    final ImagePicker picker = ImagePicker();

    selectedImage = await picker.pickImage(
      source: source,
    );

    setState(() {});
  }

  detectImage() async {
    isLoading = true;

    colorfulImage = await detector.predict(
      File(
        selectedImage!.path,
      ),
    );

    isLoading = false;
    bottomVisibility = true;
    showResult(
      context.dynamicHeight(
        0.4,
      ),
    );
    setState(() {});
  }
}
