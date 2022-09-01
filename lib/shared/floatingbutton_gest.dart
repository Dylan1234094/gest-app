// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gest_app/shared/chat_gest.dart';

class FloatingButtonGest extends StatelessWidget {
  const FloatingButtonGest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return ChatGest(
            friendName: 'Obstetra',
            friendUid: 'lqI9YzdRukhichXsHfx79hXxixu1',
          );
        }));
      },
      backgroundColor: Color(0xFF245470),
      child: Icon(Icons.sms_outlined),
    );
  }
}
