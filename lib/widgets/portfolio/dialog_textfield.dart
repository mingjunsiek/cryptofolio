import 'package:flutter/material.dart';

class DialogTextField extends StatelessWidget {
  const DialogTextField(
      {Key key,
      @required this.controller,
      @required this.icon,
      @required this.title,
      @required this.isText,
      @required this.validator})
      : super(key: key);

  final TextEditingController controller;
  final bool isText;
  final Icon icon;
  final String title;
  final String validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: isText ? TextInputType.text : TextInputType.number,
      controller: controller,
      validator: (value) {
        if (value.isEmpty) return 'Please enter $validator';
        if (!isText && double.tryParse(value) == null)
          return 'Please enter a valid number';
        return null;
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        labelText: title,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        suffixIcon: icon,
      ),
    );
  }
}
