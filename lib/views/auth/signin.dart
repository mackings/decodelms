import 'dart:async';

import 'package:decodelms/apis/authclass.dart';
import 'package:decodelms/models/user.dart';
import 'package:decodelms/views/Homepage/home.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/authdialog.dart';
import 'package:decodelms/widgets/buttons.dart';
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
      return data;
    } else {
      print("failed");
      print(payload);
      throw Exception(response.body);
    }
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
                    children: [
                      Thetext(
                        thetext: "Login to your account",
                        style: GoogleFonts.poppins(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      Thetext(
                        thetext:
                            "Welcome back!login to your account to\nscontinue learning",
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
              controller: email,
              value: "Enter Email",
              prefix: Icon(Icons.email),
            ),
            SizedBox(
              height: 5.h,
            ),
            TheFormfield(
              controller: password,
              value: "Enter Password",
              prefix: Icon(Icons.lock),
              suffix: Icon(Icons.visibility),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(100.0, 0.0, 100.0, 5.0),
              child: Row(
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
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Text("Login Failed");
                                });
                          }
                        } catch (e) {
                          print(e);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Text("An error occurred during sign-in");
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
            Thetext(
              thetext: "Forgot password?",
              style: GoogleFonts.poppins(color: Colors.blue),
            )
          ],
        ));
  }
}
