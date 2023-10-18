import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/views/course/coursedetails.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/coursecard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';



class CourseCarouselSlider extends StatefulWidget {
  @override
  State<CourseCarouselSlider> createState() => _CourseCarouselSliderState();
}

class _CourseCarouselSliderState extends State<CourseCarouselSlider> {

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

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(
      Uri.parse('https://decode-mnjh.onrender.com/api/student/studentGet'),
      headers: {
        'Authorization':
            'Bearer $Token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      final List<dynamic> courseDataList =
          responseData['studentRegisteredCourses'];

      List<Course> courses = courseDataList
          .map((courseData) => Course.fromJson(courseData))
          .toList();

      return courses;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Course>>(
      future: fetchCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final courses = snapshot.data;

          if (courses != null && courses.isNotEmpty) {
            // Courses are found, display them in the carousel
            return CarouselSlider(
              items: courses.map((course) {
                return CourseCard(course: course);
              }).toList(),
              options: CarouselOptions(
                height: 140.0,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            );
          } else {
            // No courses found, display a message
            return Center(
              child: Thetext(thetext: "You have not Enrolled Yet\nCheck out our free courses today", style: GoogleFonts.poppins())
            );
          }
        }
      },
    );
  }
}


class AllCourseCard extends StatefulWidget {
  final AllCourse allCourse;

  AllCourseCard({required this.allCourse});

  @override
  State<AllCourseCard> createState() => _AllCourseCardState();
}

class _AllCourseCardState extends State<AllCourseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          // Display the course title
          Text(
            widget.allCourse.title,
            style: GoogleFonts.poppins(),
          ),

          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CourseDetailsPage(
                    allCourses: widget.allCourse,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.allCourse.imageUrl.isNotEmpty
                    ? widget.allCourse.imageUrl // Access the image URL directly
                    : '', // Handle empty URL
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the course title
                Text(
                  widget.allCourse.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Display the course description
                GestureDetector(
                  onTap: () {
                    // Navigate to the details page when description is pressed
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CourseDetailsPage(allCourses: widget.allCourse),
                      ),
                    );
                  },
                  child: Text(
                    widget.allCourse.description,
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class AllCourseCarouselSlider extends StatefulWidget {
  @override
  State<AllCourseCarouselSlider> createState() => _AllCourseCarouselSliderState();
}

class _AllCourseCarouselSliderState extends State<AllCourseCarouselSlider> {

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
  Future<List<AllCourse>> fetchAllCourses() async {
    final response = await http.get(
      Uri.parse('https://decode-mnjh.onrender.com/api/course/viewAllCourses'),
      headers: {
        'Authorization': 'Bearer $Token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['courses'];

      List<AllCourse> allCourses = responseData
          .map((courseData) => AllCourse.fromJson(courseData))
          .toList();

      return allCourses;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AllCourse>>(
      future: fetchAllCourses(), // Pass the bearer token
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final allCourses = snapshot.data;
          return CarouselSlider(
            items: allCourses!.map((allCourse) {
              return AllCourseCard(allCourse: allCourse,);
            }).toList(),
            options: CarouselOptions(
              height: 180.0,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          );
        } else {
          // Handle the case when there are no courses...
          return Text('No courses available.');
        }
      },
    );
  }
}


///////Enrolled Slide
class CourseCarouselSlider2 extends StatefulWidget {
  @override
  State<CourseCarouselSlider2> createState() => _CourseCarouselSlider2State();
}

class _CourseCarouselSlider2State extends State<CourseCarouselSlider2> {
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

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(
      Uri.parse('https://decode-mnjh.onrender.com/api/student/studentGet'),
      headers: {
        'Authorization': 'Bearer $Token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> courseDataList = responseData['studentRegisteredCourses'];

      List<Course> courses = courseDataList
          .map((courseData) => Course.fromJson(courseData))
          .toList();

      return courses;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Course>>(
      future: fetchCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final courses = snapshot.data;
    
          if (courses != null && courses.isNotEmpty) {
            // Courses are found, display them in a ListView
            return ListView.builder(
              //scrollDirection: Axis.vertical,
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Container(
                  height: 30.h,
                  child: Center(child: CourseEnrolledCard(course: course)));
              },
            );
          } else {
            // No courses found, display a message
            return Center(
              child: Thetext(
                thetext: "You have not Enrolled Yet\nCheck out our free courses today",
                style: GoogleFonts.poppins(),
              ),
            );
          }
        }
      },
    );
  }
}





// //Grid

// class AllCourseCarouselSlider extends StatefulWidget {
//   @override
//   State<AllCourseCarouselSlider> createState() => _AllCourseCarouselSliderState();
// }

// class _AllCourseCarouselSliderState extends State<AllCourseCarouselSlider> {
//   dynamic Token;

//   Future GetToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
//     if (token != null) {
//       setState(() {
//         Token = token;
//       });
//       print("Token retrieved from shared preferences: $Token");
//     } else {
//       print("Token not found in shared preferences.");
//     }
//   }

//   @override
//   void initState() {
//     GetToken();
//     super.initState();
//   }

//   Future<List<AllCourse>> fetchAllCourses() async {
//     final response = await http.get(
//       Uri.parse('https://decode-mnjh.onrender.com/api/course/viewAllCourses'),
//       headers: {
//         'Authorization': 'Bearer $Token',
//       },
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> responseData = json.decode(response.body)['courses'];

//       List<AllCourse> allCourses = responseData
//           .map((courseData) => AllCourse.fromJson(courseData))
//           .toList();

//       return allCourses;
//     } else {
//       throw Exception('Failed to load courses');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<AllCourse>>(
//       future: fetchAllCourses(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (snapshot.hasData) {
//           final allCourses = snapshot.data;
//           return GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2, // Number of columns in the grid
//             ),
//             itemCount: allCourses!.length,
//             itemBuilder: (context, index) {
//               return AllCourseCard(allCourse: allCourses[index]);
//             },
//           );
//         } else {
//           // Handle the case when there are no courses...
//           return Text('No courses available.');
//         }
//       },
//     );
//   }
// }








