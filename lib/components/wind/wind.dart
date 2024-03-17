import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class WindDirection {
  late Future<Map<String, String>> directions;

  WindDirection() {
    directions = loadDirections();
  }

  Future<Map<String, String>> loadDirections() async {
    String jsonString = await rootBundle
        .loadString('assets/json/ordinal_directions_paths.json');
    return Map<String, String>.from(jsonDecode(jsonString));
  }

  Future<String> getWindDirectionImage(String direction) async {
    Map<String, String> dirs = await directions;
    return dirs[direction] ?? "assets/images/wind/North.png";
  }
}
