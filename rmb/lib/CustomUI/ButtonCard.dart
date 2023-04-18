import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmb/Model/ChatModel.dart';

class ButtonCard extends StatelessWidget {
  const ButtonCard({super.key, this.name = "", this.icon = Icons.chat});
  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23.0,
        child: Icon(
          icon,
          color: Colors.white,
          size: 30.0,
        ),
        backgroundColor: Color.fromARGB(255, 37, 121, 211),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
