import 'dart:async';

import 'package:decodelms/apis/authclass.dart';
import 'package:decodelms/models/user.dart';
import 'package:decodelms/views/Homepage/home.dart';
import 'package:decodelms/views/auth/reqpassrest.dart';
import 'package:decodelms/views/videocalls/joincall.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/authdialog.dart';
import 'package:decodelms/widgets/buttons.dart';
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
        Uri.parse("https://decode-mnjh.onrender.com/api/user/login"),
        body: payload,
        headers: {
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      String token = data['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      print("Token: $token");
      print("Token saved in shared preferences.");

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
              height: 6.h,
            ),
            TheFormfield(
              vis: false,
              controller: email,
              value: "Enter Email",
              prefix: Icon(Icons.email),
            ),
            SizedBox(
              height: 5.h,
            ),
            TheFormfield(
              vis: visi,
              controller: password,
              value: "Enter Password",
              prefix: GestureDetector(
                onTap: () {
                 // _togglePasswordVisibility;
                },
                child: Icon(Icons.lock)),
              suffix: GestureDetector(
      onTap: () {
        setState(() {
          visi = !visi;
        });
      },
      child: visi ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
    ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                Checkbox(
                    value: isuncheked,
                    onChanged: (value) {
                      ref.read(api.themeprovider.notifier).state = 1;

                      setState(() {
                        isuncheked = value!;

                        print(value);
                        print(thetheme.state);
                      });
                    }),
                Thetext(
                  thetext: "Remember Me",
                  style: GoogleFonts.poppins(),
                )
              ],
            ),
            SizedBox(
              height: 2.h,
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
                            Navigator.push(
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
              height: 2.h,
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
        ));
  }
}
