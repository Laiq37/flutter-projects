import 'package:chap_app/widgets/chat/messages.dart';
import 'package:chap_app/widgets/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Future<void> messageInstance() async {
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message?.notification != null) {
        print('new message Alert');
        print(message!.notification!.body);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Navigator.of(context).pushNamed(ChatScreen.routeName);
      print('new message Alert');
      print(message.notification!.body);
    });
  }

  void initState() {
    final FirebaseMessaging fCM = FirebaseMessaging.instance;
    fCM.subscribeToTopic('chat');
    messageInstance();
    // TODO: implement initState
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('A new onMessageOpenedApp event was published!');
  //   });
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    CollectionReference<Map<String, dynamic>> messages =
        FirebaseFirestore.instance.collection(
            //path of our desired collection
            'chats/hmfqmrNeCAmhb77BfYAw/messages');

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
            onChanged: (onchangeValue) {
              if (onchangeValue == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      //if we want to use .docs method then we have to tell streamBuilder about type of data stream builder should listen StreamBuilder<type>
      //https://stackoverflow.com/questions/66670247/the-property-docs-cannot-be-unconditionally-accessed-because-received-can-be
      // body: StreamBuilder<QuerySnapshot>(
      //     stream: messages
      //         .snapshots(), // as we know snapshots() method returns an stream obj
      //     //in stream builder in build we passes an anonymous func one is context and other is snapshot(it holds the latest snaphot/data)
      //     builder: (ctx, streamSnapShot) {
      //       if (streamSnapShot.connectionState == ConnectionState.waiting) {
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //       if (streamSnapShot.hasError) {
      //         return Text('Something went wrong!');
      //       }
      //       if (!streamSnapShot.hasData) {
      //         return Text('Say Hi!');
      //       }
      //       final documents = streamSnapShot.data!.docs;
      //       return ListView.builder(
      //           itemCount: documents.length,
      //           itemBuilder: (ctx, index) => Text(documents[index]['Text']));
      //     }),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
    // floatingActionButton: FloatingActionButton(
    //   onPressed: () {
    //     FirebaseFirestore.instance
    //         .collection(
    //             'chats/hmfqmrNeCAmhb77BfYAw/messages') //path of our desired collection
    //         .add({'Text': "After pressing button new data is streaming!"});
    //     //.add method take map of value which will be created at particular path which we have given to collection example('chats/hmfqmrNeCAmhb77BfYAw/messages')
    //     // .snapshots() //.snapshot returns the stream, means whenever data change the screen automatically listen the changes and stream them and to listen the changes we have to use
    //     //.listen method which takes anonymous funct and and has event/ data arg which holds data
    //     //   .listen((data) {
    //     // data.docs.forEach((doc) {
    //     //   print(doc['Text']);
    //     // });
    //     // });
    //   },
    //   child: Icon(Icons.add),
    // ));
  }
}
