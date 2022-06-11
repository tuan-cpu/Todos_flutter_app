import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/utils/inputValidate.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  bool emailValidate = false;
  bool passwordValidate = false;
  bool usernameValidate = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();

    super.dispose();
  }

  bool isLoginPage = false;

  submit() async {
    setState(() {
      emailValidate = false;
      passwordValidate = false;
      usernameValidate = false;
    });
    final auth = FirebaseAuth.instance;
    UserCredential userCredential;
    setState(() {
      emailValidate = InputValidate.validate(emailController.text);
      passwordValidate = InputValidate.validate(passwordController.text);
    });
    if (!isLoginPage) {
      setState(() {
        usernameValidate = InputValidate.validate(usernameController.text);
      });
    }
    try {
      if (isLoginPage) {
        userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        String uid = '';
        final user = userCredential.user;
        if (user != null) uid = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': usernameController.text.trim(),
          'email': emailController.text.trim()
        });
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            height: 200,
            margin: const EdgeInsets.all(30),
            child: Image.asset('lib/assets/checklist.png'),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLoginPage && usernameValidate)
                    const Text(
                      'Username must not empty',
                      style: TextStyle(fontSize: 10, color: Colors.red),
                    ),
                  if (!isLoginPage)
                    TextField(
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(),
                        ),
                        labelText: 'Enter username',
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (emailValidate)
                    const Text(
                      'Email must not be empty!',
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(),
                      ),
                      labelText: 'Enter email',
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (passwordValidate)
                    const Text(
                      'Password must not be empty!',
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    ),
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(),
                      ),
                      labelText: 'Enter password',
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 70,
                      width: double.infinity,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          submit();
                        },
                        child: isLoginPage
                            ? Text('Sign In',
                                style: GoogleFonts.roboto(fontSize: 16))
                            : Text(
                                'Sign Up',
                                style: GoogleFonts.roboto(fontSize: 16),
                              ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: isLoginPage
                          ? Text(
                              'Don\'t have account?',
                              style: GoogleFonts.roboto(fontSize: 16),
                            )
                          : Text('Already signed up?',
                              style: GoogleFonts.roboto(fontSize: 16)))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
