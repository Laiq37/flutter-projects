import 'package:flutter/material.dart';
import 'package:todo_app/api/user_api.dart';
import 'package:todo_app/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.emailController.dispose();
    widget.passwordController.dispose();
    widget.displayNameController.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  onSubmit(String name, String email, String password) async {
    print("$name $email $password");
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
    });
    bool isUserCreated = await UserApi().createUser(name, email, password);
    print(isUserCreated);
    if (isUserCreated) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: widget.displayNameController,
                    decoration: const InputDecoration(
                      label: Text('name'),
                    ),
                    validator: (val) {
                      if (val == null) {
                        return "Name is required";
                      } else if (val.length < 4) {
                        return "Name atleast of 4 characters";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: widget.emailController,
                    decoration: const InputDecoration(
                      label: Text('email'),
                    ),
                    validator: (val) {
                      if (val == null) {
                        return "Email is required";
                      } else if (!val.endsWith(".com") || !val.contains("@")) {
                        return "Invalid Email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: widget.passwordController,
                    decoration: const InputDecoration(
                      label: Text('password'),
                    ),
                    validator: (val) {
                      if (val == null) {
                        return "Password is required";
                      } else if (val.length < 6) {
                        return "Password must be atleast of 6 characters";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => onSubmit(widget.displayNameController.text,
                  widget.emailController.text, widget.passwordController.text),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Signup'),
            ),
            TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen())),
                child: const Text("Already have an account?login"))
          ],
        ),
      ),
    );
  }
}
