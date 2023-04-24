import 'package:flutter/material.dart';
import 'package:rmb/Screens/CountryPage.dart';

import '../Model/CountryModel.dart';
import 'OtpScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String countryName = "Sri Lanka";
  String countryCode = "+94";

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Enter your phone number",
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
            wordSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.more_vert, color: Colors.black),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              "RMB will send an sms message to verify your phone number.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.5,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "What's my phone number?",
              style: TextStyle(
                color: Colors.cyan[800],
                fontSize: 12.8,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            countryCard(),
            SizedBox(
              height: 15.0,
            ),
            number(),
            Expanded(child: Container()),
            InkWell(
              onTap: () {
                if (_controller.text.length < 9) {
                  showCountryDialog1();
                } else {
                  showCountryDialog();
                }
              },
              child: Container(
                height: 40.0,
                width: 70.0,
                color: Colors.blueAccent[400],
                child: Center(
                  child: Text(
                    "NEXT",
                    style: TextStyle(
                      // color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      // fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget countryCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => CountryPage(
                    setCountryData: setCountryData,
                  )),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.teal, width: 1.8),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Center(
                  child: Text(
                    countryName,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.teal,
              size: 28.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget number() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 38.0,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 70.0,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.teal,
                  width: 1.8,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "+",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  countryCode.substring(1),
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.5 - 100.0,
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Phone Number",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8.0),
              ),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.teal,
                  width: 1.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setCountryData(CountryModel countryModel) {
    setState(() {
      countryName = countryModel.name;
      countryCode = countryModel.code;
    });
    Navigator.pop(context);
  }

  Future<void> showCountryDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text("Select Country"),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "We will be verifying your phone number.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    countryCode + " " + _controller.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Is this Ok, or would you like to edit the number?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Edit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => OtpScreen(
                              number: _controller.text,
                              countryCode: countryCode,
                            )));
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showCountryDialog1() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text("Select Country"),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Please enter your phone number.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}
