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

// class WindDirection {
//   late Map<String, String> directions;

//   WindDirection() {
//     loadDirections();
//   }

//   Future<void> loadDirections() async {
//     String jsonString = await rootBundle
//         .loadString('assets/json/ordinal_directions_paths.json');
//     directions = Map<String, String>.from(jsonDecode(jsonString));
//   }

//   String getWindDirectionImage(String direction) {
//     return directions[direction] ?? "assets/images/wind/North.png";
//   }
// }


// class WindDirection {
//   final Map<String, String> directions = {
//     "N": "assets/images/wind/North.png",
//     "NNE": "assets/images/wind/NorthNorthEast.png",
//     "NE": "assets/images/wind/NorthEast.png",
//     "ENE": "assets/images/wind/EastNorthEast.png",
//     "E": "assets/images/wind/East.png",
//     "ESE": "assets/images/wind/EastSouthEast.png",
//     "SE": "assets/images/wind/SouthEast.png",
//     "SSE": "assets/images/wind/SouthSouthEast.png",
//     "S": "assets/images/wind/South.png",
//     "SSW": "assets/images/wind/SouthSouthWest.png",
//     "SW": "assets/images/wind/SouthWest.png",
//     "W": "assets/images/wind/West.png",
//     "WSW": "assets/images/wind/WestSouthWest.png",
//     "NW": "assets/images/wind/NorthWest.png",
//     "NNW": "assets/images/wind/NorthNorthWest.png",
//   };

//   String getWindDirectionImage(String direction) {
//     return directions[direction] ?? "assets/images/wind/North.png";
//   }
// }
