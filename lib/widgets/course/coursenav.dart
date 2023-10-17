import 'package:flutter/material.dart';

class ButtonRow extends StatefulWidget {
  final String title;
  final VoidCallback leftButtonCallback;
  final VoidCallback rightButtonCallback;

  ButtonRow({
    required this.title,
    required this.leftButtonCallback,
    required this.rightButtonCallback,
  });

  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: widget.leftButtonCallback,
            child: CircleAvatar(
              radius: 18,
              child: Icon(Icons.arrow_back),
            ),
          ),

          Text(widget.title, style: TextStyle(fontSize: 18)),
          GestureDetector(
            onTap: () {
              widget.rightButtonCallback;
            },
            child: CircleAvatar(
              radius: 18,
              child: Icon(Icons.point_of_sale),
            ),
          ),
        ],
      ),
    );
  }
}
