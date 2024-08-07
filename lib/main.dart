import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stable_gallery/config/firebase_options.dart';
import 'package:stable_gallery/view/home/home.dart';
import 'package:stable_gallery/view/museum/museum_view.dart';
import 'package:stable_gallery/view/random/random_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StableGallery());
}

class StableGallery extends StatelessWidget {
  const StableGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/random': (context) => const RandomView(),
        '/museum': (context) => const MuseumView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
