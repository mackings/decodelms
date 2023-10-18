import 'dart:convert';

import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/views/course/coursedetails.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
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
                    style: GoogleFonts.poppins(color: Colors.white))),
          ),
        ],
      ),
    );
  }
}

// class AllCourseCard extends StatefulWidget {
//   final AllCourse allCourse;

//   AllCourseCard({required this.allCourse});

//   @override
//   State<AllCourseCard> createState() => _AllCourseCardState();
// }

// class _AllCourseCardState extends State<AllCourseCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         constraints: BoxConstraints(
//           maxWidth: 150,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Stack(
//             alignment: Alignment.topLeft,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => CourseDetailsPage(
//                         allCourses: widget.allCourse,
//                       ),
//                     ),
//                   );
//                 },
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.network(
//                     widget.allCourse.imageUrl.isNotEmpty
//                         ? widget.allCourse.imageUrl // Access the image URL directly
//                         : '', // Handle empty URL
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.black.withOpacity(0.6),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.allCourse.title,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   CourseDetailsPage(allCourses: widget.allCourse),
//                             ),
//                           );
//                         },
//                         child: Text(
//                           widget.allCourse.description,
//                           style: TextStyle(
//                             color: Colors.yellow,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class AllCourseCard extends StatefulWidget {
  final AllCourse allCourse;

  AllCourseCard({required this.allCourse});

  @override
  State<AllCourseCard> createState() => _AllCourseCardState();
}

class _AllCourseCardState extends State<AllCourseCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 150,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
                        ? widget.allCourse.imageUrl
                        : '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200, // Set the image height
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue, // Blue background color for details
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.allCourse.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CourseDetailsPage(
                                  allCourses: widget.allCourse),
                            ),
                          );
                        },
                        child: Text(
                          widget.allCourse.description,
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 12,
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
    );
  }
}

//Course enrolled card

class CourseEnrolledCard extends StatefulWidget {
  final Course course;

  CourseEnrolledCard({required this.course});

  @override
  State<CourseEnrolledCard> createState() => _CourseEnrolledCardState();
}

class _CourseEnrolledCardState extends State<CourseEnrolledCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: Container(
        height: 50.h,
        width: MediaQuery.of(context).size.width -
            20.w, // Adjust the width as needed
        margin: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(
            color: Colors.black, // Border color
            width: 0.5.sp, // Border width
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        GestureDetector(
          onTap: () {
            print(widget.course.id);
          },
          child: Container(
            width: double.infinity,
            height: 95.sp, // Adjust the height as needed
            decoration: BoxDecoration(
              image: DecorationImage(
          image: NetworkImage(widget.course.imageUrl),
          fit: BoxFit.cover, // Fit the image within the container
          alignment: Alignment.center,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6), // Adjust the opacity to control the darkening effect
            BlendMode.darken,
          ),
              ),
            ),
            child: Icon(
              Icons.play_circle_outline, // Play button icon
              color: Colors.white,
              size: 58.sp, // Adjust the size as needed
            ),
          ),
        ),
        
              Padding(
                padding: EdgeInsets.all(8.sp),
                child: Thetext(
                    thetext: widget.course.title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 12.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
