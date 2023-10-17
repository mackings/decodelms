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
      items: [
        BottomNavigationBarItem(
          icon: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.library_books,
                color: Colors.white,
              ),
            ),
          ),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            ),
          ),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
