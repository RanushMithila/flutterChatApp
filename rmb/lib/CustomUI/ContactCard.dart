import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmb/Model/ChatModel.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.contact});
  final ChatModel contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 53.0,
        width: 50.0,
        child: Stack(
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
            contact.select
                ? Positioned(
                    bottom: 4.0,
                    right: 5.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 11.0,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18.0,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
      title: Text(
        contact.name,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        contact.status,
        style: TextStyle(
          fontSize: 13.0,
        ),
      ),
    );
  }
}
