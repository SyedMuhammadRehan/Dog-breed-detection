import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../resources/assets.dart';
import '../../resources/colormanager.dart';
import '../../resources/fontsmanager.dart';
import '../../resources/sizeconfig.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ImageNotifier extends ChangeNotifier {
  bool isWorking = false;
  File? imageFile;
  String result = '';
  String? liveresult;
  bool imgfile = false;
  var imagpicker = ImagePicker();
  var output;
  loaddatamodel() async {
    Tflite.close();
    var tf = await Tflite.loadModel(
      model: "assets/tflite_model/bread.tflite",
      labels: "assets/tflite_model/label.txt",
      numThreads: 1,
    );
    print("success $tf ");
  }

  Future getimagefromscreen(context, controller) async {
    var img = await controller!.takePicture();

    imageFile = File(img!.path);

    classifyImage(imageFile!, context);
    notifyListeners();
  }

  Future getimagefromgallery(context) async {
    var img = await imagpicker.pickImage(source: ImageSource.gallery);

    imageFile = File(img!.path);

    classifyImage(imageFile!, context);
    notifyListeners();
  }

  runModelonFrame(CameraImage? imgcamera) async {
    if (imgcamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: imgcamera.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: imgcamera.height,
          imageWidth: imgcamera.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.2,
          asynch: true);
      liveresult = '';

      print("live");
      print('recog  ${recognitions!.length}');
      for (var response in recognitions) {
        liveresult = "${liveresult! + response["label"]}\n";
      }
      isWorking = false;
    }
    notifyListeners();
  }

  Future<List?> classifyImage(File image, BuildContext context) async {
    output = await Tflite.runModelOnImage(
      path: image.path, // required
      imageMean: 0.0,
      imageStd: 300.0,
      numResults: 1,
      threshold: 0.2,
      asynch: true,
    );
    result = '';
    if (output.isEmpty) {
      result = 'No breed found';
      showbottomsheet(context);
      // Show a message that the image could not be classified
      return null;
    } else {
      result = output[0]['label'];
      await showbottomsheet(context);
      notifyListeners();
      return output;
    }
  }

  Future showbottomsheet(context) async {
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
