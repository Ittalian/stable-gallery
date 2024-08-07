import 'dart:async';
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
  int shakeCount = 0;
  int backCount = 0;
  Timer? timer;
  bool isShakeCountFinished = false;
  Map<String, String> mode = {
    'init': 'init',
    'next': 'next',
    'back': 'back',
  };
  List<String> sessionPath = [];

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

  void getRandomImagePath(String changeMode) {
    final random = Random();
    int randomIndex = 0;
    try {
      randomIndex = random.nextInt(pathList.length);
      switch (changeMode) {
        case "init":
          sessionPath.insert(0, pathList[randomIndex]);
          setState(() {
            path = sessionPath[0];
          });
          break;
        case "next":
          pathList.remove(sessionPath[0]);
          setState(() {
            backCount = 0;
            path = pathList[(randomIndex - 1).abs()];
          });
          pathList.add(sessionPath[0]);
          sessionPath.insert(0, path);
          break;
        case "back":
          setState(() {
            backCount++;
            path = sessionPath[2 * backCount - 1];
          });
          sessionPath.insert(0, path);
          break;
        default:
      }
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
        setState(() {
          isShakeCountFinished = true;
          shakeCount++;
        });
        timer?.cancel();
        timer = Timer(const Duration(seconds: 1), () {
          if (shakeCount > 1) {
            getRandomImagePath(mode['back'].toString());
          } else {
            getRandomImagePath(mode['next'].toString());
          }
          setState(() {
            shakeCount = 0;
          });
        });
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeThresholdGravity: 1.3,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isShakeCountFinished) {
      getRandomImagePath(mode['init'].toString());
    }
    return Scaffold(
      body: isLoading || path.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(path),
                fit: BoxFit.cover,
              )),
              child: Center(
                  child: shakeCount > 0
                      ? Text(
                          shakeCount.toString(),
                          style: const TextStyle(
                            fontSize: 50,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container()),
            ),
    );
  }
}
