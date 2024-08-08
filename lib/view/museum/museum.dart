import 'package:flutter/material.dart';
import 'package:stable_gallery/view/museum/frame_picture.dart';
import 'package:stable_gallery/view/museum/title_label.dart';

class Museum extends StatelessWidget {
  final String title;
  final List<String>? driveIds;
  const Museum({super.key, required this.title, required this.driveIds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: driveIds!.isEmpty
          ? const Center(
              child: Text(
              "画像はありません",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ))
          : SingleChildScrollView(
              child: Column(children: [
              TitleLabel(title: title),
              const Padding(padding: EdgeInsets.only(top: 30)),
              for (var driveId in driveIds ?? [])
                Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: FramePicture(driveId: driveId)),
            ])),
      backgroundColor: Colors.white.withOpacity(0.5),
    );
  }
}
