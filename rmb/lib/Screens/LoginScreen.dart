import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rmb/CustomUI/ButtonCard.dart';
import 'package:rmb/Screens/HomeScreen.dart';
import 'package:rmb/sqlite/KeyModel.dart';
import 'package:rmb/sqlite/UserDataModel.dart';

import '../Encrypt/EncryptString.dart';
import '../Model/ChatModel.dart';
import '../sqlite/Database.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //local database
  late DB db;
  List<UserDataModel> user = [];
  late final key;
  //getting keys

  @override
  void initState() {
    super.initState();
    db = DB();
    getUserLog();
    getKeyLog();
  }

  late ChatModel sourceChat;
  List<ChatModel> chatModel = [
    ChatModel(
      name: "Ranush Mithila",
      icon: "person.svg",
      isGroup: false,
      time: "15:00",
      currentMessage: "Test",
      id: 1,
    ),
    ChatModel(
      name: "Test Account1",
      icon: "person.svg",
      isGroup: false,
      time: "15:01",
      currentMessage: "Test",
      id: 2,
    ),
    ChatModel(
      name: "Test Account2",
      icon: "person.svg",
      isGroup: false,
      time: "15:01",
      currentMessage: "Test",
      id: 3,
    ),
    ChatModel(
      name: "Test Account3",
      icon: "person.svg",
      isGroup: false,
      time: "15:01",
      currentMessage: "Test",
      id: 4,
    ),
    // ChatModel(
    //     name: "RMB",
    //     icon: "groups.svg",
    //     isGroup: true,
    //     time: "15:00",
    //     currentMessage: "This is my First..."),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: chatModel.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            sourceChat = chatModel.removeAt(index);

            db.insertUser(
              UserDataModel(
                userid: sourceChat.id,
                username: sourceChat.name,
                icon: sourceChat.icon,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (Builder) => Homescreen(
                  chatModels: chatModel,
                  sourceChat: sourceChat,
                ),
              ),
            );
          },
          child: ButtonCard(
            name: chatModel[index].name,
            icon: Icons.person,
          ),
        ),
      ),
    );
  }

  void getUserLog() async {
    user = await db.getUser();
    // print(user[0].username);
    if (user.isNotEmpty) {
      sourceChat = chatModel.removeAt(user[0].userid - 1);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (Builder) => Homescreen(
            chatModels: chatModel,
            sourceChat: sourceChat,
          ),
        ),
      );
    }
  }

  void getKeyLog() async {
    key = await db.getKey();
    if (!key.isNotEmpty) {
      generateKeys().then((JsonWebKeyPair keys) {
        final myPublicKey = keys.publicKey;
        final myPrivateKey = keys.privateKey;
        db.insertKey(
          KeyModel(
            publicKey: myPublicKey,
            privateKey: myPrivateKey,
          ),
        );
      });
      print("Inserted your keys into the DB");
    }
  }
}
