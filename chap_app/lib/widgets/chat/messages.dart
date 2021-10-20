import 'package:chap_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  final CollectionReference<Map<String, dynamic>> chatData =
      FirebaseFirestore.instance.collection('chat');

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<QuerySnapshot>(
      //to order our data before snapshot we can call orderBy method , in which we will give the key name according to which we have to order
      stream: chatData.orderBy('CreatedAt', descending: true).snapshots(),
      builder: (ctx, chatSnapShot) {
        if (chatSnapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapShot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index]['Text'],
            chatDocs[index]['UserId'] == user.uid,
            chatDocs[index]['UserName'],
            chatDocs[index]['UserImage'],
            key: ValueKey(chatDocs[index].id),
          ),
          itemCount: chatDocs.length,
        );
      },
    );
  }
}
