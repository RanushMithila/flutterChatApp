import 'package:flutter/material.dart';
import 'package:rmb/CustomUI/ContactCard.dart';
import 'package:rmb/Model/ChatModel.dart';
import 'package:rmb/Screens/CreateGroup.dart';
import '../CustomUI/ButtonCard.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  @override
  Widget build(BuildContext context) {
    List<ChatModel> contacts = [
      ChatModel(
        name: "Ranush Mithila",
        status: "This is my app",
        icon: "person.svg",
        isGroup: false,
        id: 1,
      ),
      ChatModel(
        name: "Anjana Dilshani",
        status: "Hey there! I am using RMB.",
        icon: "person.svg",
        isGroup: false,
        id: 2,
      ),
      ChatModel(
        name: "RMB_1",
        status: "Hey there! I am using RMB.",
        icon: "person.svg",
        isGroup: false,
        id: 3,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Contact",
              style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "1418 Contacts",
              style: TextStyle(fontSize: 13.0),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 26.0,
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Invite a friend"),
              ),
              PopupMenuItem(
                child: Text("Contacts"),
              ),
              PopupMenuItem(
                child: Text("Refresh"),
              ),
              PopupMenuItem(
                child: Text("Help"),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: contacts.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateGroup()));
                },
                child: ButtonCard(
                  icon: Icons.group,
                  name: "New group",
                ),
              );
            } else if (index == 1) {
              return ButtonCard(
                icon: Icons.person_add,
                name: "New contact",
              );
            }
            return ContactCard(
              contact: contacts[index - 2],
            );
          }),
    );
  }
}
