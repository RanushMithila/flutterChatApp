import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmb/Model/ChatModel.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({super.key, required this.contact});
  final ChatModel contact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 23.0,
                child: SvgPicture.asset(
                  "Assets/person.svg",
                  color: Colors.white,
                  height: 30.0,
                  width: 30.0,
                ),
                backgroundColor: Colors.blueGrey[200],
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 11.0,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 13.0,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(contact.name, style: TextStyle(fontSize: 12.0)),
        ],
      ),
    );
  }
}
