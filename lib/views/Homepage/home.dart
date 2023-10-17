import 'package:decodelms/widgets/appbar.dart';
import 'package:decodelms/widgets/course/courseslider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return TheBar(
          callback: () {},
          thebody: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Thetext(thetext: "Hello Macs", style: GoogleFonts.poppins()),

                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                      ),
                      SizedBox(width: 3.w,),
                      Icon(Icons.notifications)
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Thetext(thetext: "Let's learn\ntogether", style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp
                      )),
                    ],
                  ),
                ],
              ),

Padding(
  padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
  child: Container(
    height: 40.sp,
    width: MediaQuery.of(context).size.width - 1.w,
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
          onChanged: (value) {
            setState(() {
              print(value);
            });
          },
          decoration: InputDecoration(
            hintStyle: GoogleFonts.poppins(color: Colors.black),
            hintText: "Search Course",
            suffixIcon: Container(
              height: 40.sp, // Same height as the TextFormField
              width: 40.sp, // Custom width for the container
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  // Handle the search icon tap here
                },
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15)
              ),
            ),
            border: InputBorder.none,
          ),
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
    ),
  ),
),
SizedBox(height: 2.h),

Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Row(
    children: [
  
          Thetext(thetext: "Continue to course", style: GoogleFonts.poppins()), 
    ],

  ),
),


Padding(
  padding: const EdgeInsets.all(8.0),
  child:   CourseCarouselSlider(),
),
Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Row(
    children: [
  
          Thetext(thetext: "Most browsed through", style: GoogleFonts.poppins()), 
    ],

  ),
),

Padding(
  padding: const EdgeInsets.all(8.0),
  child:   AllCourseCarouselSlider(),
)

     ],
      )
    );
    }));
  }
}
