import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:stable_gallery/models/message.dart';
import 'package:stable_gallery/models/navigation.dart';
import 'package:stable_gallery/view/constants/categories.dart';
import 'package:stable_gallery/view/constants/inform_message.dart';

class RandomView extends StatefulWidget {
  const RandomView({super.key});

  @override
  State<RandomView> createState() => _RandomViewState();
}

class _RandomViewState extends State<RandomView> {
  List<Map<String, dynamic>> imageInfoList = [];
  Map<String, dynamic> imageInfo = {
    'drive_id': '',
    'app_name': '',
    'category': '',
  };
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
  List<Map<String, dynamic>> sessionimageInfoList = [];
  final ValueNotifier<String> appNameDetailNotifier = ValueNotifier<String>("");
  final ValueNotifier<String> categoryDetailNotifier =
      ValueNotifier<String>("");

  Future<void> getImages() async {
    try {
      QuerySnapshot pictureSnapshot =
          await FirebaseFirestore.instance.collection('Picture').get();
      List<Map<String, dynamic>> resultList = [];
      for (var document in pictureSnapshot.docs) {
        final documentData = document.data()! as Map<String, dynamic>;
        final String driveId = documentData['drive_id'];
        final String usedAppId = documentData['used_app_id'];
        final String categoryId = documentData['category_id'];

        DocumentSnapshot categorySnapshot = await FirebaseFirestore.instance
            .collection('Category')
            .doc(categoryId)
            .get();

        final categoryData = categorySnapshot.data()! as Map<String, dynamic>;
        final String category = categoryData['name'];

        if (usedAppId.isEmpty) {
          resultList.add({
            'drive_id': driveId,
            'app_name': "なし",
            'category': category,
          });
          continue;
        }

        DocumentSnapshot usedAppSnapshot = await FirebaseFirestore.instance
            .collection('UsedApp')
            .doc(usedAppId)
            .get();

        final usedAppData = usedAppSnapshot.data()! as Map<String, dynamic>;
        final String appName = usedAppData['name'];

        resultList.add({
          'drive_id': driveId,
          'app_name': appName,
          'category': category,
        });
      }
      setState(() {
        imageInfoList = resultList;
        isLoading = false;
      });
    } catch (e) {
      Message(message: errorMessage['databaseError'].toString())
          .informAction(context);
      const Navigation().moveHomePage(context);
    }
  }

  void getRandomImagedriveId(String changeMode) {
    final random = Random();
    int randomIndex = 0;
    if (!isLoading) {
      try {
        randomIndex = random.nextInt(imageInfoList.length);
        switch (changeMode) {
          case "init":
            sessionimageInfoList.insert(0, imageInfoList[randomIndex]);
            setState(() {
              imageInfo = sessionimageInfoList[0];
            });
            break;
          case "next":
            imageInfoList.remove(sessionimageInfoList[0]);
            setState(() {
              backCount = 0;
              imageInfo = imageInfoList[(randomIndex - 1).abs()];
            });
            imageInfoList.add(sessionimageInfoList[0]);
            sessionimageInfoList.insert(0, imageInfo);
            break;
          case "back":
            setState(() {
              backCount++;
              imageInfo = sessionimageInfoList[2 * backCount - 1];
            });
            sessionimageInfoList.insert(0, imageInfo);
            break;
          default:
        }
      } catch (e) {
        Message(message: errorMessage['driveError'].toString())
            .informAction(context);
        const Navigation().moveHomePage(context);
      }
    }
  }

  String getDriveUrl(String driveId) {
    return 'https://drive.google.com/uc?export=view&id=$driveId';
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
            getRandomImagedriveId(mode['back'].toString());
          } else {
            getRandomImagedriveId(mode['next'].toString());
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
      getRandomImagedriveId(mode['init'].toString());
    }
    return Scaffold(
      body: isLoading || imageInfo.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : InteractiveViewer(
              maxScale: 3.5,
              child: GestureDetector(
                  onTapDown: (_) {
                    categoryDetailNotifier.value =
                        'カテゴリ: ${categoryTitles[imageInfo['category']]}';
                    appNameDetailNotifier.value =
                        '使用アプリ: ${imageInfo['app_name']}';
                  },
                  onTapUp: (_) {
                    appNameDetailNotifier.value = '';
                    categoryDetailNotifier.value = '';
                  },
                  onTapCancel: () {
                    appNameDetailNotifier.value = '';
                    categoryDetailNotifier.value = '';
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(getDriveUrl(imageInfo['drive_id'])),
                      fit: BoxFit.cover,
                    )),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
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
                          ValueListenableBuilder(
                            valueListenable: categoryDetailNotifier,
                            builder: (context, value, child) {
                              return Text(
                                value,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: appNameDetailNotifier,
                            builder: (context, value, child) {
                              return Text(
                                value,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              );
                            },
                          ),
                        ]),
                  ))),
    );
  }
}
