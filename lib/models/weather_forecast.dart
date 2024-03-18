import 'dart:convert';

import './user_location.dart';
import 'package:http/http.dart' as http;

class WeatherForecast {
  final String name;
  final bool isDaytime;
  final int temperature;
  final String windSpeed;
  final String windDirection;
  final String shortForecast;
  final String detailedForecast;
  final String startTime;
  final String endTime;
  final String icon;

  const WeatherForecast({
    required this.name,
    required this.isDaytime,
    required this.temperature,
    required this.windSpeed,
    required this.windDirection,
    required this.shortForecast,
    required this.detailedForecast,
    required this.startTime,
    required this.endTime,
    required this.icon,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'isDaytime': bool isDaytime,
        'temperature': int temperature,
        'windSpeed': String windSpeed,
        'windDirection': String windDirection,
        'shortForecast': String shortForecast,
        'detailedForecast': String detailedForecast,
        'startTime': String startTime,
        'endTime': String endTime,
        'icon': String icon,
      } =>
        WeatherForecast(
          name: name,
          isDaytime: isDaytime,
          temperature: temperature,
          windSpeed: windSpeed,
          windDirection: windDirection,
          shortForecast: shortForecast,
          detailedForecast: detailedForecast,
          startTime: startTime,
          endTime: endTime,
          icon: icon,
        ),
      _ => throw const FormatException('Failed to load Weather Forecast.'),
    };
  }
}

Future<List<WeatherForecast>> getHourlyForecasts(UserLocation location) async {
  return getWeatherForecasts(location, true);
}

Future<List<WeatherForecast>> getTwiceDailyForecasts(
    UserLocation location) async {
  return getWeatherForecasts(location, false);
}

Future<List<WeatherForecast>> getWeatherForecasts(
    UserLocation location, bool hourly) async {
  // casts latitude and longitude to strings with 2 fixed digits
  // for example: 123.456789 -> '123.45'
  String lat = location.latitude.toStringAsFixed(2);
  String long = location.longitude.toStringAsFixed(2);

  // send a request to the weather api to get forecast details
  String forecastUrl = "https://api.weather.gov/points/$lat,$long";
  http.Response forecastResponse =
      await http.get(Uri.parse(forecastUrl), headers: {
    'Cache-Control': 'no-cache',
    'Pragma': 'no-cache',
  });
  final Map<String, dynamic> forecastJson = jsonDecode(forecastResponse.body);

  // grabs the forecasts url from the json response
  final String currentForecastsUrl = hourly
      ? forecastJson["properties"]["forecastHourly"]
      : forecastJson["properties"]["forecast"];
  print("currentForecastsUrl: $currentForecastsUrl");
  // send another request to the API which will return the specifics of the twice-daily forecasts
  http.Response currentForecastsResponse =
      await http.get(Uri.parse(currentForecastsUrl), headers: {
    'Cache-Control': 'no-cache',
    'Pragma': 'no-cache',
  });

  final Map<String, dynamic> currentForecastsJson =
      jsonDecode(currentForecastsResponse.body);

  // gets the list of forecasts from the forecast request
  List<dynamic> forecastJsons = currentForecastsJson["properties"]["periods"];

  // uses json data to create list of WeatherForecast objects
  List<WeatherForecast> forecasts = [];
  for (final forecastJson in forecastJsons) {
    forecasts.add(WeatherForecast.fromJson(forecastJson));
  }

  return forecasts;
}
