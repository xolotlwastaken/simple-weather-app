import 'dart:convert';

import 'package:coffee_card/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/3.0/onecall?';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(double lat, long) async {
    final response = await http.get(
      Uri.parse(
          '$BASE_URL?lat=$lat&long=$long&exclude=minutely,hourly,daily&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Failed to load weather. Please try again later.');
    }
  }

  Future<List<double>> getCoordinates() async {
    // get permissions from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // fetch current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return [position.latitude, position.longitude];
  }

  Future<String?> convertToCity(double long, lat) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    String? city = placemarks[0].locality;
    return city;
  }
}
