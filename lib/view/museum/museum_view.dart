import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stable_gallery/models/message.dart';
import 'package:stable_gallery/models/navigation.dart';
import 'package:stable_gallery/view/constants/inform_message.dart';
import 'package:stable_gallery/view/museum/museum.dart';
import '../constants/category_titles.dart';
import '../constants/categories.dart';

class MuseumView extends StatefulWidget {
  const MuseumView({super.key});

  @override
  State<MuseumView> createState() => _MuseumViewState();
}

class _MuseumViewState extends State<MuseumView> {
  Map<String, List<String>> classifiedDriveIdss = {
    'museum': [],
    'music': [],
    'other': [],
    'restaurnt': [],
    'smartphone': [],
    'study': [],
    'train': [],
  };
  Map<String, String> categoryIds = {
    'museum': '',
    'music': '',
    'other': '',
    'restaurnt': '',
    'smartphone': '',
    'study': '',
    'train': '',
  };
  bool isLoading = true;

  getCategoryPath(String category) async {
    await getCategoryId(category);
    List<String> driveIds = await FirebaseFirestore.instance
        .collection('Picture')
        .where('category_id', isEqualTo: categoryIds[category])
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.docs.map<String>((DocumentSnapshot document) {
        final documentData = document.data()! as Map<String, dynamic>;
        return documentData['drive_id'];
      }).toList();
    });
    setState(() {
      classifiedDriveIdss[category] = driveIds;
    });
  }

  getCategoryId(String category) async {
    String categoryId = await FirebaseFirestore.instance
        .collection('Category')
        .where('name', isEqualTo: category)
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.docs.first.id;
    });
    setState(() {
      categoryIds[category] = categoryId;
    });
  }

  void classifyCategory() async {
    try {
      for (var category in categories) {
        await getCategoryPath(category);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Message(message: errorMessage['databaseError'].toString())
          .informAction(context);
      const Navigation().moveHomePage(context);
    }
  }

  @override
  void initState() {
    super.initState();
    classifyCategory();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/museum_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: PageView(children: [
                Museum(
                    title: categoryTitles['museum'].toString(),
                    driveIds: classifiedDriveIdss['museum']),
                Museum(
                    title: categoryTitles['music'].toString(),
                    driveIds: classifiedDriveIdss['music']),
                Museum(
                    title: categoryTitles['restaurant'].toString(),
                    driveIds: classifiedDriveIdss['restaurant']),
                Museum(
                    title: categoryTitles['smartphone'].toString(),
                    driveIds: classifiedDriveIdss['smartphone']),
                Museum(
                    title: categoryTitles['study'].toString(),
                    driveIds: classifiedDriveIdss['study']),
                Museum(
                    title: categoryTitles['train'].toString(),
                    driveIds: classifiedDriveIdss['train']),
                Museum(
                    title: categoryTitles['other'].toString(),
                    driveIds: classifiedDriveIdss['other']),
              ]),
            ),
          );
  }
}
