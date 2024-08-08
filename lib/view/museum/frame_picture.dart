import 'package:flutter/material.dart';

class FramePicture extends StatelessWidget {
  final String driveId;
  const FramePicture({super.key, required this.driveId});

  String getDriveUrl(String driveId) {
    return 'https://drive.google.com/uc?export=view&id=$driveId';
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Stack(alignment: Alignment.center, children: [
        Image.asset(
          'images/frame_background.png',
          width: 200,
          height: 350,
          fit: BoxFit.fill,
        ),
        const Text("読み込み中...", style: TextStyle(fontWeight: FontWeight.w900),),
        Image.network(
          getDriveUrl(driveId),
          width: 150,
          height: 300,
        ),
      ])
    ]);
  }
}
