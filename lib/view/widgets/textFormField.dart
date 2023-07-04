import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  TextEditingController controller;
  ValueChanged? onChanged;
  IconData icon;
  String hint;
  TextInputType? type;
  TextFieldWidget(
      {super.key,
      this.type,
      this.onChanged,
      required this.controller,
      required this.hint,
      required this.icon});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.type,
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              color:
                  widget.controller.text != null ? Colors.black : Colors.grey,
              size: 16,
            ),
            hintText: widget.hint, hintStyle: const TextStyle(fontSize: 12),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(),
            ),
            //fillColor: Colors.green
          ),
          onChanged: widget.onChanged,
        ));
  }
}
