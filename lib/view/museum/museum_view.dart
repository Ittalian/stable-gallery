import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stable_gallery/models/message.dart';
import 'package:stable_gallery/models/navigation.dart';
import 'package:stable_gallery/view/constants/inform_message.dart';
import 'package:stable_gallery/view/museum/museum.dart';

class MuseumView extends StatefulWidget {
  const MuseumView({super.key});

  @override
  State<MuseumView> createState() => _MuseumViewState();
}

class _MuseumViewState extends State<MuseumView> {
  Map<String, List<String>> classifiedDriveIds = {};
  Map<String, String> categoryIds = {};
  Map<String, String> categoryTitles = {};
  bool isLoading = true;

  Future<void> fetchCategoriesFromFirebase() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Category').get();

    Map<String, String> tempCategoryIds = {};
    Map<String, String> tempCategoryTitles = {};

    for (var document in snapshot.docs) {
      final data = document.data() as Map<String, dynamic>;
      String categoryValue = data['value'] as String;

      tempCategoryIds[categoryValue] = document.id;
      tempCategoryTitles[categoryValue] = categoryValue;
    }

    setState(() {
      categoryIds = tempCategoryIds;
      categoryTitles = tempCategoryTitles;
    });
  }

  Future<void> getCategoryPath(String category) async {
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
      classifiedDriveIds[category] = driveIds;
    });
  }

  Future<void> classifyCategory() async {
    try {
      await fetchCategoriesFromFirebase();
      for (var category in categoryIds.keys) {
        await getCategoryPath(category);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
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
              child: PageView(
                children: categoryIds.keys.map((category) {
                  return Museum(
                    title: categoryTitles[category] ?? '',
                    driveIds: classifiedDriveIds[category] ?? [],
                  );
                }).toList(),
              ),
            ),
          );
  }
}
