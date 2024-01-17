import 'dart:convert';

import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/buttombar.dart';
import 'package:decodelms/widgets/colors.dart';
import 'package:decodelms/widgets/course/coursecard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class allCoursesPage extends StatefulWidget {
  allCoursesPage({Key? key}) : super(key: key);

  @override
  State<allCoursesPage> createState() => _allCoursesPageState();
}

class _allCoursesPageState extends State<allCoursesPage> {


  dynamic Token;
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
    super.initState();
  }

Future<List<Coursem>?> fetchAllCourses() async {
  try {
    final response = await http.get(
      Uri.parse('https://server-eight-beige.vercel.app/api/course/viewAllCourses'),
      headers: {
        'Authorization': 'Bearer $Token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);

      if (responseData != null &&
          responseData is Map<String, dynamic> &&
          responseData.containsKey('courses')) {
        final coursesData = responseData['courses'];

        if (coursesData is List) {
          List<Coursem>? allCourses = (coursesData as List?)
              ?.map<Coursem>((courseData) {
                if (courseData is Map<String, dynamic>) {
                  return Coursem.fromJson(courseData);
                } else {
                  return Coursem(
                    id: 'Invalid Course Data',
                    userId: '',
                    courseTitle: '',
                    courseDescription: '',
                    courseLanguage: '',
                    reviews: [],
                    courseImage: [],
                    isPaidCourse: '',
                    isPriceCourse: 0,
                    modules: [],
                    totalRegisteredByStudent: 0,
                    createdAt: '',
                    updatedAt: '',
                  );
                }
              })
              .toList();

          print("All Courses $allCourses");
          return allCourses;
        } else {
          throw Exception('Invalid data format for courses');
        }
      } else {
        throw Exception('No courses data found in the response');
      }
    } else {
      throw Exception('Failed to load courses: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching courses: $e');
    return null; // Return null on error
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor,
      appBar: AppBar(
        backgroundColor: appcolor,
        
        elevation: 0,
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,

        title: Padding(
          padding: const EdgeInsets.only(top: 20,left: 15),
          child: Thetext(thetext: "Courses", style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15.sp
            
          )
          ),
        ),
      ),
      
      body: FutureBuilder<List<Coursem>?>(
        future: fetchAllCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Error: ${snapshot.error}');
          } else {
            final course = snapshot.data;

            if (snapshot.hasData &&
                snapshot.data != null && 
                snapshot.data!.isNotEmpty) {
              final allCourses = snapshot.data;
              print(allCourses);

              return Container(
                color: appcolor,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ListView.builder(
                    itemCount: allCourses!.length,
                    itemBuilder: (context, index) {
                      final allCourse = allCourses[index];
                      return Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(bottom: 20,top: 20,left: 30,right: 30),
                              child: GestureDetector(
                                  onTap: () {},
                                  child: AllCourseCard(allCourse: allCourse))),
                        ],
                      );
                    },
                  ),
                ),
              );
            } else {

              // No courses found, display a message

              return Center(
                child: Thetext(
                  thetext: "No Courses Found",
                  style: GoogleFonts.poppins(),
                ),
              );
            }
          }
        },
      ),

      bottomNavigationBar: MyBottomNavigationBar(currentIndex: 0, onTabTapped: _onTabTapped ),
    );
  }
}


void _onTabTapped(int index) {

  }
void call(){}

