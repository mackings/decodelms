import 'dart:async';

import 'package:decodelms/apis/authclass.dart';
import 'package:decodelms/views/auth/signin.dart';
import 'package:decodelms/widgets/Dialogs.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/buttons.dart';
import 'package:decodelms/widgets/formfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

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
  @override
  Widget build(BuildContext context) {
    final thetheme = ref.watch(api.themeprovider.notifier);

    return TheBar(
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
                        thetext: "Create your account",
                        style: GoogleFonts.poppins(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      Thetext(
                        thetext:
                            "Get started by creating an account or by \nsigning in with your socials  ",
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
              value: "Enter Email",
              prefix: Icon(Icons.email),
            ),
            SizedBox(
              height: 5.h,
            ),
            TheFormfield(
              value: "Enter Phone Number",
              prefix: Icon(Icons.phone),
            ),
            SizedBox(
              height: 5.h,
            ),
            TheFormfield(
              value: "Enter Password",
              prefix: Icon(Icons.lock),
              suffix: Icon(Icons.visibility),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(120.0, 0.0, 120.0, 5.0),
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
            loading
                ? Apidialog(
                    message: "Loading",
                    dialog: CircularProgressIndicator(),
                  )
                : Mybuttons(
                    callback: () {
                      print("Yoo");
                      setState(() {
                        loading = true;

                        Timer(Duration(seconds: 2), () {
                          setState(() {
                            loading = false;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signin()));
                          });
                        });
                      });
                    },
                    buttontxt: "Register",
                    btncolor: Colors.blue,
                  ),
          ],
        ));
  }
}
