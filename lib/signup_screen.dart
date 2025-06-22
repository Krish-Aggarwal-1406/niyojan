import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:niyojan/home_screen.dart';
import 'package:niyojan/widgets/toast_message.dart';
import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool isChecked = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void passname() {
    String firstname = firstNameController.text.trim();
    String lastname = lastNameController.text.trim();
    String fullname = "$firstname $lastname";
    if (firstname.isNotEmpty && lastname.isNotEmpty) {
      Get.to(() => HomePage(userName: fullname));
    } else {
      Get.snackbar("Error", "Please enter your first and last name");
    }
  }

  Future<UserCredential> loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser!.authentication;
    final googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await auth.signInWithCredential(googleAuthCredential);
  }

  void signup() {
    setState(() {
      loading = true;
    });

    auth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((value) {
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
    final primaryColor = Color(0xFF4169E1);
    final greyColor = Colors.grey.shade700;
    final blackColor = Colors.black;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: height * .04),
              Container(
                width: double.infinity,
                height: height * .22,
                child: Image.asset(
                  "assets/logo-removebg-preview.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(height: height * .02),
              Text(
                "Hey There",
                style: TextStyle(color: greyColor, fontSize: 18),
              ),
              SizedBox(height: height * .005),
              Text(
                "Create an Account",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * .02),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      validator: (value) {
                        if (value!.isEmpty) return "First Name is required";
                        if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value))
                          return "Only letters are allowed";
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(Icons.person_outline, color: primaryColor),
                        hintText: "First name",
                        hintStyle: TextStyle(color: greyColor),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: greyColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: height * .02),
                    TextFormField(
                      controller: lastNameController,
                      validator: (value) {
                        if (value!.isEmpty) return "Last Name is required";
                        if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value))
                          return "Only letters are allowed";
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(Icons.person_outline, color: primaryColor),
                        hintText: "Last name",
                        hintStyle: TextStyle(color: greyColor),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: greyColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: height * .02),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) return "Email is required";
                        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value))
                          return "Enter a valid email";
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: Text(
                          "Email or Mobile number",
                          style: TextStyle(color: greyColor),
                        ),
                        prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: greyColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: height * .02),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) return "Password is required";
                        if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value))
                          return "Password must be 8+ chars, 1 uppercase, 1 lowercase & 1 number";
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                        label: Text(
                          "Password",
                          style: TextStyle(color: greyColor),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: greyColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * .018),
              Row(
                children: [
                  Checkbox(
                    fillColor: MaterialStateProperty.all(isChecked ? primaryColor : Colors.white),
                    value: isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isChecked = newValue ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "By continuing you accept our Privacy Policy and Term of Use",
                      style: TextStyle(fontSize: 12, color: blackColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * .018),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    signup();
                    passname();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 3,
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
                child: Container(
                  height: height * .06,
                  width: width * .7,
                  alignment: Alignment.center,
                  child: loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: height * .018),
              Text(
                "-------------------------or-------------------------",
                style: TextStyle(fontSize: 20, color: greyColor),
              ),
              SizedBox(height: height * .02),
              GestureDetector(
                onTap: () async {
                  await loginWithGoogle();
                },
                child: Container(
                  height: height * .04,
                  width: width * .1,
                  decoration: BoxDecoration(
                    border: Border.all(width: .8, color: primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset("assets/img.png"),
                ),
              ),
              SizedBox(height: height * .002),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: greyColor, fontSize: 17),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(LoginPage());
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: height * .02),
            ],
          ),
        ),
      ),
    );
  }
}
