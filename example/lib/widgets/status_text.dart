import 'package:flutter/material.dart';

class StatusText extends StatelessWidget {
  final String text;
  const StatusText({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin:const EdgeInsets.only(top:40,bottom: 20),
        width: double.infinity,
        child: Text(
          text,
          style:const TextStyle(color: Colors.green,fontSize: 24,fontWeight:FontWeight.bold),
          textAlign: TextAlign.center,
        ));
  }
}
