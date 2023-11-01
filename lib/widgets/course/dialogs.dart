import 'package:decodelms/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class EnrollmentDialog extends StatefulWidget {
  final String title;
  final String message;
  final String message2;
  final VoidCallback press1;
  final VoidCallback press2;
  final Icon theicon;

  EnrollmentDialog({
    required this.title,
    required this.message,
     required this.message2,
    required this.press1,
    required this.press2,
    required this.theicon
  });

  @override
  State<EnrollmentDialog> createState() => _EnrollmentDialogState();
}

class _EnrollmentDialogState extends State<EnrollmentDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 300,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap:widget.press1, 
                    child: Icon(Icons.close))
            
                ],
              ),
            ),
            widget.theicon,

            Thetext(
              thetext: widget.title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            Thetext(
              thetext: widget.message,
              style: GoogleFonts.poppins(
                fontSize: 9.sp
              ),
            ),

            SizedBox(height: 35,),

            GestureDetector(
              onTap: widget.press2,
              child: Container(
                height: 7.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Thetext(thetext: widget.message2, style: GoogleFonts.poppins(
                  color: Colors.white
                ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
