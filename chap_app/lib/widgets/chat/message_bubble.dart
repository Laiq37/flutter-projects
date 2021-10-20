import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key? key;
  final String username;
  final String userImage;

  MessageBubble(this.message, this.isMe, this.username, this.userImage,
      {this.key});

  @override
  Widget build(BuildContext context) {
    // print(key);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(right: isMe ? 3 : 0, left: !isMe ? 3 : 0),
          child: Row(
            textDirection: !isMe ? TextDirection.rtl : null,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                // width: MediaQuery.of(context).size.width * 0.46,
                decoration: BoxDecoration(
                  color:
                      isMe ? Colors.green[300] : Theme.of(context).accentColor,
                  borderRadius: isMe
                      ? BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMe ? 'Me' : username,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isMe
                              ? Theme.of(context).accentColor
                              : Colors.grey),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                          fontSize: 15,
                          color: isMe
                              ? Colors.black
                              : Theme.of(context)
                                  .accentTextTheme
                                  .headline1!
                                  .color),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              ),
              CircleAvatar(radius: 12, backgroundImage: NetworkImage(userImage))
            ],
          ),
        ),
      ],
    );
  }
}
