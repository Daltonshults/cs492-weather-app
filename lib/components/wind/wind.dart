class WindDirection {
  final Map<String, String> directions = {
    "N": "assets/images/wind/north.png",
    "NE": "assets/images/wind/northeast.png",
    "E": "assets/images/wind/east.png",
    "SE": "assets/images/wind/southeast.png",
    "S": "assets/images/wind/south.png",
    "SW": "assets/images/wind/southwest.png",
    "W": "assets/images/wind/west.png",
    "NW": "assets/images/wind/northwest.png"
  };

  String getWindDirectionImage(String direction) {
    return directions[direction] ?? "assets/images/wind/north.png";
  }
}
