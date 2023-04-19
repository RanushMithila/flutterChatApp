import 'package:flutter/material.dart';
import 'package:rmb/CustomUI/CustomCard.dart';
import 'package:rmb/Model/ChatModel.dart';

import '../Screens/SelectContact.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.chatModels,
    required this.sourceChat,
    this.rsaPair,
  });
  final List<ChatModel> chatModels;
  final ChatModel sourceChat;
  final rsaPair;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectContact(),
            ),
          );
        },
        child: Icon(Icons.chat),
      ),
      body: ListView.builder(
        itemCount: widget.chatModels.length,
        itemBuilder: (context, index) => CustomCard(
          chatModel: widget.chatModels[index],
          sourceChat: widget.sourceChat,
          rsaPair: widget.rsaPair,
        ),
      ),
    );
  }
}
