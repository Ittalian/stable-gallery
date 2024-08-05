import 'package:flutter/material.dart';
import 'package:stable_gallery/models/images.dart';
import 'package:stable_gallery/models/navigation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String imagePath = Images().getHomeImagePath();
  String randomText = "ランダム";
  String museumText = "美術館";
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
            backgroundColor: Colors.white.withOpacity(0),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () => const Navigation().moveHomePage,
                    icon: const Icon(Icons.roundabout_right_outlined),
                    label: Text(
                      randomText,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ))),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.museum),
                    onPressed: () => const Navigation().moveHomePage,
                    label: Text(
                      museumText,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    )))
              ],
            )));
  }
}
