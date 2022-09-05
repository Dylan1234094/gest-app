import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class MyTextFormDate extends StatefulWidget {
  final String label;
  final TextEditingController dateController;
  const MyTextFormDate({Key? key, required this.label, required this.dateController}) : super(key: key);

  @override
  State<MyTextFormDate> createState() => _MyTextFormDate();
}

class _MyTextFormDate extends State<MyTextFormDate> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: true,
        showCursor: true,
        validator: (text) {
          if (text!.isEmpty) {
            return '${widget.label} no puede estar vacio';
          }

          return null;
        },
        enableInteractiveSelection: false,
        controller: widget.dateController,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100));

          if (pickedDate != null) {
            setState(() {
              widget.dateController.text = intl.DateFormat('dd/MM/yyyy').format(pickedDate);
            });
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
            border: const OutlineInputBorder(), labelText: widget.label, suffixIcon: const Icon(Icons.calendar_month)));
  }
}
