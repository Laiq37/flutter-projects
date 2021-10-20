import 'package:chap_app/widgets/pickedImage/click_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitForm, this.isloading);

  final void Function(String email, String? username, String password,
      File? userImage, bool islogin, BuildContext ctx) submitForm;

  bool isloading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  File? _userImage;

  void getImage(File image) {
    _userImage = image;
  }

  final _formkey = GlobalKey<FormState>();

  bool _islogin = true;

  String? _userName;
  String? _userEmail;
  String? _password;

  void _trySubmit() {
    print('in Submit');
    final bool valid = _formkey.currentState!.validate();
    print(valid);

    // FocusScope.of(context).unfocus will closed the button after we press submit or login
    FocusScope.of(context).unfocus();

    if (_userImage == null && !_islogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Select an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (valid) {
      _formkey.currentState!.save();
      widget.submitForm(
          _userEmail!, _userName, _password!, _userImage, _islogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(
          20,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    if (!_islogin) ClickImage(getImage),
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        print(value);
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value!.trim();
                        print('in userEmail textfeild at onSaved method');
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email-address',
                      ),
                    ),
                    if (!_islogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value == null || value.length < 4) {
                            return 'User-name atleast have 4 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userName = value!.trim();
                          print('in username textfeild at onSaved method');
                        },
                        decoration: InputDecoration(
                          labelText: 'User-name',
                        ),
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value == null || value.length < 7) {
                          return 'password alteast have 7 character';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!.trim();
                        print('in password textfeild at onSaved method');
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isloading) CircularProgressIndicator(),
                    if (!widget.isloading)
                      RaisedButton(
                        onPressed: _trySubmit,
                        child: Text(_islogin ? 'Login' : 'Signup'),
                      ),
                    if (!widget.isloading)
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            _islogin = !_islogin;
                          });
                        },
                        child: Text(_islogin
                            ? 'Create a account ? Signup'
                            : 'I already have accound ? Login'),
                      )
                  ],
                  //this property will allowed to take as much as its child needed not the the full space it can get
                  mainAxisSize: MainAxisSize.min,
                )),
          ),
        ),
      ),
    );
  }
}
