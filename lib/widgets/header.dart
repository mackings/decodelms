import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Myheader extends StatelessWidget {
  final String title;
  final Column? body;
  final Icon back;
  final Icon? forward;
  final VoidCallback theback;
  final VoidCallback? thefront;

  Myheader({
    required this.title,
    this.body,
    required this.back,
    this.forward,
    required this.theback,
    this.thefront,
  });

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: back,
            color: Colors.black,
            onPressed: theback,
          ),
          actions: forward != null && thefront != null
              ? [
                  IconButton(
                    color: Colors.black,
                    icon: forward!,                  
                    onPressed: thefront,
                  ),
                ]
              : null,
          title: Text(title,style: TextStyle(
            color: Colors.black,
            fontFamily: "Poppins"
          ),),
        ),
        body: SingleChildScrollView(child: Center(child: body))
      );
    });
  }
}

