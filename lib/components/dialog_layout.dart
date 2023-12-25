import 'package:flutter/material.dart';

class DialogLayout extends StatelessWidget {
  const DialogLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: Colors.green[700],
            radius: 35,
          ),
          Text("content"),
        ],
      ),
    );
  }
}
