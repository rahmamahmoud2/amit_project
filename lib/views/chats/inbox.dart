import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_application/views/chats/chat_screen.dart';

class InboxScreen extends StatelessWidget {
  final String currentUid = FirebaseAuth.instance.currentUser!.uid;

  String getChatPartnerId(String chatId) {
    final uids = chatId.split('_');
    return uids[0] == currentUid ? uids[1] : uids[0];
  }

  @override
  Widget build(BuildContext context) {
    final chatRef = FirebaseDatabase.instance.ref().child('chats');

    return Scaffold(
      appBar: AppBar(title: Text('Inbox')),
      body: StreamBuilder(
        stream: chatRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return Center(child: Text('No Chats'));
          }

          final data = (snapshot.data!.snapshot.value as Map);
          final userChats =
              data.entries.where((e) => e.key.contains(currentUid)).toList();

          return ListView.builder(
            itemCount: userChats.length,
            itemBuilder: (context, index) {
              final chatId = userChats[index].key;
              final chat = userChats[index].value;
              final lastMsg = chat['lastMessage'];
              final otherUserId = getChatPartnerId(chatId);

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnap) {
                  if (!userSnap.hasData)
                    return ListTile(title: Text('Loading...'));
                  final user = userSnap.data!;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['imageUrl']),
                    ),
                    title: Text(user['username']),
                    subtitle: Text(lastMsg['text'] ?? ''),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            otherUserId: otherUserId,
                            otherUserName: user['username'],
                            otherUserImage: user['imageUrl'],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
