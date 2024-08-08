import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stable_gallery/view/museum/museum.dart';
import 'constants/categories.dart';

class MuseumView extends StatefulWidget {
  const MuseumView({super.key});

  @override
  State<MuseumView> createState() => _MuseumViewState();
}

class _MuseumViewState extends State<MuseumView> {
  Map<String, List<String>> classifiedPathLists = {
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
    List<String> pathList = await FirebaseFirestore.instance
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
      classifiedPathLists[category] = pathList;
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
      isLoading = false;
    } catch (e) {
      isLoading = false;
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
                Museum(title: categoryTitles['museum'].toString(), driveIds: classifiedPathLists['museum']),
                Museum(title: categoryTitles['music'].toString(), driveIds: classifiedPathLists['music']),
                Museum(title: categoryTitles['restaurant'].toString(), driveIds: classifiedPathLists['restaurant']),
                Museum(title: categoryTitles['smartphone'].toString(), driveIds: classifiedPathLists['smartphone']),
                Museum(title: categoryTitles['study'].toString(), driveIds: classifiedPathLists['study']),
                Museum(title: categoryTitles['train'].toString(), driveIds: classifiedPathLists['train']),
                Museum(title: categoryTitles['other'].toString(), driveIds: classifiedPathLists['other']),
              ]),
            ),
          );
  }
}
