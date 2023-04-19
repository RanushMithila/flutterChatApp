import 'dart:convert';
import 'dart:typed_data';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmb/CustomUI/OwnMessageCard.dart';
import 'package:rmb/CustomUI/ReplyCard.dart';
import 'package:rmb/Model/MessageModel.dart';
import 'package:rmb/sqlite/DataModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sqflite/sqflite.dart';

import '../Model/ChatModel.dart';
import '../Model/RSAModel.dart';
import '../sqlite/Database.dart';

class IndividualPage extends StatefulWidget {
  const IndividualPage({
    super.key,
    required this.chatModel,
    required this.sourceChat,
    required this.rsaPair,
  });
  final ChatModel chatModel;
  final ChatModel sourceChat;
  final rsaPair;

  void getKey() {
    final publicKey = rsaPair.publicKey;
    final privateKey = rsaPair.privateKey;
  }

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  //local database
  late DB db;
  List<DataModel> datas = [];
  // bool fetching = true;

  bool show = false;
  FocusNode focusNode = FocusNode();
  late IO.Socket socket;
  bool sendButton = false;
  List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //connect to the server
    connect();
    // getKey();
    //local db
    db = DB();
    getMessagesInd();
    //access all the messages from the local database database and display them one by one
//======================================================================================

    //test
//======================================================================================

    //it works perfectly
    // final rsaPair = generateRSAkeyPair(getSecureRandom(), bitLength: 1024);
    // final plaintext = 'Hello, world!';
    // final bytes = Uint8List.fromList(plaintext.codeUnits);
    // final encrypted = rsaEncrypt(rsaPair.publicKey, bytes);
    // final decrypted = rsaDecrypt(rsaPair.privateKey, encrypted);
    // print(encrypted);

    // print(utf8.decode(decrypted));
//======================================================================================
    // setState(() {
    //   fetching = false;
    // });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  void getMessagesInd() async {
    datas = await db.getMessages();
    var len = datas.length;
    for (var i = 0; i < len; i++) {
      print(datas[i].message);
    }
    datas.forEach((element) {
      if ((widget.sourceChat.id == element.sourseId &&
              widget.chatModel.id == element.targetId) ||
          (widget.sourceChat.id == element.targetId &&
              widget.chatModel.id == element.sourseId))
        setMessage(element.type, element.message);
    });
  }

  void connect() {
    socket = IO.io(
      'http://192.168.43.180:5000',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socket.connect();
    socket.onConnect((data) {
      print("Connected");
    });

    socket.onConnectError((data) {
      print("Error while establishing connection...");
    });

    socket.onDisconnect((data) => print('Disconnected....'));

    try {
      socket.on('message', (data) {
        setMessage("destination", data["message"]);
        //save to local db
        print("Trying to insert...");
        print(data["message"]);
        db.insertMessage(
          DataModel(
            type: "destination",
            message: data["message"],
            sourseId: data["sourseId"],
            targetId: data["targetId"],
          ),
        );

        if (_scrollController.positions.isNotEmpty) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (err) {
      print(err);
    }

    print(socket.connected);
    socket.emit("signin", widget.sourceChat.id);
  }

  void sendMessage(String message, int sourseId, int targetId) {
    setMessage("sourse", message);
    //save to local db
    print("Trying to insert...");
    print(message);

    db.insertMessage(
      DataModel(
        type: "sourse",
        sourseId: sourseId,
        targetId: targetId,
        message: message,
      ),
    );

    socket.emit(
      "message",
      {"message": message, "sourseId": sourseId, "targetId": targetId},
    );
  }

  void setMessage(String type, String message) {
    MessageModel messageModel = MessageModel(
        type: type,
        message: message,
        time: DateTime.now().toString().substring(10, 16));
    if (mounted) {
      setState(() {
        messages.add(messageModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "Assets/back.jpg",
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leadingWidth: 70.0,
            titleSpacing: 0.0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 24.0,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blueGrey,
                    child: SvgPicture.asset(
                      widget.chatModel.isGroup
                          ? "Assets/groups.svg"
                          : "Assets/person.svg",
                      // ignore: deprecated_member_use
                      color: Colors.white,
                      height: 37,
                      width: 37,
                    ),
                  ),
                ],
              ),
            ),
            title: InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chatModel.name,
                      style: TextStyle(
                          fontSize: 18.5, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Last seen today at 15:30",
                      style: TextStyle(fontSize: 13.0),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.videocam),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.call),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("View Contact"),
                  ),
                  PopupMenuItem(
                    child: Text("Media, links, and docs"),
                  ),
                  PopupMenuItem(
                    child: Text("Search"),
                  ),
                  PopupMenuItem(
                    child: Text("Mute notifications"),
                  ),
                  PopupMenuItem(
                    child: Text("Wallpaper"),
                  ),
                ],
              ),
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: messages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return Container(
                            height: 70.0,
                          );
                        }
                        if (messages[index].type == "sourse") {
                          return OwnMessageCard(
                            message: messages[index].message,
                            time: messages[index].time,
                          );
                        } else {
                          return ReplyCard(
                            message: messages[index].message,
                            time: messages[index].time,
                          );
                        }
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 70.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 60.0,
                                child: Card(
                                  margin: EdgeInsets.only(
                                      left: 2.0, right: 2.0, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: TextFormField(
                                    controller: _controller,
                                    focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          sendButton = true;
                                        });
                                      } else {
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: IconButton(
                                        onPressed: () {
                                          focusNode.unfocus();
                                          focusNode.canRequestFocus = false;
                                          setState(() {
                                            show = !show;
                                          });
                                        },
                                        icon: Icon(Icons.tag_faces),
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (builder) =>
                                                    bottomSheet(),
                                              );
                                            },
                                            icon: Icon(Icons.attach_file),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.camera_alt),
                                          ),
                                        ],
                                      ),
                                      hintText: "Type a message",
                                      contentPadding: EdgeInsets.all(5.0),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8.0,
                                  right: 5.0,
                                  left: 2.0,
                                ),
                                child: CircleAvatar(
                                  radius: 25.0,
                                  child: IconButton(
                                    icon: Icon(
                                      !sendButton ? Icons.mic : Icons.send,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (sendButton) {
                                        _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeOut,
                                        );
                                        sendMessage(
                                            _controller.text,
                                            widget.sourceChat.id,
                                            widget.chatModel.id);
                                        _controller.clear();
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // This is not completed compleate this after build all the screens
                          // show ? emojiSelect() : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278.0,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                    Icons.insert_drive_file,
                    Colors.blue,
                    "Document",
                  ),
                  SizedBox(
                    width: 40.0,
                  ),
                  iconCreation(
                    Icons.camera_alt,
                    Colors.pink,
                    "Camera",
                  ),
                  SizedBox(
                    width: 40.0,
                  ),
                  iconCreation(
                    Icons.insert_photo,
                    Colors.purple,
                    "Gallery",
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                    Icons.headset,
                    Colors.orange,
                    "Audio",
                  ),
                  SizedBox(
                    width: 40.0,
                  ),
                  iconCreation(
                    Icons.location_on,
                    Colors.green,
                    "Location",
                  ),
                  SizedBox(
                    width: 40.0,
                  ),
                  iconCreation(
                    Icons.person_add,
                    Colors.blue,
                    "Contact",
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(
    IconData icon,
    Color color,
    String text,
  ) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 30.0,
            child: Icon(
              icon,
              color: Colors.white,
              size: 29,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
  // This is not completed compleate this after build all the screens
  // Widget emojiSelect() {
  //   return EmojiPicker(
  //     onEmojiSelected: (emoji, Category) {
  //       print(emoji);
  //       setState(() {
  //         _controller.text = _controller.text + emoji.emoji;
  //       });
  //     },
  //   );
  // }
}
