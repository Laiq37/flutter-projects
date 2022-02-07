import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/signup_screen.dart';
import '../api/user_api.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.emailController.dispose();
    widget.passwordController.dispose();
  }

  bool isLoading = false;

  onSubmit(String email, String password) async {
    print("$email $password");
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
    });
    bool isUserCreated = await UserApi().loginUser(email, password);
    print(isUserCreated);
    if (isUserCreated) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                children: [
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
              onPressed: () => onSubmit(
                  widget.emailController.text, widget.passwordController.text),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
            TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen())),
                child: const Text("Create Account"))
          ],
        ),
      ),
    );
  }
}
