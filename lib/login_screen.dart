import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:niyojan/signup_screen.dart';
import 'package:niyojan/widgets/toast_message.dart';

import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<UserCredential> loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser!.authentication;
    final googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await auth.signInWithCredential(googleAuthCredential);
    String userName = userCredential.user?.displayName ?? "User";
    Get.off(() => HomePage(userName: userName));
    return userCredential;
  }

  void login() {
    setState(() {
      loading = true;
    });

    auth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((value) {
      Utils().toastMessage("Welcome, ${value.user?.email ?? ''}");
      String userName = value.user?.email ?? "User";
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userName: userName)),
      );
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: height * 0.4,
              child: Image.asset("assets/logo-removebg-preview.png", fit: BoxFit.fill),
            ),
            SizedBox(height: height * 0.02),
            Text(
              "Hey you are already set",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
            ),
            SizedBox(height: height * 0.005),
            Text(
              "Just Log in and go",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.03),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87, width: 1.2),
                          borderRadius: BorderRadius.circular(15),
                        ),

                        label: Hero(
                          tag: "emailTag",
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              "Email or Mobile number",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                        ),
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.025),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{8,}$')
                            .hasMatch(value)) {
                          return "Password must be 8+ chars, 1 uppercase, 1 lowercase & 1 number";
                        }
                        return null;
                      },
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87, width: 1.2),
                          borderRadius: BorderRadius.circular(15),
                        ),

                        prefixIcon: Icon(Icons.lock_outline, color: Colors.black54),
                        label: Hero(
                          tag: "passwordTag",
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              "Password",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.035),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4169E1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(width * 0.7, height * 0.06),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      child: loading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        "Log In",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      "-------------------------or-------------------------",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                    SizedBox(height: height * 0.02),
                    GestureDetector(
                      onTap: () async {
                        await loginWithGoogle();
                      },
                      child: Container(
                        height: height * 0.045,
                        width: width * 0.12,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.8, color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset("assets/img.png"),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 17),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => SignUpPage());
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
