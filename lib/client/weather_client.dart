import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:weather_bloc/model/weather.dart';

class WeatherClient {
  static const baseUrl = "https://www.metaweather.com";
  final Client httpClient;

  WeatherClient({@required this.httpClient});

  Future<int> getLocationId(String city) async {
    final locationUrl = "$baseUrl/api/location/search/?query=$city";
    final locationResponse = await this.httpClient.get(locationUrl);

    if (locationResponse.statusCode != 200)
      throw Exception("error getting locationId for city");

    final locationJson = jsonDecode(locationResponse.body) as List;

    return (locationJson.first)["woeid"];
  }

  Future<Weather> fetchWeather(int locationId) async {
    final weatherUrl = "$baseUrl/api/location/$locationId";
    final weatherResponse = await this.httpClient.get(weatherUrl);

    if (weatherResponse.statusCode != 200) {
      throw Exception("error getting weather for location");
    }

    final weatherJson = jsonDecode(weatherResponse.body);
    return Weather.fromJson(weatherJson);
  }
}
