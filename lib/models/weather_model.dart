class Weather {
  final String lat;
  final String long;
  final double temperature;
  final String mainCondition;
  final int weatherId;

  Weather({
    required this.lat,
    required this.long,
    required this.temperature,
    required this.mainCondition,
    required this.weatherId,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      lat: json['lat'],
      long: json['long'],
      temperature: json['current']['temp'],
      mainCondition: json['current']['weather'][0]['main'],
      weatherId: json['current']['weather'][0]['id'],
    );
  }
}
