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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: () => const Navigation().moveRandomView(context),
                      icon: const Icon(Icons.roundabout_right_outlined),
                      label: Text(
                        randomText,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                        iconColor: Colors.black,
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                        icon: const Icon(Icons.museum),
                        onPressed: () => const Navigation().moveMuseumView(context),
                        label: Text(
                          museumText,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[400],
                          iconColor: Colors.black,
                        ),))
              ],
            )));
  }
}
