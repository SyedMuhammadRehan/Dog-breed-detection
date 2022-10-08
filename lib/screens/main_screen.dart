import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dog_breed_detection/resources/assets.dart';
import 'package:dog_breed_detection/resources/colormanager.dart';
import 'package:dog_breed_detection/resources/fontsmanager.dart';
import 'package:dog_breed_detection/resources/sizeconfig.dart';
import 'package:dog_breed_detection/resources/stringmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  File? imageFile;
  bool imgfile = false;
  CameraImage? imgcamera;
  bool isWorking = false;
  String result = '';
  bool _isCameraInitialized = false;
  CameraController? controller;
  late CameraDescription cameraDescription;
  CameraLensDirection cameraLensDirection = CameraLensDirection.back;
  final bool _isRearCameraSelected = true;
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    // runModelonFrame() async {
    //   if (imgcamera != null) {
    //     var recognitions = await Tflite.runModelOnFrame(
    //         bytesList: imgcamera!.planes.map((plane) {
    //           return plane.bytes;
    //         }).toList(),
    //         imageHeight: imgcamera!.height,
    //         imageWidth: imgcamera!.width,
    //         imageMean: 127.5,
    //         imageStd: 127.5,
    //         rotation: 90,
    //         numResults: 2,
    //         threshold: 0.4,
    //         asynch: true);
    //     result = '';

    //     for (var response in recognitions!) {
    //       {
    //         result += response["label"] + "\n";
    //       }
    //     }
    //     setState(() {
    //       result;
    //     });
    //     isWorking = false;
    //   }
    // }

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _isCameraInitialized = controller!.value.isInitialized;
      // cameraController.startImageStream((imagestream) => {
      //       if (!isWorking)
      //         {isWorking = true, imgcamera = imagestream, runModelonFrame()}
      //     });
    });
    // Update the Boolean
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    onNewCameraSelected(cameras[0]);

    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      bottomSheet: Container(
        color: ColorManager.primary,
        height: getProportionateScreenHeight(60),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.camera,
              style:
                  TextStyle(color: ColorManager.white, fontSize: FontSize.s14),
            ),
            Text(AppStrings.live,
                style: TextStyle(
                    color: ColorManager.white, fontSize: FontSize.s14))
          ],
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Flexible(
            child: Stack(
              children: <Widget>[
                _isCameraInitialized
                    ? AspectRatio(
                        aspectRatio: 2 / 4,
                        child: controller!.buildPreview(),
                      )
                    : Container(), //Container
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          size: getProportionateScreenHeight(30),
                          Icons.image,
                          color: ColorManager.primary,
                        ),
                        InkWell(
                          onTap: (() async {
                            if (controller != null) {
                              if (controller!.value.isInitialized) {
                                var img = await controller!.takePicture();
                                setState(() {
                                  imageFile = File(img.path);
                                  imgfile = true;
                                });

                                await showModalBottomSheet(
                                    elevation: 50,
                                    isDismissible: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight:
                                                    Radius.circular(20.0)),
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: AssetImage(
                                                  ImageAssets.bottom,
                                                ))),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: ColorManager.white
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      topRight: Radius.circular(
                                                          20.0)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height:
                                                      getProportionateScreenHeight(
                                                          10),
                                                ),
                                                Container(
                                                  height:
                                                      getProportionateScreenHeight(
                                                          250),
                                                  width:
                                                      getProportionateScreenWidth(
                                                          250),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: ColorManager
                                                            .primary,
                                                        width: 5),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: CircleAvatar(
                                                      foregroundImage:
                                                          Image.file(imageFile!)
                                                              .image,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      getProportionateScreenHeight(
                                                          10),
                                                ),
                                                Card(
                                                  shadowColor:
                                                      ColorManager.primary,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  elevation: 20,
                                                  child: ListTile(
                                                    dense: true,
                                                    focusColor:
                                                        ColorManager.primary,
                                                    leading: Text(
                                                      "DOG BREED",
                                                      style: TextStyle(
                                                          color: ColorManager
                                                              .primary,
                                                          fontSize:
                                                              FontSize.s18),
                                                    ),
                                                    title: const Text("TEXT"),
                                                  ),
                                                )
                                              ],
                                            )),
                                      );
                                    });
                              }
                            }
                            setState(() {
                              imgfile = false;
                            });
                          }),
                          child: Container(
                            height: getProportionateScreenHeight(100),
                            width: getProportionateScreenWidth(100),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: ColorManager.primary),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: getProportionateScreenHeight(60),
                                width: getProportionateScreenWidth(60),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorManager.primary,
                                ),
                                child: Icon(
                                  Icons.search,
                                  size: getProportionateScreenHeight(40),
                                  color: ColorManager.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox()
                      ],
                    ),
                  ),
                ), //Container
                //Container
              ], //<Widget>[]
            ),
          ),
        ],
      )),
    );
  }
}
