import 'dart:convert';

import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/buttombar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  dynamic Token;
  dynamic User;
  dynamic firstname;
  dynamic profile;

  String getFirstNameFromUserData(String userData) {
    if (userData.isNotEmpty) {
      dynamic userDataJson = jsonDecode(userData);
      setState(() {
        profile = userDataJson;
      });
      if (userDataJson.containsKey('firstName')) {
        return userDataJson['firstName'];
      }
    }
    return '';
  }

      void _onTabTapped(int index) {
    // setState(() {
    //   0 = index;
    // });
  }

  Future GetToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? user = prefs.getString('userData');
    if (token != null) {
      setState(() {
        Token = token;
        User = user;
      });

      print("Token retrieved from shared preferences: $Token");
      print("User Data retrieved from shared preferences: $User");

      String firstName = getFirstNameFromUserData(User ?? '');
      if (firstName.isNotEmpty) {
        setState(() {
          firstname = firstName;
        });
        print("First Name: $firstName");
      } else {
        print("First Name not found in user data.");
      }
    } else {
      print("Token not found in shared preferences.");
    }
  }

  @override
  void initState() {
    GetToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15),
          child: Thetext(
              thetext: "Profile",
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp)),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.person),
            ),
            SizedBox(height: 2.h,),

            Thetext(
                thetext: "${profile['firstName']} ${profile['lastName']}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,

                )),

                            Thetext(
                thetext: "${profile['email']}",
                style: GoogleFonts.poppins())
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(currentIndex: 0, onTabTapped:_onTabTapped ),
    );
  }
}
