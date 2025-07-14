import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;
  final String otherUserImage;

  const ChatScreen({
    Key? key,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserImage,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final messageController = TextEditingController();
  late String chatId;

  @override
  void initState() {
    super.initState();
    chatId = _getChatId(currentUserId, widget.otherUserId);
    print("Chat ID: $chatId");
  }

  String _getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode
        ? '$user1\_$user2'
        : '$user2\_$user1';
  }

  void sendTextMessage() {
    if (messageController.text.trim().isEmpty) return;

    final ref = FirebaseDatabase.instance
        .ref()
        .child('chats')
        .child(chatId)
        .child('messages')
        .push();

    final message = {
      'senderId': currentUserId,
      'text': messageController.text.trim(),
      'timestamp': ServerValue.timestamp,
    };

    ref.set(message);

    FirebaseDatabase.instance
        .ref()
        .child('chats')
        .child(chatId)
        .child('lastMessage')
        .set(message);

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messagesRef = FirebaseDatabase.instance
        .ref()
        .child('chats')
        .child(chatId)
        .child('messages');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.otherUserImage),
            ),
            const SizedBox(width: 8),
            Text(widget.otherUserName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: messagesRef.orderByChild('timestamp').onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData ||
                    snapshot.data?.snapshot.value == null) {
                  return const Center(child: Text('ابدأ المحادثة ✉️'));
                }

                final messagesMap =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                final messages = messagesMap.entries.toList()
                  ..sort((a, b) =>
                      a.value['timestamp'].compareTo(b.value['timestamp']));

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].value;
                    final isMe = message['senderId'] == currentUserId;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                            bottomLeft: Radius.circular(isMe ? 18 : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 18),
                          ),
                        ),
                        child: Text(
                          message['text'] ?? '',
                          style: TextStyle(
                            color: isMe
                                ? Colors.white
                                : Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...', // النص بالإنجليزي
                      hintStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendTextMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
