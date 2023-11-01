import 'dart:async';

import 'package:decodelms/apis/authclass.dart';
import 'package:decodelms/models/user.dart';
import 'package:decodelms/views/Homepage/home.dart';
import 'package:decodelms/views/auth/signin.dart';
import 'package:decodelms/views/course/enrolledcourses.dart';
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

class Requestreset extends StatefulWidget {
  const Requestreset({super.key});

  @override
  State<Requestreset> createState() => _RequestresetState();
}

class _RequestresetState extends State<Requestreset> {
  dynamic Token;
  dynamic res;
  bool loading = false;
  bool loading2 = false;
  dynamic action;

  Future GetToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      setState(() {
        Token = token;
      });
      print("Token retrieved from shared preferences: $Token");
    } else {
      print("Token not found in shared preferences.");
    }
  }

  TextEditingController Thetoken = TextEditingController();
  TextEditingController Thepassword = TextEditingController();

  Future Update() async {
    String errorMessage = '';
    dynamic payload =
        jsonEncode({"token": Thetoken.text, "passord": Thepassword.text});
    try {
      final response = await http.post(
          Uri.parse("https://decode-mnjh.onrender.com/api/user/resetpassword"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $Token',
          },
          body: payload);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          loading2 = false;
          res = data['message'];
          action = "blue";
          print('res is $res');
        });

        // Show a success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EnrollmentDialog(
              press1: () {
                Navigator.pop(context);
              },
              press2: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Signin()));
              },
              theicon: Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 60,
              ),
              title: "Reset Succcessful",
              message: "Your Password has been Updated",
              message2: 'Login',
            );
          },
        );
      } else if (response.statusCode == 400) {
        var data = jsonDecode(response.body);
        print(data);
        errorMessage = data['message']; // Set the error message

        throw Exception(response.body);
      }
    } catch (error) {
      setState(() {
        loading2 = false;
      });
      print('Error is $error');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return EnrollmentDialog(
            press1: () {
              Navigator.pop(context);
            },
            press2: () {
              setState(() {
                loading = false;
              });
              Navigator.pop(context);
            },
            theicon: Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ),
            title: "Reset Failed",
            message: errorMessage.isNotEmpty
                ? errorMessage
                : "Please try again later.",
            message2: "Close",
          );
        },
      );
    }
  }

  Future reset() async {
    String errorMessage = ''; // Initialize the error message variable
    dynamic payload = jsonEncode({"email": emailreq.text});
    try {
      final response = await http.post(
          Uri.parse("https://decode-mnjh.onrender.com/api/user/forgotpassword"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $Token',
          },
          body: payload);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          loading = false;
          res = data['message'];
          action = "blue";
          print('res is $res');
        });

        // Show a success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EnrollmentDialog(
              press1: () {
                Navigator.pop(context);
              },
              press2: () {
                Navigator.pop(context);
              },
              theicon: Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 60,
              ),
              title: "Reset Token Sent",
              message: "Reset Token sent to your Email",
              message2: 'Update password',
            );
          },
        );
      } else if (response.statusCode == 400) {
        var data = jsonDecode(response.body);
        print(data);
        errorMessage = data['message']; // Set the error message

        throw Exception(response.body);
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      print('Error is $error');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return EnrollmentDialog(
            press1: () {
              Navigator.pop(context);
            },
            press2: () {
              setState(() {
                loading = false;
              });
              Navigator.pop(context);
            },
            theicon: Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ),
            title: "Reset Failed",
            message: errorMessage.isNotEmpty
                ? errorMessage
                : "Please try again later.",
            message2: "Close",
          );
        },
      );
    }
  }

  TextEditingController emailreq = TextEditingController();

  @override
  void initState() {
    GetToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TheBars(
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
                        thetext: "Reset Your password",
                        style: GoogleFonts.poppins(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      Thetext(
                        thetext:
                            "Request your password reset token and update \nto a new passord",
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              child: TheFormfield(
                controller: emailreq,
                value: 'Enter Email',
                suffix: Icon(Icons.email),
              ),
            ),
            loading
                ? CircularProgressIndicator()
                : Mybuttons(
                    callback: () {
                      setState(() {
                        loading = true;
                      });

                      reset().whenComplete(() => () {
                            setState(() {
                              loading = false;
                            });
                          });
                    },
                    btncolor: Colors.blue,
                    buttontxt: "Request Token",
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 10.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Thetext(
                        thetext: "Update Password",
                        style: GoogleFonts.poppins(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            TheFormfield(
              value: "Enter Token",
              controller: Thetoken,
              suffix: Icon(Icons.token),
            ),
            SizedBox(
              height: 20,
            ),
            TheFormfield(
              value: "Enter New Passord",
              controller: Thepassword,
              suffix: Icon(Icons.token),
            ),
            SizedBox(
              height: 35,
            ),
            loading2
                ? CircularProgressIndicator()
                : Mybuttons(
                    callback: () {
                      action == "blue"
                          ? setState(() {
                              loading2 = true;

                              Update().whenComplete(() => () {
                                    setState(() {
                                      loading2 = false;
                                    });
                                  });
                            })
                          : () {};
                    },
                    btncolor: action == "blue" ? Colors.blue : Colors.grey,
                    buttontxt: "Update Password",
                  )
          ],
        ),
        callback: () {});
  }
}
