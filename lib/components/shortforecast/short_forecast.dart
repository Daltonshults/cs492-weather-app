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
        border: Border(
          top: BorderSide(
            color: Theme.of(context).primaryColor,
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
        //imageBox(context, "assets/images/weather/snowy.png"),
        Image.network(forecast.icon.split(",")[0]),
        imageBox(context,
            windDirection.getWindDirectionImage(forecast.windDirection)),
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

  SizedBox imageBox(BuildContext context, String path) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Image(image: AssetImage(path)));
  }

  Column forecastAndTime(String formattedStartTime, String formattedEndTime,
      String formattedDate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${forecast.shortForecast} "),
        Text("Time: $formattedStartTime-$formattedEndTime"),
        Text("Date: $formattedDate"),
      ],
    );
  }

  Column wind() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Temperature: ${forecast.temperature}º"),
        Text("Wind: ${forecast.windSpeed}"),
        Text("Wind Direction: ${forecast.windDirection}"),
      ],
    );
  }
}
