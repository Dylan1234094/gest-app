import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../utilities/designs.dart';

class MyTextFormDate extends StatefulWidget {
  final String label;
  final TextEditingController dateController;
  final bool? continous;
  const MyTextFormDate(
      {Key? key,
      required this.label,
      required this.dateController,
      this.continous})
      : super(key: key);

  @override
  State<MyTextFormDate> createState() => _MyTextFormDate();
}

class _MyTextFormDate extends State<MyTextFormDate> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 13.0),
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
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate:
                widget.continous == true ? DateTime(2100) : DateTime.now());

        if (pickedDate != null) {
          setState(() {
            widget.dateController.text =
                intl.DateFormat('dd/MM/yyyy').format(pickedDate);
          });
          FocusScope.of(context).nextFocus();
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: const OutlineInputBorder(),
        labelText: widget.label,
        hintStyle: kInfo,
        labelStyle: kInfo,
        suffixIcon: const Icon(
          Icons.calendar_month,
          color: colorPrincipal,
        ),
      ),
    );
  }
}
