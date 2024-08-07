import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

class RandomView extends StatefulWidget {
  const RandomView({super.key});

  @override
  State<RandomView> createState() => _RandomViewState();
}

class _RandomViewState extends State<RandomView> {
  List<String> pathList = [];
  String path = '';
  bool isLoading = true;

  Future<void> getImages() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Picture').get();
      setState(() {
        pathList = snapshot.docs.map<String>((DocumentSnapshot document) {
          final documentData = document.data()! as Map<String, dynamic>;
          return documentData['path'];
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getRandomImagePath() {
    final random = Random();
    try {
      int randomIndex = 0;
      randomIndex = random.nextInt(pathList.length);
      setState(() {
        path = pathList[randomIndex];
      });
      isLoading = false;
    } catch (e) {
      isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getImages();
    ShakeDetector.autoStart(
      onPhoneShake: () {
        getRandomImagePath();
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 500,
      shakeThresholdGravity: 1.3,
    );
  }

  @override
  Widget build(BuildContext context) {
    getRandomImagePath();
    return Scaffold(
        body: isLoading || path.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(path),
                  fit: BoxFit.cover,
                )),
                child: const Center(),
              ));
  }
}
