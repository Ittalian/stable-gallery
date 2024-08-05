import 'dart:math';

class Images {
  Images();
  List<String> homeImagePathes = [
    "images/home_background.png",
  ];

  String getHomeImagePath() {
    return getImagePath(homeImagePathes);
  }

  String getImagePath(List<String> imagePathes) {
    final random = Random();
    int randomIndex = random.nextInt(imagePathes.length);
    return imagePathes[randomIndex];
  }
}
