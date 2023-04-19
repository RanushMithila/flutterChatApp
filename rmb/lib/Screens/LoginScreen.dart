import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rmb/CustomUI/ButtonCard.dart';
import 'package:rmb/Screens/HomeScreen.dart';
import 'package:rmb/sqlite/KeyModel.dart';
import 'package:rmb/sqlite/UserDataModel.dart';

import '../Model/ChatModel.dart';
import '../Model/RSAModel.dart';
import '../sqlite/Database.dart';

// this part remove because I found new algorithm for RSA
// ================================================================
// //public key private key
// import 'package:rsa_encrypt/rsa_encrypt.dart';
// import 'package:pointycastle/api.dart' as crypto;

// //Future to hold our KeyPair
// late Future<crypto.AsymmetricKeyPair> futureKeyPair;
// //to store the KeyPair once we get data from our future
// late crypto.AsymmetricKeyPair keyPair;

// Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
//     getKeyPair() {
//   var helper = RsaKeyHelper();
//   return helper.computeRSAKeyPair(helper.getSecureRandom());
// }
// ================================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //local database
  late DB db;
  List<UserDataModel> user = [];
  List<KeyModel> key = [];
  //getting keys
  final rsaPair = generateRSAkeyPair(getSecureRandom(), bitLength: 1024);

  @override
  void initState() {
    super.initState();
    db = DB();
    getUserLog();

    // this part remove because I found new algorithm for RSA
    // ================================================================
    // final keyPair = getKeyPair();
    // Future publicKey = keyPair.then((value) => value.publicKey);
    // final privateKey = keyPair.then((value) => value.privateKey);
    // ================================================================
    // final private = encodePrivateKeyToPemPKCS1(privateKey);
    // publicKey.then((value) => print(value));
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
                  rsaPair: rsaPair,
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
            rsaPair: rsaPair,
          ),
        ),
      );
    }
  }

  void getKeyLog() async {
    key = await db.getKey();
    if (key.isNotEmpty) {
      print(key[0].privateKey);
      print(key[0].publicKey);
    } else {
      //genarate new key and store
    }
  }
}
