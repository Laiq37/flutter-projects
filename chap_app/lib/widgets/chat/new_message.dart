import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    await FirebaseFirestore.instance.collection('chat').add(
      {
        'Text': _enteredMessage,

        //we are creating this createdAt field which hold current TimeStamp in which time of message is created store and by using this key we can show our message in desired way
        //to arrange in our desired way we have to go on stream builder(instance of chat collection)
        'CreatedAt': Timestamp.now(),

        //creating a userd id key to track of which user message it this
        'UserId': userId,

        'UserName': userData['username'],

        'UserImage': userData['image']
      },
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(
              Icons.send,
            ),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
