import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTextField extends StatefulWidget {
  const DateTextField({
    Key key,
    @required this.controller,
    @required this.icon,
    @required this.title,
  }) : super(key: key);

  final TextEditingController controller;
  final Icon icon;
  final String title;

  @override
  _DateTextFieldState createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  DateFormat _dateFormat;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateFormat = DateFormat('dd/MM/yyyy');
    widget.controller.text = _dateFormat.format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        labelText: widget.title,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        suffixIcon: widget.icon,
      ),
      onTap: () => _selectDate(context),
      readOnly: true,
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(
        Duration(days: 1825),
      ),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      widget.controller.text = _dateFormat.format(_selectedDate);
      // widget.onDateChanged(_selectedDate);
    }

    // if (widget.focusNode != null) {
    //   widget.focusNode.nextFocus();
    // }
  }
}
