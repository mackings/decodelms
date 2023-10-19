import 'package:decodelms/widgets/buttombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class TheBar extends ConsumerStatefulWidget {
  var arrowback;
  var arrowforward;
  final VoidCallback callback;
  Column thebody;
  TheBar(
      {this.arrowback,
      this.arrowforward,
      required this.callback,
      required this.thebody,
      });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TheBarState();
}

class _TheBarState extends ConsumerState<TheBar> {

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(12.0,40.0,12.0,0.0),
            child: SingleChildScrollView(child: widget.thebody),
          ),

          bottomNavigationBar: MyBottomNavigationBar(currentIndex: _currentIndex,
           onTabTapped: _onTabTapped),
        );
      },
    );
  }
}

class Thetext extends StatefulWidget {
  var thetext;
  var style;

  Thetext({
    required this.thetext,
    required this.style,
  });

  @override
  State<Thetext> createState() => _ThetextState();
}

class _ThetextState extends State<Thetext> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.thetext,
      style: widget.style,
    );
  }
}




class TheBars extends StatefulWidget {
  final Widget thebody;
  final VoidCallback callback;

  TheBars({
    required this.thebody,
    required this.callback,
  });

  @override
  _TheBarsState createState() => _TheBarsState();
}

class _TheBarsState extends State<TheBars> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 60.0, 12.0, 0.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: widget.thebody,
            ),
          ),
        );
      },
    );
  }
}
