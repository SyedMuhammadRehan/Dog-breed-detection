import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dog_breed_detection/resources/assets.dart';
import 'package:dog_breed_detection/resources/colormanager.dart';
import 'package:dog_breed_detection/resources/fontsmanager.dart';
import 'package:dog_breed_detection/resources/sizeconfig.dart';
import 'package:dog_breed_detection/resources/stringmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import '../main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool iscamera = true;
  Future<void>? _initializeControllerFuture;
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
      _initializeControllerFuture = cameraController.initialize();
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

  loaddatamodel() async {
    Tflite.close();
    var tf = await Tflite.loadModel(
      model: "assets/tflite_model/bread.tflite",
      labels: "assets/tflite_model/label.txt",
      numThreads: 1,
    );
    print("success $tf ");
  }

  var output;
  Future<List?> classifyImage(File image) async {
    output = await Tflite.runModelOnImage(
      path: image.path, // required
      imageMean: 0.0,
      imageStd: 300.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );
    print("RESULT $result");
    print("detected output is ${output![0]['label']}");

    setState(() {
      result = output[0]['label'];
      print("RESULT $result");
    });
    await showbottomsheet();
    return output;
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    onNewCameraSelected(cameras[0]);
    loaddatamodel();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller != null
          ? _initializeControllerFuture = controller!.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  var imagpicker = ImagePicker();
  Future getimagefromgallery() async {
    var img = await imagpicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(img!.path);
    });
    classifyImage(imageFile!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
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
            GestureDetector(
              onTap: () {
                setState(() {
                  iscamera = true;
                });
              },
              child: Text(
                AppStrings.camera,
                style: TextStyle(
                    color: ColorManager.white, fontSize: FontSize.s14),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  iscamera = false;
                });
              },
              child: Text(AppStrings.live,
                  style: TextStyle(
                      color: ColorManager.white, fontSize: FontSize.s14)),
            )
          ],
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return Stack(
                      children: <Widget>[
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return SizedBox(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              child: CameraPreview(controller!),
                            );
                          },
                        ), //Container
                        Positioned(
                            bottom: 80,
                            left: 0,
                            right: 0,
                            child: iscamera == true
                                ? Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: (() {
                                            getimagefromgallery();
                                          }),
                                          child: Icon(
                                            size: getProportionateScreenHeight(
                                                30),
                                            Icons.image,
                                            color: ColorManager.primary,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (() async {
                                            print("camera");
                                            if (controller != null) {
                                              if (controller!
                                                  .value.isInitialized) {
                                                var img = await controller!
                                                    .takePicture();
                                                setState(() {
                                                  imageFile = File(img.path);
                                                  imgfile = true;
                                                });
                                                classifyImage(imageFile!);
                                                imageFile != null
                                                    ? showModalBottomSheet(
                                                        elevation: 50,
                                                        isDismissible: true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        enableDrag: true,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                20.0),
                                                                        topRight:
                                                                            Radius.circular(
                                                                                20.0)),
                                                                    color: Colors
                                                                        .transparent,
                                                                    image: DecorationImage(
                                                                        fit: BoxFit.fill,
                                                                        image: AssetImage(
                                                                          ImageAssets
                                                                              .bottom,
                                                                        ))),
                                                            child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: ColorManager
                                                                      .white
                                                                      .withOpacity(
                                                                          0.3),
                                                                  borderRadius: const BorderRadius
                                                                          .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20.0)),
                                                                ),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
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
                                                                      width: getProportionateScreenWidth(
                                                                          250),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                ColorManager.primary,
                                                                            width: 10),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(10.0),
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .contain,
                                                                          child:
                                                                              CircleAvatar(
                                                                            foregroundImage:
                                                                                Image.file(imageFile!).image,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          getProportionateScreenHeight(
                                                                              10),
                                                                    ),
                                                                    Card(
                                                                      color: ColorManager
                                                                          .primary,
                                                                      shadowColor:
                                                                          ColorManager
                                                                              .black,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(50),
                                                                      ),
                                                                      elevation:
                                                                          20,
                                                                      child:
                                                                          ListTile(
                                                                        dense:
                                                                            true,
                                                                        focusColor:
                                                                            ColorManager.white,
                                                                        leading:
                                                                            Text(
                                                                          "DOG BREED:",
                                                                          style: TextStyle(
                                                                              color: ColorManager.white,
                                                                              fontSize: FontSize.s18,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        title:
                                                                            Text(
                                                                          result,
                                                                          style: TextStyle(
                                                                              color: ColorManager.white,
                                                                              fontSize: FontSize.s18),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          );
                                                        })
                                                    : Navigator.pop(context);
                                              }
                                            }
                                            setState(() {
                                              imgfile = false;
                                            });
                                          }),
                                          child: Container(
                                            height:
                                                getProportionateScreenHeight(
                                                    100),
                                            width: getProportionateScreenWidth(
                                                100),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: ColorManager.primary),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height:
                                                    getProportionateScreenHeight(
                                                        60),
                                                width:
                                                    getProportionateScreenWidth(
                                                        60),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: ColorManager.primary,
                                                ),
                                                child: Icon(
                                                  Icons.search,
                                                  size:
                                                      getProportionateScreenHeight(
                                                          40),
                                                  color: ColorManager.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox()
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: 300,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    child: Text(
                                      result,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    )))
                        //Container
                        //Container
                      ], //<Widget>[]
                    );
                  } else {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Otherwise, display a loading indicator.
                  }
                }),
          ),
        ],
      )),
    );
  }

  Future showbottomsheet() {
    return showModalBottomSheet(
        elevation: 50,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        context: context,
        builder: (context) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                color: Colors.transparent,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      ImageAssets.bottom,
                    ))),
            child: Container(
                decoration: BoxDecoration(
                  color: ColorManager.white.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Container(
                      height: getProportionateScreenHeight(250),
                      width: getProportionateScreenWidth(250),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: ColorManager.primary, width: 10),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CircleAvatar(
                            foregroundImage: Image.file(imageFile!).image,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Card(
                      color: ColorManager.primary,
                      shadowColor: ColorManager.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 20,
                      child: ListTile(
                        dense: true,
                        focusColor: ColorManager.white,
                        leading: Text(
                          "DOG BREED:",
                          style: TextStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s18,
                              fontWeight: FontWeight.bold),
                        ),
                        title: Text(
                          result,
                          style: TextStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s18),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
