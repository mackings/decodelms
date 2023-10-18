import 'package:flutter/material.dart';

class Apidialog extends StatefulWidget {
  final String message;
  final bool isSuccess;
  final VoidCallback onClose;

  Apidialog({
    required this.message,
    required this.isSuccess,
    required this.onClose,
  });

  @override
  State<Apidialog> createState() => _ApidialogState();
}

class _ApidialogState extends State<Apidialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.isSuccess ? Icons.check_circle : Icons.error,
              color: widget.isSuccess ? Colors.green : Colors.red,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              widget.message,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            ElevatedButton(
              onPressed: widget.onClose,
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
