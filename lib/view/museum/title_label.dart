import 'package:flutter/material.dart';

class TitleLabel extends StatelessWidget {
  final String title;
  const TitleLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('images/title_label.png'), fit: BoxFit.fill)),
      child: Center(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),)),
    );
  }
}
