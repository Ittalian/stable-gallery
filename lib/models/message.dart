import 'package:flutter/material.dart';

class Message {
  final String message;
  const Message({required this.message});

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> informAction(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    ));
  }
}
