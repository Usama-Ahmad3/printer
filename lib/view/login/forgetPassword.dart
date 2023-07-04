import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printer/view/login/signIn.dart';
import 'package:printer/view/utils/flushbar.dart';
import 'package:printer/view/widgets/button.dart';
import 'package:printer/view/widgets/textFormField.dart';

import 'signup.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.keyboard_arrow_left),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Forget Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .08,
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Enter Your Email',
                  style: TextStyle(fontSize: 40),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .2,
              ),
              TextFieldWidget(
                  controller: emailController,
                  hint: 'Email',
                  icon: Icons.email),
              SizedBox(
                height: MediaQuery.of(context).size.height * .06,
              ),
              ButtonWidget(
                title: 'Send',
                onTap: () async {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: emailController.text)
                      .then((value) async {
                    await Utils.flushBar(
                        'Password Reset Email Send Please Check Your Email',
                        context,
                        'Information');
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignIn(),
                        ));
                  }).onError((error, stackTrace) async {
                    await Utils.flushBar(error.toString(), context, 'Error');
                  });
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .06,
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
                        Navigator.pushReplacement(
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
        ),
      ),
    );
  }
}
