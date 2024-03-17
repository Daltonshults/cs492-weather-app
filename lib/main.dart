import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'components/location/location.dart';
import 'package:flutter/material.dart';
import 'models/user_location.dart';
import 'components/weatherScreen/weather_screen.dart';

import 'models/weather_forecast.dart';
import 'package:shared_preferences/shared_preferences.dart';

const sqlCreateDatabase = 'assets/sql/create.sql';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    const String title = "Ds Weather App";
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: _notifier,
        builder: (_, mode, __) {
          return MaterialApp(
            title: title,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: mode,
            home: MyHomePage(title: title, notifier: _notifier),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final ValueNotifier<ThemeMode> notifier;
  const MyHomePage({super.key, required this.title, required this.notifier});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserLocation> locations = [];
  List<WeatherForecast> _forecasts = [];
  List<WeatherForecast> _forecastsHourly = [];
  UserLocation? _location;
  int _selectedIndex = 0;

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void backHome() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  void setLocation(UserLocation location) async {
    setState(() {
      _location = location;
      _getForecasts();
      _setLocationPref(location);
    });
  }

  void _setLocationPref(UserLocation location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("location", location.toJsonString());
  }

  void _getForecasts() async {
    if (_location != null) {
      // We collect both the twice-daily forecasts and the hourly forecasts
      List<WeatherForecast> forecasts =
          await getWeatherForecasts(_location!, false);
      List<WeatherForecast> forecastsHourly =
          await getWeatherForecasts(_location!, true);
      setState(() {
        _forecasts = forecasts;
        _forecastsHourly = forecastsHourly;
      });
    }
  }

  List<WeatherForecast> getForecasts() {
    return _forecasts;
  }

  List<WeatherForecast> getForecastsHourly() {
    return _forecastsHourly;
  }

  UserLocation? getLocation() {
    return _location;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  bool _light = true;

  @override
  void initState() {
    super.initState();
    _light = widget.notifier.value == ThemeMode.light;

    _initMode();
  }

  void _initMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? light = prefs.getBool("light");
    String? locationString = prefs.getString("location");

    if (light != null) {
      setState(() {
        _light = light;
        _setTheme(_light);
      });
    }

    if (locationString != null) {
      setLocation(UserLocation.fromJson(jsonDecode(locationString)));
    }
  }

  void _toggleLight(value) async {
    setState(() {
      _light = value;
      _setTheme(value);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("light", value);
  }

  void _setTheme(value) {
    widget.notifier.value = value ? ThemeMode.light : ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      WeatherScreen(
          getLocation: getLocation,
          getForecasts: getForecasts,
          getForecastsHourly: getForecastsHourly,
          setLocation: setLocation),
      locationPage(),
    ];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Open Settings',
            onPressed: _openEndDrawer,
          )
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      endDrawer: Drawer(
        child: modeToggle(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Selected Location"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), label: "Change Location"),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        onTap: _onTapped,
      ),
    );
  }

  SizedBox modeToggle() {
    return SizedBox(
      width: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_light ? "Light Mode" : "Dark Mode",
              style: Theme.of(context).textTheme.labelLarge),
          Transform.scale(
            scale: 0.5,
            child: Switch(
              value: _light,
              onChanged: _toggleLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget locationPage() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SettingsHeaderText(context: context, text: "Settings:"),
            // modeToggle(),
            SettingsHeaderText(context: context, text: "My Locations:"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Location(
                setLocation: setLocation,
                getLocation: getLocation,
                backHome: backHome,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsHeaderText extends StatelessWidget {
  final String text;
  final BuildContext context;
  const SettingsHeaderText(
      {super.key, required this.context, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
