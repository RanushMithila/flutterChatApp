import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rmb/Screens/CameraScreen.dart';
import 'package:rmb/Screens/LandingScreen.dart';
import 'package:rmb/Screens/LoginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'RMB',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(122, 168, 116, 1),
        accentColor: Color.fromRGBO(247, 219, 106, 1),
        // fontFamily: 'OpenSans',
        // brightness: Brightness.dark,
        // primaryColor: Colors.green[900],
      ),
      home: LoginScreen(),
    );
  }
}
