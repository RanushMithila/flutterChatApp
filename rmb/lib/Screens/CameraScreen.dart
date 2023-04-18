import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rmb/Screens/CameraView.dart';

List<CameraDescription> cameras = [];

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> cameraValue;
  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            FutureBuilder(
                future: cameraValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final previewSize = _cameraController.value.previewSize!;
                    final screenAspectRatio =
                        MediaQuery.of(context).size.aspectRatio;
                    final previewAspectRatio =
                        previewSize.height / previewSize.width;
                    //this part provide Chat-GPT-3
                    // because when I code it wouldn't fill the screen
                    return Transform.scale(
                      scale: previewAspectRatio / screenAspectRatio,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: previewAspectRatio,
                          child: CameraPreview(_cameraController),
                        ),
                      ),
                    );
                    // return CameraPreview(_cameraController);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            Positioned(
              bottom: 0.0,
              child: Container(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                color: Colors.black,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.flash_off,
                            color: Colors.white,
                            size: 28.0,
                          ),
                        ),
                        GestureDetector(
                          //https://www.youtube.com/watch?v=rsWoqD0eICs&list=PLtIU0BH0pkKovuEaNsrGE_Xd5Tz3m1zeC&index=18
                          //watch the video and implement the code
                          onLongPress: () {},
                          onLongPressUp: () {},
                          onTap: () {
                            takePhoto(context);
                          },
                          child: Icon(
                            Icons.panorama_fish_eye,
                            color: Colors.white,
                            size: 70.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                            size: 28.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      "Hold for video, tap for photo",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void takePhoto(BuildContext context) async {
    // final path =
    //     join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
    // await _cameraController.takePicture(path);

    final XFile? picture = await _cameraController.takePicture();
    final bytes = await picture!.readAsBytes();
    final directory = await getTemporaryDirectory();
    final fileName = '${DateTime.now()}.png';
    final path = join(directory.path, fileName);
    await File(path).writeAsBytes(bytes);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (Builder) => CameraViewPage(
          path: path,
        ),
      ),
    );
  }
}
