import 'package:flutter/material.dart';
import 'package:rmb/Screens/LoginPage.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              Text(
                "Welcome to RMB",
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 29.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 9,
              ),
              Image.asset(
                "Assets/bg.png",
                color: Colors.blueAccent,
                height: 340.0,
                width: 340.0,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                    ),
                    children: [
                      TextSpan(
                        text: "Agree and continue to accept the",
                      ),
                      TextSpan(
                          text: " RMB Terms of service and Privacy Policy",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (Builder) => LoginPage()),
                      (route) => false);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 110,
                  height: 50.0,
                  child: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 8.0,
                    color: Colors.blueAccent[700],
                    child: Center(
                      child: Text(
                        "AGREE AND CONTINUE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
