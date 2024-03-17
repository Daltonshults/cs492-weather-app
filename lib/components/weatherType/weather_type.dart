// class WeatherType {
//   final Map<String, String> directions = {
//     "Sunny":
//   };

//   String getWindDirectionImage(String direction) {
//     return directions[direction] ?? "assets/images/wind/north.png";
//   }
// }
class WeatherType {
  final Map<String, String> weatherTypes = {
    "Sunny": "assets/images/weather/sunny.png",
    "Mostly Sunny": "assets/images/weather/mostly_sunny.png",
    "Partly Sunny": "assets/images/weather/partly_sunny.png",
    "Mostly Cloudy": "assets/images/weather/mostly_cloudy.png",
    "Cloudy": "assets/images/weather/cloudy.png",
    "Rain": "assets/images/weather/rain.png",
    "Showers": "assets/images/weather/showers.png",
    "Thunderstorms": "assets/images/weather/thunderstorms.png",
    "Snow": "assets/images/weather/snow.png",
    "Fog": "assets/images/weather/fog.png",
  };
}
