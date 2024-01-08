import 'dart:convert';

import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/models/searchcourse.dart';
import 'package:decodelms/views/Homepage/home.dart';
import 'package:decodelms/views/course/coursestream.dart';
import 'package:decodelms/views/course/enrolledcourses.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/coursenav.dart';
import 'package:decodelms/widgets/course/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class CourseDetailsPage extends StatefulWidget {
  final Coursem allCourses;
  //final List<Courseresults> searchCourses; // Corrected variable name

  const CourseDetailsPage({required this.allCourses});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  String? id;

  dynamic Token;
  bool isEnrolling = false;

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

  dynamic res;

  @override
  void initState() {
    GetToken();
    setState(() {
      id = widget.allCourses.id;
      print("ID is $id");
    });
    super.initState();
  }

  Future enroll() async {
    setState(() {
      isEnrolling = true;
    });

    String errorMessage = ''; // Initialize the error message variable

    try {
      final response = await http.post(
        Uri.parse(
            "https://server-eight-beige.vercel.app/api/student/studentPost/$id"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $Token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          res = data['message'];
          print('res is $res');
          isEnrolling = false;
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
                Navigator.pop(context);
              },
              theicon: Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 60,
              ),
              title: "Enrollment Successful",
              message: "Successfully Enrolled for this course",
              message2: 'Go to Course',
            );
          },
        );
      } else if (response.statusCode == 409) {
        var data = jsonDecode(response.body);
        print(data);

        setState(() {
          errorMessage = data['message'];
        });

        setState(() {
          isEnrolling = false;
        });

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
                Icons.error,
                color: Colors.red,
                size: 60,
              ),
              title: "Enrollment Failed",
              message: errorMessage.isNotEmpty
                  ? errorMessage
                  : "Enrollment failed. Please try again later.",
              message2: "Take me Home",
            );
          },
        );

        // throw Exception(response.body);
      } else {
        setState(() {
          isEnrolling = false;
        });

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
                Icons.error,
                color: Colors.red,
                size: 60,
              ),
              title: "Enrollment Failed",
              message: errorMessage.isNotEmpty
                  ? errorMessage
                  : "Enrollment failed. Please try again later.",
              message2: "Take me Home",
            );
          },
        );
        print(response.body);
      }
    } catch (error) {
      print('Error is $error');
      setState(() {
        isEnrolling = false;
      });

      print(res);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return EnrollmentDialog(
            press1: () {
              Navigator.pop(context);
            },
            press2: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, Homepage() as Route<Object?>);
            },
            theicon: Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ),
            title: "Enrollment Failed",
            message: errorMessage.isNotEmpty
                ? errorMessage
                : "Enrollment failed. Please try again later.",
            message2: "Take me Home",
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
  length: 3,
  child: Scaffold(
    body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                  Thetext(
                    thetext: "About Course",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(""),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  children: [
                    Container(
                      height: 25.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              widget.allCourses.courseImage.first.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Thetext(
                    thetext: widget.allCourses.courseTitle,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IntrinsicWidth(
                    child: Container(
                      constraints: BoxConstraints(minWidth: 30.w),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  widget.allCourses.courseImage.first.path),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Thetext(
                                thetext: "Decode Analytical",
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TabBar(
                indicatorColor: Colors.black,
                tabs: [
                  Tab(
                    child: Thetext(
                      thetext: "About",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Tab(
                    child: Thetext(
                      thetext: "Lessons",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Tab(
                    child: Thetext(
                      thetext: "Reviews",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 30.h,
              child: TabBarView(
                children: [
                  // Description tab content
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Thetext(
                            thetext: widget.allCourses.courseDescription,
                            style: GoogleFonts.poppins(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 30,
                              bottom: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Price container
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1.0),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Thetext(
                                          thetext: "Price",
                                          style: GoogleFonts.poppins(),
                                        ),
                                        Thetext(
                                          thetext: '0.0',
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Live Lessons container
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1.0),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Thetext(
                                          thetext: "Live",
                                          style: GoogleFonts.poppins(),
                                        ),
                                        Thetext(
                                          thetext: "Lessons",
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Enrolled container
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1.0),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Thetext(
                                          thetext: widget.allCourses.totalRegisteredByStudent.toString(),
                                          style: GoogleFonts.poppins(),
                                        ),
                                        Thetext(
                                          thetext: "Enrolled",
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ],
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

                  // Modules tab content
ListView.builder(
  itemCount: widget.allCourses.modules.length,
  itemBuilder: (context, index) {
    final module = widget.allCourses.modules[index];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GestureDetector(
        onTap: () {
          print(module.id);
        },
        child: Container(
          height: MediaQuery.of(context).size.width * 0.2, // Adjust the height as needed
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Thetext(
              thetext: module.moduleTitle,
              style: GoogleFonts.poppins(),
            ),
            leading: Icon(
              Icons.play_circle,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  },
),


                  // Reviews tab content
                  Center(
                    child: Text('Reviews will be displayed here'),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: isEnrolling
                  ? null
                  : enroll, // Disable the button when enrolling
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                child: Container(
                  height: 7.h,
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                    color: isEnrolling ? Colors.grey : Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: isEnrolling
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Thetext(
                            thetext: "Enroll",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  ),
);

  }
}
