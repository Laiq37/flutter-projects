import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';

class InLineLink extends StatelessWidget {
  const InLineLink({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RichText(
                  text:TextSpan(
                      children: extractText('dummyText with https://www.google.com/ in line text link'),
                      style: const TextStyle(fontSize: 10)),
                ),
      ),
    );
  }
  List<TextSpan> extractText(String rawString) {
List<TextSpan> textSpan = [];

final urlRegExp =  RegExp(
    r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

getLink(String linkString) {
  textSpan.add(
    TextSpan(
      text: linkString,
      style: const TextStyle(color: Colors.blue),
      recognizer: TapGestureRecognizer()..onTap = () async {
          if(!await launch(linkString)) throw 'Could not launch $linkString';
        },
    ),
  );
  return linkString;
}

getNormalText(String normalText) {
  textSpan.add(
    TextSpan(
      text: normalText,
      style: const TextStyle(color: Colors.black),
    ),
  );
  return normalText;
}

rawString.splitMapJoin(
  urlRegExp,
  onMatch: (m) => getLink("${m.group(0)}"),
  onNonMatch: (n) => getNormalText(n.substring(0)),
);

return textSpan;}
}

