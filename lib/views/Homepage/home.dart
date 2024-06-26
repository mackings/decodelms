import 'dart:convert';
import 'dart:math';

import 'package:decodelms/views/course/allcourse.dart';
import 'package:decodelms/views/course/enrolledcourses.dart';
import 'package:decodelms/views/course/search.dart';
import 'package:decodelms/views/course/stream.dart';
import 'package:decodelms/views/videocalls/joincall.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/colors.dart';
import 'package:decodelms/widgets/course/courseslider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:badges/badges.dart' as badges;

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  dynamic Token;
  dynamic User;
  dynamic firstname;

  String getFirstNameFromUserData(String userData) {
    if (userData.isNotEmpty) {
      dynamic userDataJson = jsonDecode(userData);
      if (userDataJson.containsKey('firstName')) {
        return userDataJson['firstName'];
      }
    }
    return ''; 
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

  final String websocketUrl = "http://192.168.43.110:5000";
  final String selfCallerID =
      Random().nextInt(999999).toString().padLeft(6, '0');

  @override
  void initState() {
    GetToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
  builder: (context, orientation, deviceType) {
    return TheBar(
      callback: () {},
      thebody: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 15),
                  Thetext(
                    thetext: "Hello, ${firstname}",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    badges.Badge(
                      badgeStyle: badges.BadgeStyle(badgeColor: Colors.blue),
                      badgeContent: Text(
                        '0',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      child: CircleAvatar(child: Icon(Icons.person)),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  Thetext(
                    thetext: "Let's learn\ntogether.",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Container(
              height: 40.sp,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 211, 218, 224),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: TextFormField(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()));
                    },
                    onChanged: (value) {
                      setState(() {
                        print(value);
                      });
                    },
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(color: Colors.black),
                      hintText: "Search a Course",
                      suffixIcon: Container(
                        height: 40.sp,
                        width: 40.sp,
                        child: IconButton(
                          icon: Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                          
                          },
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Thetext(
                  thetext: "Continue to Course",
                  style: GoogleFonts.poppins(),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Enrolledcourses()));
                  },
                  child: Thetext(
                    thetext: "See all",
                    style: GoogleFonts.poppins(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {},
              child: CourseCarouselSlider(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                Thetext(
                  thetext: "Most browsed through",
                  style: GoogleFonts.poppins(),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => allCoursesPage()));
                  },
                  child: Thetext(
                    thetext: "See more",
                    style: GoogleFonts.poppins(color: Colors.blue),
                  ),
                ),

              ],
            ),
          ),

          SizedBox(height: 4.h,),

          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: AllCourseCarouselSlider(),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Thetext(
                  thetext: "Live lessons",
                  style: GoogleFonts.poppins(),
                ),
                Thetext(
                  thetext: "",
                  style: GoogleFonts.poppins(color: Colors.blue),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(
                top: 20, left: 20, right: 20, bottom: 20),
            child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Image.network(
                              "https://decodeanalytical.com/wp-content/uploads/2023/10/wepik-export-20231012130233revP.png",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 15.h,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30, bottom: 30),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.black),
                        color: appcolor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Thetext(
                              thetext: "Live Lesson",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Thetext(
                                thetext:
                                    "Explore Live lessons by simply enrolling in a course and have access to unlimited live instructor-led lessons.",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  },
);

  }
}
