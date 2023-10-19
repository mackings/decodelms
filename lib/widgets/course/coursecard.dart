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

// class CourseEnrolledCard extends StatefulWidget {
//   final Course course;

//   CourseEnrolledCard({required this.course});

//   @override
//   State<CourseEnrolledCard> createState() => _CourseEnrolledCardState();
// }

// class _CourseEnrolledCardState extends State<CourseEnrolledCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.sp),
//       child: Container(
//         height: 50.h,
//         width: MediaQuery.of(context).size.width -
//             20.w, // Adjust the width as needed
//         margin: EdgeInsets.all(8.sp),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10.sp),
//           border: Border.all(
//             color: Colors.black, // Border color
//             width: 0.5.sp, // Border width
//           ),
//         ),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//         GestureDetector(
//           onTap: () {
//             print(widget.course.id);
//           },
//           child: Container(
//             width: double.infinity,
//             height: 95.sp, // Adjust the height as needed
//             decoration: BoxDecoration(
//               image: DecorationImage(
//           image: NetworkImage(widget.course.imageUrl),
//           fit: BoxFit.cover, // Fit the image within the container
//           alignment: Alignment.center,
//           colorFilter: ColorFilter.mode(
//             Colors.black.withOpacity(0.6), // Adjust the opacity to control the darkening effect
//             BlendMode.darken,
//           ),
//               ),
//             ),
//             child: Icon(
//               Icons.play_circle_outline, // Play button icon
//               color: Colors.white,
//               size: 58.sp, // Adjust the size as needed
//             ),
//           ),
//         ),

//               Padding(
//                 padding: EdgeInsets.all(8.sp),
//                 child: Thetext(
//                     thetext: widget.course.title,
//                     style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.bold, fontSize: 12.sp)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 18.h, // Adjust the height as needed
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 25.w, // Adjust the width as needed
                height: double.infinity, // Expand to the available height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(widget.course.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Thetext(
                        thetext: widget.course.title,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Thetext(
                          thetext: "4hr 30Mins",
                          style: GoogleFonts.poppins(
                              //fontWeight: FontWeight.bold
                              ),
                        ),
                      ),
    
            LinearProgressIndicator(
              value: 0.5, 
              minHeight: 10.0,
              backgroundColor: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
