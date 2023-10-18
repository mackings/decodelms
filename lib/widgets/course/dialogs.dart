import 'package:decodelms/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter/material.dart';

class EnrollmentDialog extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onClose;
  final VoidCallback onAction;
  final String actionText;

  EnrollmentDialog({
    required this.title,
    required this.message,
    required this.onClose,
    required this.onAction,
    required this.actionText,
  });

  @override
  State<EnrollmentDialog> createState() => _EnrollmentDialogState();
}

class _EnrollmentDialogState extends State<EnrollmentDialog> {
  bool _dismissable = false; // A flag to control dismissibility

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 300,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        child: Column(
          children: [
            // Icon for success or failure
                   Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Exit icon
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if (!_dismissable)
                  // Action icon (e.g., retry)
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      widget.onAction();

                      setState(() {
                        _dismissable = true;
                      });
                    },
                  ),
              ],
            ),
            Icon(
              _dismissable ? Icons.check : Icons.error,
              size: 100,
              color: _dismissable ? Colors.green : Colors.red,
            ),
            Thetext(
              thetext:widget.title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp

              )
            ),
            Thetext(thetext:widget.message,style: GoogleFonts.poppins(),),

          ],
        ),
      ),
    );
  }
}

