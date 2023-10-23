import 'dart:convert';

import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/views/course/coursedetails.dart';
import 'package:decodelms/views/course/stream.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/courseslider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class CourseCard extends StatefulWidget {
  final Course course;

  CourseCard({required this.course});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  dynamic Id;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Id = widget.course.id;
        });

        print(Id);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => StreamPage(courseId: Id)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            // Display the course title
            Text(
              widget.course.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Display the course image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.course.imageUrl, // Use the course's image URL
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            IntrinsicWidth(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.6),
                ),
                child: Thetext(
                  thetext: widget.course.title,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
            // Center the play icon
            Center(
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 48.0,
              ),
            ),
          ],
        ),
      ),
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                print(widget.allCourse.imageUrl);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CourseDetailsPage(
                      allCourses: widget.allCourse,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      // bottomLeft: Radius.circular(10),
                      // bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      widget.allCourse.imageUrl.isNotEmpty
                          ? widget.allCourse.imageUrl
                          : '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 15.h, // Adjust the height as needed
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          // Handle play button tap action
                          // You can add your navigation logic here
                        },
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
                color: Colors.white,
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
                      thetext: widget.allCourse.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailsPage(allCourses: widget.allCourse),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Thetext(
                        thetext: widget.allCourse.description,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  //widget.allCourse.description

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Icon(
                  //     Icons.play_circle_outline,
                  //     color: Colors.black,
                  //     size: 48.0,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseEnrolledCard2 extends StatefulWidget {
  final Course course;

  CourseEnrolledCard2({required this.course});

  @override
  State<CourseEnrolledCard2> createState() => _CourseEnrolledCard2State();
}

class _CourseEnrolledCard2State extends State<CourseEnrolledCard2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => CourseDetailsPage(
                  //       allCourses: widget.allCourse,
                  //     ),
                  //   ),
                  // );
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        // bottomLeft: Radius.circular(10),
                        // bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        widget.course.imageUrl.isNotEmpty
                            ? widget.course.imageUrl
                            : '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 15.h, // Adjust the height as needed
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            // Handle play button tap action
                            // You can add your navigation logic here
                          },
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
                  color: Colors.white,
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
                        thetext: widget.course.title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         CourseDetailsPage(allCourses: widget.allCourse),
                        //   ),
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Thetext(
                          thetext: widget.course.description,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Icon(
                    //     Icons.play_circle_outline,
                    //     color: Colors.black,
                    //     size: 48.0,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CourseEnrolledCard extends StatefulWidget {
//   final Course course;

//   CourseEnrolledCard({required this.course});

//   @override
//   State<CourseEnrolledCard> createState() => _CourseEnrolledCardState();
// }

// class _CourseEnrolledCardState extends State<CourseEnrolledCard> {
//   @override
//   Widget build(BuildContext context) {
//     return
//     Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30),
//       child: Container(
//         height: 18.h, // Adjust the height as needed
//         decoration: BoxDecoration(
//           border: Border.all(width: 0.5, color: Colors.black),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 width: 25.w, // Adjust the width as needed
//                 height: double.infinity, // Expand to the available height
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   image: DecorationImage(
//                     image: NetworkImage(widget.course.imageUrl),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Thetext(
//                         thetext: widget.course.title,
//                         style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Thetext(
//                           thetext: "4hr 30Mins",
//                           style: GoogleFonts.poppins(
//                               //fontWeight: FontWeight.bold
//                               ),
//                         ),
//                       ),

//             LinearProgressIndicator(
//               value: 0.5,
//               minHeight: 10.0,
//               backgroundColor: Colors.grey,
//               borderRadius: BorderRadius.circular(10),
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
//             ),

//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//Animation

class AnimatedLoadingIndicator extends StatefulWidget {
  @override
  _AnimatedLoadingIndicatorState createState() =>
      _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Set the duration of one rotation
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.141592,
          child: CircularProgressIndicator(
            strokeWidth: 4.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      },
    );
  }
}
