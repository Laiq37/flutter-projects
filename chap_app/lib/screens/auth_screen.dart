import 'package:chap_app/widgets/Auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool _isloading = false;

  UserCredential? authResult;

  void _submitForm(String email, String? username, String password,
      File? userImage, bool islogin, BuildContext ctx) async {
    try {
      setState(() {
        _isloading = true;
      });
      if (islogin) {
        print('inlogin');
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //for storing file on firebase storage first we have create call it instance then call ref() method which return a new reference and if we dont passes path arg in ref then it
        //will return root reference
        //in .child method we passes folders or file name where it should save
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult!.user!.uid + '.jpg');
        await ref.putFile(userImage!);

        final String imagUrl = await ref.getDownloadURL();
        //if we scuccessfull in siging up then we will add user in users(if users collection not found then it will be created by firebase) collection and then we create a document with user id
        //assign by firebase in which we set  of useremail and username
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult!.user!
                .uid) //doc will add document but we can also create document with id, instead of doc if we use add then document id generate dynamically by firebase
            .set(
          {
            'username': username,
            'email': email,
            'image': imagUrl,
          },
        );
      }
    } on FirebaseAuthException catch (err) {
      print('in platformException');
      String message = 'An error occured, Credential are not correct';
      if (err.message != null) {
        message = err.message!;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isloading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitForm, _isloading),
    );
  }
}
