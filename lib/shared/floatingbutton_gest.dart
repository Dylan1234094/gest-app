// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class FloatingButtonGest extends StatelessWidget {
  const FloatingButtonGest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Color(0xFF245470),
      child: Icon(Icons.sms_outlined),
    );
  }
}
