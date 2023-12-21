import 'package:decodelms/views/Homepage/home.dart';
import 'package:decodelms/views/course/allcourse.dart';
import 'package:decodelms/views/course/calls.dart';
import 'package:decodelms/views/course/search.dart';
import 'package:decodelms/views/profile/profile.dart';
import 'package:flutter/material.dart';



class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  MyBottomNavigationBar({
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTabTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
                       Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Homepage()));
            },
            child: Icon(Icons.home),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
          Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
            child: Icon(Icons.search),
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
                            Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => allCoursesPage()));
            },
            child: Icon(Icons.play_circle),
          ),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
                            Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Calls()));
             
            },
            child: Icon(Icons.call_to_action),
          ),
          label: 'Live lessons',
        ),

                BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
                            Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
             
            },
            child: Icon(Icons.person),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
