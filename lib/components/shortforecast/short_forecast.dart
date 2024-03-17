import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/weather_forecast.dart';
import '../wind/wind.dart';

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
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
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

  Row topRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.network(forecast.icon.split(",")[0]),
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
                      child: imageBox(context, snapshot.data!)),
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

  Widget imageBox(BuildContext context, String path) {
    return Image(image: AssetImage(path));
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
