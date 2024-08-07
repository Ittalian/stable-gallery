import 'package:flutter/material.dart';

class Navigation {
  const Navigation();

  void moveHomePage(BuildContext context) {
    Navigator.pushNamed(context, '/');
  }

  void moveRandomView(BuildContext context) {
    Navigator.pushNamed(context, '/random');
  }

  void moveMuseumView(BuildContext context) {
    Navigator.pushNamed(context, '/museum');
  }
}
