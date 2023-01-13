import 'package:camera/camera.dart';
import 'package:dog_breed_detection/resources/colormanager.dart';
import 'package:dog_breed_detection/resources/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main.dart';
import '../riverpod/detection_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  Future<void>? _initializeControllerFuture;
  bool _isCameraInitialized = false;
  CameraController? controller;
  late CameraDescription cameraDescription;
  CameraLensDirection cameraLensDirection = CameraLensDirection.back;
  bool _isRearCameraSelected = true;
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    // final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    // await previousCameraController?.dispose();

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
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  final notifierProvider = ChangeNotifierProvider<ImageNotifier>((ref) {
    return ImageNotifier();
  });

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    ref.read(notifierProvider.notifier).loaddatamodel();
    onNewCameraSelected(cameras[0]);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller != null
          ? _initializeControllerFuture = controller!.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
    if (state == AppLifecycleState.inactive) {
      controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(controller!.description);
    }
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
                        ),
                        Positioned(
                          top: 10,
                          left: 15,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                alignment: Alignment.centerRight,
                                width: MediaQuery.of(context).size.width * 0.11,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorManager.white.withOpacity(0.3),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: ColorManager.primary,
                                  ),
                                )),
                          ),
                        ), //Container
                        //Container
                        Positioned(
                            bottom: 100,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: (() {
                                      ref
                                          .read(notifierProvider.notifier)
                                          .getimagefromgallery(context)
                                          .then((value) =>
                                              print(value.toString()));
                                    }),
                                    child: Icon(
                                      size: getProportionateScreenHeight(30),
                                      Icons.image_outlined,
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (() async {
                                      if (controller != null) {
                                      
                                        if (controller!.value.isInitialized) {
                                          ref
                                              .watch(notifierProvider)
                                              .getimagefromscreen(
                                                  context, controller);
                                        }
                                      }
                                    }),
                                    child: Container(
                                      height: getProportionateScreenHeight(100),
                                      width: getProportionateScreenWidth(100),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: ColorManager.primary),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height:
                                              getProportionateScreenHeight(60),
                                          width:
                                              getProportionateScreenWidth(60),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorManager.primary,
                                          ),
                                          child: Icon(
                                            Icons.search,
                                            size: getProportionateScreenHeight(
                                                40),
                                            color: ColorManager.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isCameraInitialized = false;
                                      });
                                      onNewCameraSelected(
                                        cameras[_isRearCameraSelected ? 1 : 0],
                                      );
                                      setState(() {
                                        _isRearCameraSelected =
                                            !_isRearCameraSelected;
                                      });
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          _isRearCameraSelected
                                              ? Icons.camera_front
                                              : Icons.camera_rear,
                                          color: ColorManager.primary,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))

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
}
