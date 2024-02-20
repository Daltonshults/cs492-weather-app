import 'components/location/location.dart';
import 'package:flutter/material.dart';
import 'models/user_location.dart';
import 'components/weatherScreen/weather_screen.dart';
import 'models/weather_forecast.dart';
// don't remove this, you'll need it today
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This is the value Notifier
  // This is specifically for a theme mode as indicated by <ThemeMode>.
  // the value ThemeMode.light is the default value
  // TODO #1: Try changing this to ThemeMode.dark to see what happens when you restart the app.
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    // We are now returning the Material App wrapped in  ValueListenable Builder
    // This builder allows us to refresh the material app when the _notifier.value changes
    // MaterialApp's themeMode parameter dictates which theme mode is used.
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: _notifier,
        // if you mouse over each of these parameters being passed as a builder
        // you'll see the first is the context, the second is the mode, the third is Widget
        // We only need to track the mode in the ValueListenerBuilder
        // so the other two are left as _ and __
        builder: (_, mode, __) {
          return MaterialApp(
            title: 'CS 492 Weather App',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            // By default, themeMode is using mode, which is passed in from the builder
            themeMode: mode,
            home: MyHomePage(title: "CS492 Weather App", notifier: _notifier),
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
  UserLocation? _location;

  void setLocation(UserLocation location) {
    setState(() {
      _location = location;
      _getForecasts();
    });
  }

  void _getForecasts() async {
    if (_location != null) {
      List<WeatherForecast> forecasts =
          await getWeatherForecasts(_location!, true);
      setState(() {
        _forecasts = forecasts;
      });
    }
  }

  List<WeatherForecast> getForecasts() {
    return _forecasts;
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
    // TODO #2: Read through this logic
    // Notice that when this widget is initialized
    // The default value for the bool _light is set to a comparison between the notifier.value and ThemeMode.light
    // This means that by default, light will be true if the notifier.value is light mode
    // and false if the notifier.value is dark mode

    _light = widget.notifier.value == ThemeMode.light;

    initMode();
  }

  void initMode() async {
    // TODO #6: Once you have completed #5, you should have saved preferences
    // For this part we should once again await shared preferences
    // Then we should use the getBool() function to get the boolean value of 'light'
    // This boolean can be null, so be sure to use bool? to allow for null
    // Finally, be sure to check if that value is null before setting _light to equal it
    // Additionallyy, you will need to use the setState(() {}) function when you set _light
    // You'll also need to use the same line of code you used for todo #4 to update the value of the notifier

    // Test your function by changing the mode and restarting the app.
    // if it restarted in the same mode you left it in, then you succeeded!

    // TODO Final Challenge:
    // If you made it this far, I think you're ready for a final challenge.
    // For this, your goal is to save the active location to preferences and get it from preferences when the app starts
    // To accomplish this, you'll need to add a function to the userLoction class which will return the properties as a json object
    // you can use jsonEncode(jsonData) to convert this to a string.
    // once this is a string you can use the prefs setString to save a string value

    // to undo this, you'll need to getString, jsonDecode, and then create a factory in userLocation to re-create the location object
  }

  void _toggleLight(value) async {
    setState(() {
      _light = value;

      // TODO #4: Be sure to read through TODO #3 below before starting this
      //  Create logic that will set the widget.notifier.value to ThemeMode.light if light is true,
      //  and ThemeMode.dark if light is false.
      // Test to make sure your toggle works before moving on
    });

    // TODO #5:
    // Next we are going to add the boolean value of light to our shared preferences.
    // This will allow the app to remember the preference of the user and use that setting when the app loads.
    // Look through the shared_preferences flutter documentation to see how to write and read preference data
    // https://pub.dev/packages/shared_preferences

    // create a SharedPreferences variable which awaits SharedPreferences.getInstance().
    // use the setBool to set a boolean for 'light': value (this will make sense when you read the documentation)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
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
      body: WeatherScreen(
          getLocation: getLocation,
          getForecasts: getForecasts,
          setLocation: setLocation,
          locations: locations),
      endDrawer: Drawer(
        child: settingsDrawer(),
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
            // TODO #3: read through the code for the Switch()
            // This is the Switch. It will change when tapped
            // The value for the Switch is whatever the value of the boolean variable light is
            // When you toggle the switch, it triggers the onChanged logic, which called _toggleLight
            // Move back up to the _toggleLight function and add the required code for the todo.
            child: Switch(
              value: _light,
              onChanged: _toggleLight,
            ),
          ),
        ],
      ),
    );
  }

  SafeArea settingsDrawer() {
    return SafeArea(
      child: Column(
        children: [
          SettingsHeaderText(context: context, text: "Settings:"),
          modeToggle(),
          SettingsHeaderText(context: context, text: "My Locations:"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Location(
                setLocation: setLocation,
                getLocation: getLocation,
                locations: locations),
          ),
          ElevatedButton(
              onPressed: _closeEndDrawer, child: const Text("Close Settings"))
        ],
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
