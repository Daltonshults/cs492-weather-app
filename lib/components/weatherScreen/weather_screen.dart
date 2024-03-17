import 'package:cs492_weather_app/models/weather_forecast.dart';
import 'package:flutter/widgets.dart';
import '../../models/user_location.dart';
import 'package:flutter/material.dart';
import '../location/location.dart';
import '../shortforecast/short_forecast.dart';

class WeatherScreen extends StatefulWidget {
  final Function getLocation;
  final Function getForecasts;
  final Function getForecastsHourly;
  final Function setLocation;

  const WeatherScreen(
      {super.key,
      required this.getLocation,
      required this.getForecasts,
      required this.getForecastsHourly,
      required this.setLocation});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController()
      ..addListener(() {
        setState(() {
          _currentPage = _controller.page!.round();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.getLocation() != null && widget.getForecasts().isNotEmpty
        ? Container(
            color: Theme.of(context).colorScheme.inversePrimary,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                  child: title(),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    children: [
                      ForecastWidget(
                        context: context,
                        location: widget.getLocation(),
                        forecasts: widget.getForecastsHourly(),
                      ),
                      ForecastWidget(
                        context: context,
                        location: widget.getLocation(),
                        forecasts: widget.getForecasts(),
                      ),
                    ],
                  ),
                ),
                pageIndicator(),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator()));
  }

  Widget title() {
    return Text(
      _currentPage == 0 ? "Hourly" : "Twice Daily",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Row pageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        2,
        (int index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(4.0),
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
      ),
    );
  }
}

class ForecastWidget extends StatelessWidget {
  final UserLocation location;
  final List<WeatherForecast> forecasts;
  final BuildContext context;

  const ForecastWidget(
      {super.key,
      required this.context,
      required this.location,
      required this.forecasts});

  @override
  Widget build(BuildContext context) {
    var isLandscape = MediaQuery.of(context).size.width > 400;

    return isLandscape ? landscape(context) : portrait(context);
  }

  Row landscape(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CombinedForecastWidget(
              context: context, location: location, forecasts: forecasts),
        ),
        Expanded(
          flex: 3,
          child: ListView(
              children: forecasts
                  .take(24)
                  .map((forecast) => ShortForecasts(forecast: forecast))
                  .toList()),
        ),
      ],
    );
  }

  Column portrait(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: CombinedForecastWidget(
              context: context, location: location, forecasts: forecasts),
        ),
        Expanded(
          flex: 7,
          child: ListView(
              children: forecasts
                  .take(23)
                  .map((forecast) => ShortForecasts(forecast: forecast))
                  .toList()),
        ),
      ],
    );
  }
}

class CombinedForecastWidget extends StatelessWidget {
  final UserLocation location;
  final List<WeatherForecast> forecasts;
  final BuildContext context;

  const CombinedForecastWidget(
      {super.key,
      required this.context,
      required this.location,
      required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).colorScheme.onPrimary,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LocationTextWidget(location: location),
          TemperatureWidget(forecasts: forecasts),
          DescriptionWidget(forecasts: forecasts),
        ],
      ),
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
    required this.forecasts,
  });

  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(forecasts.elementAt(0).shortForecast,
            style: Theme.of(context).textTheme.bodyMedium));
  }
}

class TemperatureWidget extends StatelessWidget {
  const TemperatureWidget({super.key, required this.forecasts});

  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    int? min;
    int? max;
    if (forecasts.length - 1 > 24) {
      min = 1000;
      max = -1000;
      for (var i = 0; i < 24; i++) {
        if (min == null || forecasts.elementAt(i).temperature < min) {
          min = forecasts.elementAt(i).temperature;
        }
        if (max == null || forecasts.elementAt(i).temperature > max) {
          max = forecasts.elementAt(i).temperature;
        }
      }
    }
    return Center(
      child: Text(
        max != null && min != null
            ? '  $max/$minºF'
            : '${forecasts.elementAt(0).temperature}ºF',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

class LocationTextWidget extends StatelessWidget {
  const LocationTextWidget({
    super.key,
    required this.location,
  });

  final UserLocation location;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "${location.city}, ${location.state}, ${location.zip}",
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    super.key,
    required this.widget,
  });

  final WeatherScreen widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .5,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Requires a location to begin"),
          ),
          Location(
              setLocation: widget.setLocation, getLocation: widget.getLocation),
        ],
      ),
    );
  }
}
