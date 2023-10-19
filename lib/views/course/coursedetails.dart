import 'dart:convert';

import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/views/course/coursestream.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/coursenav.dart';
import 'package:decodelms/widgets/course/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class CourseDetailsPage extends StatefulWidget {
  final AllCourse allCourses; // Corrected variable name

  CourseDetailsPage({required this.allCourses});

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

    try {
      final response = await http.post(
        Uri.parse(
            "https://decode-mnjh.onrender.com/api/student/studentPost/$id"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $Token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);

        setState(() {
          isEnrolling = false;
        });

showDialog(
  context: context,
  builder: (BuildContext context) {
    return EnrollmentDialog(
      title: "Enrollment Successful",
      message: "You have successfully enrolled in this course.",
      onClose: () {
        Navigator.of(context).pop(); 
      },
      onAction: () {
        Navigator.of(context).pop();
      },
      actionText: "Go to Course",
    );
  },
);

      } else {
        print(response.body);
        throw Exception(response.body);
      }
    } catch (error) {
      // Enrollment failed
      setState(() {
        isEnrolling = false;
      });

showDialog(
  context: context,
  builder: (BuildContext context) {
    return EnrollmentDialog(
      title: "Enrollment Failed",
      message: "You have already enrolled .",
      onClose: () {
        Navigator.of(context).pop(); 
      },
      onAction: () {
        Navigator.of(context).pop(); 

      },
      actionText: "Go to Course",
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
          padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonRow(
                    title: "About Course",
                    leftButtonCallback: () {
                      Navigator.pop(context);
                    },
                    rightButtonCallback: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      children: [
                        Container(
                          height: 25.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.allCourses.imageUrl),
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
                          thetext: widget.allCourses.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          )),
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
                                  backgroundImage:
                                      NetworkImage(widget.allCourses.imageUrl),
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
                              ))),
                      Tab(
                          child: Thetext(
                              thetext: "Lessons",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ))),
                      Tab(
                          child: Thetext(
                              thetext: "Reviews",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ))),
                    ],
                  ),
                ),
                Container(
                  height: 30.h,
                  child: TabBarView(
                    
                    children: [
                      // Description tab content
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 25, right: 25, top: 30),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Text(widget.allCourses.description),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 25.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Thetext(
                                                thetext: "30",
                                                style: GoogleFonts.poppins()),
                                            Thetext(
                                                thetext: "Lessons",
                                                style: GoogleFonts.poppins()),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 25.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Thetext(
                                                thetext: "30",
                                                style: GoogleFonts.poppins()),
                                            Thetext(
                                                thetext: "Lessons",
                                                style: GoogleFonts.poppins()),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 25.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Thetext(
                                                thetext: widget
                                                    .allCourses.enrolled
                                                    .toString(),
                                                style: GoogleFonts.poppins()),
                                            Thetext(
                                                thetext: "Enrolled",
                                                style: GoogleFonts.poppins()),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
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
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: GestureDetector(
                              onTap: () {
                                print(module.videoUrl);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Videostream()));
                              },
                              child: Container(
                                height: 10.h,
                                width: 5.w,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ListTile(
                                      title: Thetext(
                                          thetext: module.title,
                                          style: GoogleFonts.poppins()),
                                      leading: Icon(Icons.play_circle),
                                      subtitle: Thetext(
                                          thetext: module.description,
                                          style: GoogleFonts.poppins()),
                                    ),
                                  ],
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
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
                                    AlwaysStoppedAnimation<Color>(Colors.white))
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
