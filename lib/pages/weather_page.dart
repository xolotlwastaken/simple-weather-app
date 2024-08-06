import 'package:coffee_card/models/weather_model.dart';
import 'package:coffee_card/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService("591294393d42409da987e98915a187ee");
  Weather? _weather;
  late String? _cityName;

  // fetch weather
  _fetchWeather() async {
    // get the current location
    final latLongArray = await _weatherService.getCoordinates();

    // get weather for the current location
    try {
      final Weather weather =
          await _weatherService.getWeather(latLongArray[0], latLongArray[1]);
      final String? cityName =
          await _weatherService.convertToCity(latLongArray[0], latLongArray[1]);
      setState(() {
        _weather = weather;
        _cityName = cityName;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(int? weatherId) {
    if (weatherId == null) {
      return "assets\\sunny.json";
    } else if (weatherId == 800) {
      return "assets\\sunny.json";
    } else if (weatherId > 800) {
      return "assets\\cloudy.json";
    } else if (weatherId >= 300 && weatherId < 800) {
      return "assets\\rainy.json";
    } else {
      return "assets\\stormy.json";
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch the weather
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // location icon
          Icon(
            Icons.location_city,
            size: 24.0,
            color: Colors.grey[400],
          ),

          // sized box
          const SizedBox(
            height: 8,
          ),

          // city name
          Text(
            _cityName ?? "loading city...",
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),

          // sized box
          const SizedBox(
            height: 48,
          ),

          // animations
          Lottie.asset(getWeatherAnimation(_weather?.weatherId)),

          // sized box
          const SizedBox(
            height: 48,
          ),

          // temperature
          Text(
            "${_weather?.temperature.round()}°C",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 28,
            ),
          ),

          // sized box
          const SizedBox(
            height: 8,
          ),

          // weather condition
          Text(
            _weather?.mainCondition ?? "",
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
