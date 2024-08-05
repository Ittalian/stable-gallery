import 'package:flutter/material.dart';

class Navigation {
  const Navigation();

  void moveHomePage(BuildContext context) {
    Navigator.pushNamed(context, '/');
  }
}
