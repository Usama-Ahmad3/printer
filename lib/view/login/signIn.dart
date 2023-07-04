import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printer/res/sessionManager.dart';
import 'package:printer/view/homeScreens/mainTab.dart';
import 'package:printer/view/utils/flushbar.dart';
import 'package:printer/view/widgets/button.dart';
import 'package:printer/view/widgets/textFormField.dart';

import 'forgetPassword.dart';
import 'signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? password;
  bool hidePassword = true;
  bool? isChecked = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Login to Your Account',
                  style: TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFieldWidget(
                  controller: emailController,
                  hint: 'Email',
                  icon: Icons.email),
              const SizedBox(
                height: 7,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: passwordController,
                  cursorColor: Colors.black,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: hidePassword == true
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.black,
                            )
                          : const Icon(Icons.visibility, color: Colors.black),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: password != null ? Colors.black : Colors.grey,
                      size: 16,
                    ),
                    hintText: "Password",
                    hintStyle: const TextStyle(fontSize: 12),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.cyanAccent),
                    ),
                    //fillColor: Colors.green
                  ),
                  onChanged: (value) => setState(() => password = value),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    value: isChecked,
                    activeColor: Colors.cyanAccent,
                    onChanged: (newBool) {
                      setState(() {
                        isChecked = newBool;
                      });
                    },
                  ),
                  const Text(
                    'Remember me',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              ButtonWidget(
                onTap: () async {
                  try {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                        .then((value) async {
                      SessionController().userId = value.user!.uid.toString();
                      await Utils.flushBar(
                          'Sign In Complete', context, 'Information');
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyTabBar(),
                          ));
                    }).onError((error, stackTrace) async {
                      await Utils.flushBar(error.toString(), context, 'Error');
                    });
                  } catch (error) {
                    await Utils.flushBar(error.toString(), context, 'Error');
                  }
                },
                title: 'Sign In',
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgetPassword()));
                  },
                  child: const Text(
                    'Forget Password?',
                    style: TextStyle(color: Colors.pink),
                  )),
              const SizedBox(
                height: 17,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                ],
              )
            ],
          ),
        ));
  }
}
