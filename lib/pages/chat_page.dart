import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:squeaky_app/components/my_chat_bubble.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String recieverUserEmail;
  final String receiverFirstName;
  final AppUser user;

  const ChatPage(
      {super.key,
      required this.receiverFirstName,
      required this.recieverUserEmail,
      required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(0.0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      }
    });
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final String message = _messageController.text;
      await _chatService.sendMessage(
          widget.recieverUserEmail, message, widget.user);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyGnavBar(currentPageIndex: 1, user: widget.user),
      appBar: AppBar(
        title: Text(widget.receiverFirstName),
        backgroundColor: Colors.grey[100],
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 5,
      ),
      body: Column(
          //messages
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _chatService.getMessages(
                    widget.user.email, widget.recieverUserEmail),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  }

                  return ListView(
                     reverse: true,
                      
                      children: snapshot.data!.docs
                          .map((document) => _buildMessageItem(document))
                          .toList().reversed.toList());
                },
              ),
            ),
            //user input
            Padding(
                padding: const EdgeInsets.all(8), child: _buildMessageInput())
          ]),
    );
  }

  //build the message items
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align messages to the right and left
    var alignment = data['senderEmail'] == widget.user.email
        ? Alignment.centerRight
        : Alignment.centerLeft;

    //set different colors for different alignments
    Color bubbleColor = alignment == Alignment.centerRight
        ? const Color.fromARGB(255, 33, 177, 243)
        : const Color.fromARGB(255, 62, 62, 62);

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          ChatBubble(
            message: data['message'],
            color: bubbleColor,
          ),
        ],
      ),
    );
  }

  //build the input field for messages
  Widget _buildMessageInput() {
    return Row(children: [
      Expanded(
        child: TextField(
          textAlign: TextAlign.left,
          onTapOutside: (PointerDownEvent event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          controller: _messageController,
          decoration: const InputDecoration(
              hintText: 'Type a message',
              contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)))),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.send),
        onPressed: sendMessage,
      ),
    ]);
  }
}
