import 'dart:async';

import 'package:decodelms/apis/authclass.dart';
import 'package:decodelms/models/user.dart';
import 'package:decodelms/views/Homepage/home.dart';
import 'package:decodelms/views/auth/reqpassrest.dart';
import 'package:decodelms/views/videocalls/joincall.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/authdialog.dart';
import 'package:decodelms/widgets/buttons.dart';
import 'package:decodelms/widgets/colors.dart';
import 'package:decodelms/widgets/course/dialogs.dart';
import 'package:decodelms/widgets/formfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Signin extends ConsumerStatefulWidget {
  const Signin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SigninState();
}

class _SigninState extends ConsumerState<Signin> {


  @override
  void initState() {
  _loadSavedCredentials();
    super.initState();
  }
  late final SharedPreferences prefs;

  Future<void> _loadSavedCredentials() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      //Retrieve saved credentials
      email.text = prefs.getString('email') ?? '';
      password.text = prefs.getString('password') ?? '';
      isuncheked = prefs.getBool('rememberMe') ?? false;
    });
  }

  // Save user credentials locally
  Future<void> _saveCredentials() async {
    await prefs.setString('email', email.text);
    await prefs.setString('password', password.text);
    await prefs.setBool('rememberMe', isuncheked);
  }

  // Remove saved credentials
  Future<void> _clearCredentials() async {
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('rememberMe');
  }

  bool ischecked = true;
  bool isuncheked = false;
  bool loading = false;

  final api = Api();
  dynamic err;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Login Userlogin() {
    return Login(email: email.text, password: password.text);
  }

  Future signin(Login login) async {
    dynamic payload =
        jsonEncode({"email": login.email, "password": login.password});
    final response = await http.post(
        Uri.parse("https://server-eight-beige.vercel.app/api/user/login"),
        body: payload,
        headers: {
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      String token = data['token'];

      // Save the user data to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString(
          'userData', jsonEncode(data['user'])); // Save user data

      print("Token: $token");
      print("Token and user data saved in shared preferences.");

      print("success");
      print(data);
      return data;
    } else {
      Map<String, dynamic> theres = jsonDecode(response.body);
      setState(() {
        err = theres['message'];
      });
      print("failed");
      print(payload);
      throw Exception(response.body);
    }
  }

  bool _isObscure = true;
  bool visi = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final thetheme = ref.watch(api.themeprovider.notifier);
    return LayoutBuilder(
  builder: (BuildContext context, BoxConstraints constraints) {
    return TheBars(
      callback: () {},
      thebody: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Thetext(
                      thetext: "Login to your account",
                      style: GoogleFonts.poppins(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    Thetext(
                      thetext:
                          "Welcome back! login to your account to\ncontinue learning",
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.06,
          ),
          TheFormfield(
            vis: false,
            controller: email,
            value: "Enter Email",
            prefix: Icon(Icons.email, color: hintcolor),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          TheFormfield(
            vis: visi,
            controller: password,
            value: "Enter Password",
            prefix: GestureDetector(
                onTap: () {
                  // _togglePasswordVisibility;
                },
                child: Icon(Icons.lock, color: hintcolor)),
            suffix: GestureDetector(
              onTap: () {
                setState(() {
                  visi = !visi;
                });
              },
              child: visi
                  ? Icon(Icons.visibility, color: hintcolor)
                  : Icon(Icons.visibility_off, color: hintcolor),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          Row(
            children: [
              Checkbox(
                focusColor: Colors.black,
                value: isuncheked,
                onChanged: (value) {
                  setState(() {
                    isuncheked = value ?? false;
                    if (isuncheked) {
                      _saveCredentials(); // Save credentials if "Remember Me" is checked
                    } else {
                      _clearCredentials(); // Clear credentials if unchecked
                    }
                  });
                },
              ),
              Thetext(
                thetext: "Remember Me",
                style: GoogleFonts.poppins(),
              )
            ],
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: loading
                ? CircularProgressIndicator()
                : Mybuttons(
                    callback: () async {
                      setState(() {
                        loading = true;
                      });

                      try {
                        dynamic response = await signin(Userlogin());

                        if (response != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Homepage()));
                        } else {
                          setState(() {
                            loading = false;
                          });
                        }
                      } catch (e) {
                        print(e);
                        setState(() {
                          loading = false;
                        });
                        showDialog(
                            context: context,
                            builder: (context) {
                              return EnrollmentDialog(
                                  title: "Error Logging in",
                                  message: "$err",
                                  message2: 'Close',
                                  press1: () {
                                    Navigator.pop(context);
                                  },
                                  press2: () {
                                    Navigator.pop(context);
                                  },
                                  theicon: Icon(
                                    Icons.error,
                                    size: 60,
                                    color: Colors.red,
                                  ));
                            });
                      }
                    },
                    buttontxt: "Login",
                    btncolor: Colors.blue,
                  ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Requestreset()));
            },
            child: Thetext(
              thetext: "Forgot password?",
              style: GoogleFonts.poppins(color: Colors.blue),
            ),
          )
        ],
      ),
    );
  },
);
 
  }
}
