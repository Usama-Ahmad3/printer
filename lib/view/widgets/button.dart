import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  VoidCallback onTap;
  String title;
  ButtonWidget({super.key, required this.onTap, required this.title});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.cyanAccent)),
              onPressed: widget.onTap,
              child: Text(widget.title,
                  style: const TextStyle(color: Colors.white, fontSize: 20))),
        ));
  }
}
