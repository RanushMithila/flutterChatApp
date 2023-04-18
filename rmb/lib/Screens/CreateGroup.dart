import 'package:flutter/material.dart';
import 'package:rmb/CustomUI/AvatarCard.dart';
import 'package:rmb/CustomUI/ContactCard.dart';
import 'package:rmb/Model/ChatModel.dart';
import '../CustomUI/ButtonCard.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
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

  List<ChatModel> groups = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New group",
              style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "Add participents",
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
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: contacts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    height: groups.length > 0 ? 90.0 : 10.0,
                  );
                }
                return InkWell(
                  onTap: () {
                    if (contacts[index - 1].select == false) {
                      setState(() {
                        contacts[index - 1].select = true;
                        groups.add(contacts[index - 1]);
                      });
                    } else {
                      setState(() {
                        contacts[index - 1].select = false;
                        groups.remove(contacts[index - 1]);
                      });
                    }
                  },
                  child: ContactCard(
                    contact: contacts[index - 1],
                  ),
                );
              }),
          groups.length > 0
              ? Column(
                  children: [
                    Container(
                      height: 75.0,
                      color: Colors.white,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            if (contacts[index].select == true) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    contacts[index].select = false;
                                    groups.remove(contacts[index]);
                                  });
                                },
                                child: AvatarCard(
                                  contact: contacts[index],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ),
                    Divider(
                      height: 1.0,
                      color: Colors.grey,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
