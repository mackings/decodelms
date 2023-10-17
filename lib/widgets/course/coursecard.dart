import 'package:decodelms/models/coursemodel.dart';
import 'package:decodelms/views/course/coursedetails.dart';
import 'package:decodelms/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.6),
            ),
            child: Text(
              'Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
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


          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => CourseDetailsPage(allCourses: widget.allCourse),
          //       ),
          //     );
          //   },
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(10),
          //     child: Image.network(
          //       widget.allCourse.imageUrl.isNotEmpty
          //           ? widget.allCourse.imageUrl[0] // Access the first image URL
          //           : '', // Handle empty URL
          //       fit: BoxFit.cover,
          //       width: double.infinity,
          //     ),
          //   ),
          // ),



          // GestureDetector(
          //   onTap: () {
              
          //   },
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(10),
          //     child: Image.network(
          //       widget.allCourse.imageUrl.isNotEmpty
          //           ? widget.allCourse.imageUrl // Access the image URL directly
          //           : '', // Handle empty URL
          //       fit: BoxFit.cover,
          //       width: double.infinity,
          //     ),
          //   ),
          // )