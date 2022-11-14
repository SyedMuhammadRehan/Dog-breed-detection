import 'package:camera/camera.dart';
import 'package:dog_breed_detection/resources/colormanager.dart';
import 'package:dog_breed_detection/resources/fontsmanager.dart';
import 'package:dog_breed_detection/riverpod/detection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main.dart';
import '../resources/sizeconfig.dart';

class Communication extends ConsumerStatefulWidget {
  const Communication({Key? key}) : super(key: key);

  @override
  ConsumerState<Communication> createState() => _CommunicationState();
}

class _CommunicationState extends ConsumerState<Communication> {
  bool imgfile = false;
  CameraImage? imgcamera;
  bool _isCameraInitialized = false;
  CameraController? controller;
  late CameraDescription cameraDescription;
  CameraLensDirection cameraLensDirection = CameraLensDirection.back;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated

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
      cameraController.startImageStream((imagestream) => {
            if (!ref.read(notifierProvider.notifier).isWorking)
              {
                ref.read(notifierProvider.notifier).isWorking = true,
                imgcamera = imagestream,
                ref.read(notifierProvider.notifier).runModelonFrame(imgcamera)
              }
          });
    });
    // Update the Boolean
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
          ? controller!.initialize()
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
              child: Stack(
                children: <Widget>[
                  _isCameraInitialized
                      ? LayoutBuilder(
                          builder: (context, constraints) {
                            return SizedBox(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              child: CameraPreview(controller!),
                            );
                          },
                        )
                      : Container(),
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
                          height: MediaQuery.of(context).size.height * 0.07,
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

                  Positioned(
                    bottom: 130,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.08,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: ColorManager.primary.withOpacity(0.6)),
                          child: Text(
                            ref.watch(notifierProvider).liveresult ??
                                'Nothing to be detected',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s17,
                                fontWeight: FontWeightManager.bold),
                          )),
                    ),
                  ), //Container
                  //Container
                ], //<Widget>[]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
