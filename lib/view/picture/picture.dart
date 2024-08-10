import 'package:flutter/material.dart';

class Picture extends StatelessWidget {
  final String driveId;
  const Picture({super.key, required this.driveId});

  String getDriveUrl(String driveId) {
    return 'https://drive.google.com/uc?export=view&id=$driveId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
              tag: driveId,
              child: Image.network(getDriveUrl(driveId), fit: BoxFit.contain)),
        ),
      ),
    );
  }
}
