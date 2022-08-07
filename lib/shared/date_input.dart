import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class MyDateInput extends StatefulWidget {
  const MyDateInput(
      {Key? key, required this.label, required this.dateController})
      : super(key: key);
  final String label;
  final TextEditingController dateController;

  @override
  State<MyDateInput> createState() => _MyDateState();
}

class _MyDateState extends State<MyDateInput> {
  String? date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(widget.label)),
        ),
        FractionallySizedBox(
          widthFactor: 0.95,
          child: ElevatedButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));

              if (newDate == null) return;
              setState(() {
                date = intl.DateFormat('dd/MM/yyyy').format(newDate);
                widget.dateController.text = date!;
              });
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: date == null
                  ? Text(widget.label)
                  : Text(widget.dateController.text),
            ),
          ),
        ),
      ],
    );
  }
}
