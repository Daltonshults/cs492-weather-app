import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/weather_forecast.dart';
import '../wind/wind.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ShortForecasts extends StatelessWidget {
  final WeatherForecast forecast;
  final WindDirection windDirection = WindDirection();

  ShortForecasts({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    DateTime startTime = DateTime.parse(forecast.startTime);
    String formattedStartTime = DateFormat.jm().format(startTime);
    DateTime endTime = DateTime.parse(forecast.endTime);
    String formattedEndTime = DateFormat.jm().format(endTime);
    //DateTime date = DateTime.parse(forecast.startTime);
    String formattedDate = DateFormat('MM/dd/yy').format(startTime);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
            width: 2,
          ),
        ),
      ),
      child: ListTile(
        subtitle: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              topRow(context),
              bottomRow(formattedStartTime, formattedEndTime, formattedDate),
            ],
          ),
        ),
      ),
    );
  }

  String getWeatherDescriptor(String url) {
    String splitUrl1 = url.split(",")[0];
    splitUrl1 = splitUrl1.split("?")[0];
    List<String> urlList = splitUrl1.split("/");
    String splitUrl2 = urlList[urlList.length - 1];
    return splitUrl2;
  }

  Future<String> getLocalImagePath(String weatherState) async {
    String jsonString =
        await rootBundle.loadString('assets/json/weather_state.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return jsonData[weatherState];
  }

  Row topRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: FutureBuilder<String>(
              future: getLocalImagePath(getWeatherDescriptor(forecast.icon)),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: imageBoxWeather(context, snapshot.data!),
                  );
                }
              },
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<String>(
            future: windDirection.getWindDirectionImage(forecast.windDirection),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: imageBoxArrow(context, snapshot.data!)),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Row bottomRow(String formattedStartTime, String formattedEndTime,
      String formattedDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        forecastAndTime(formattedStartTime, formattedEndTime, formattedDate),
        wind(),
      ],
    );
  }

  Widget imageBoxArrow(BuildContext context, String path) {
    return Image(
      image: AssetImage(path),
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  Widget imageBoxWeather(BuildContext context, String imagePath) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.1,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget forecastAndTime(String formattedStartTime, String formattedEndTime,
      String formattedDate) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(forecast.shortForecast),
              Text("$formattedStartTime-$formattedEndTime"),
              Text(formattedDate),
            ],
          ),
        ],
      ),
    );
  }

  Column wind() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("${forecast.temperature}ºF"),
        Text(forecast.windSpeed),
        Text(forecast.windDirection),
      ],
    );
  }
}
