import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printer/res/sessionManager.dart';
import 'package:printer/view/utils/flushbar.dart';
import 'package:printer/view/widgets/button.dart';
import 'package:printer/view/widgets/textFormField.dart';

import 'signIn.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .06,
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Create Your Account',
                style: TextStyle(fontSize: 40),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            TextFieldWidget(
                controller: nameController,
                hint: 'Name',
                icon: Icons.person_2_outlined),
            TextFieldWidget(
                controller: emailController, hint: 'Email', icon: Icons.email),
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
                    color: passwordController.text != null
                        ? Colors.black
                        : Colors.grey,
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
                onChanged: (value) => setState(() {}),
              ),
            ),
            ButtonWidget(
              title: 'Sign Up',
              onTap: () async {
                {
                  try {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                        .then((value) async {
                      SessionController().userId = value.user!.uid.toString();
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(SessionController().userId.toString())
                          .set({
                        'name': nameController.text,
                        'email': emailController.text,
                        'password': passwordController.text,
                        'userId': SessionController().userId.toString()
                      }).then((value) async {
                        await FirebaseFirestore.instance
                            .collection('files')
                            .doc(SessionController().userId)
                            .set({
                          'name': [],
                          'nameId': [],
                          'url': [],
                          'fileId': [],
                          'userId': SessionController().userId.toString()
                        });
                        // ignore: use_build_context_synchronously
                        await Utils.flushBar(
                            'SignUp Successful', context, 'Information');
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignIn(),
                            ));
                      }).onError((error, stackTrace) async {
                        await Utils.flushBar(
                            error.toString(), context, 'Error');
                      });
                    });
                  } catch (e) {
                    await Utils.flushBar(e.toString(), context, 'Error');
                  }
                }
              },
            ),
            const SizedBox(
              height: 17,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
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
                              builder: (context) => const SignIn()));
                    },
                    child: const Text(
                      "Sign In",
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
    );
  }
}
