import 'dart:async';
import 'dart:convert';

import 'package:decodelms/apis/authclass.dart';
import 'package:decodelms/models/user.dart';
import 'package:decodelms/views/auth/signin.dart';
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
import 'package:http/http.dart' as http;

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  bool ischecked = true;
  bool isuncheked = false;
  bool loading = false;
  final api = Api();
  dynamic err;

  Register UserRegister() {
    return Register(
      firstname: firstname.text,
      lastname: lastname.text,
      email: email.text,
      phone: phone.text,
      password: password.text,
    );
  }

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  Future signup(Register register) async {
    dynamic payload = jsonEncode({
      "firstName": register.firstname,
      "lastName": register.lastname,
      "email": register.email,
      "phoneNumber": register.phone,
      "password": register.password
    });
    final response = await http.post(
        Uri.parse("https://decode-mnjh.onrender.com/api/user/signup"),
        body: payload,
        headers: {
          "Content-Type": "application/json",
        });

    if (response.statusCode == 201) {
      Map<String, dynamic> theres = jsonDecode(response.body);
      setState(() {
        err = theres['message'];
      });

      print("success");
      print(theres);
      setState(() {
        loading = false;
      });

      showDialog(
          context: context,
          builder: (context) {
            return EnrollmentDialog(
                title: "Registered Successfully",
                message: "Check email inbox for Verification",
                message2: 'Procced',
                press1: () {
                  Navigator.pop(context);
                },
                press2: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Signin(); // Replace with the widget for the new screen
                      },
                    ),
                  );
                },
                theicon: Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Colors.blue,
                ));
          });
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

  bool visi = false;

  @override
  Widget build(BuildContext context) {
    final thetheme = ref.watch(api.themeprovider.notifier);

    return TheBars(
        callback: () {},
        thebody: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            loading = false;
                          });
                        },
                        child: Thetext(
                          thetext: "Create your account",
                          style: GoogleFonts.poppins(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Thetext(
                        thetext:
                            "Get started by creating an account or\nsigning in as an exisiting user  ",
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
              height: 2.h,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 5),
              child: TheFormfield(
                vis: false,
                controller: firstname,
                value: "Enter First Name",
                prefix: Icon(Icons.person),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 5),
              child: TheFormfield(
                vis: false,
                controller: lastname,
                value: "Enter Last Name",
                prefix: Icon(Icons.person),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 5),
              child: TheFormfield(
                vis: false,
                controller: email,
                value: "Enter Email",
                prefix: Icon(Icons.email),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 5),
              child: TheFormfield(
                vis: false,
                controller: phone,
                value: "Enter Phone Number",
                prefix: Icon(Icons.phone),
              ),
            ),
Padding(
  padding: const EdgeInsets.only(bottom: 20, top: 5),
  child: TheFormfield(
    vis: visi,
    controller: password,
    value: "Enter Password",
    prefix: Icon(Icons.lock),
    suffix: GestureDetector(
      onTap: () {
        setState(() {
          visi = !visi;
        });
      },
      child: visi ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
    ),
  ),
),

            SizedBox(
              height: 4.h,
            ),
            loading
                ? CircularProgressIndicator()
                : Mybuttons(
                    callback: () async {
                      setState(() {
                        loading = true;
                      });

                      try {
                        dynamic response = await signup(UserRegister());

                        if (response != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signin()));
                        } else {}
                      } catch (e) {
                        print(e);
                        setState(() {
                          loading = false;
                        });
                        showDialog(
                            context: context,
                            builder: (context) {
                              return EnrollmentDialog(
                                  title: "Error Registering User",
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
                    buttontxt: "Create Account",
                    btncolor: Colors.blue,
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Thetext(
                      thetext: "Existing User?", style: GoogleFonts.poppins()),
                  SizedBox(
                    width: 3.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Signin()));
                    },
                    child: Thetext(
                        thetext: "Sign In",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.blue)),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
