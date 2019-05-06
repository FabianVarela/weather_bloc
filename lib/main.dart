import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:weather_bloc/client/weather_client.dart';
import 'package:weather_bloc/repository/weather_repository.dart';
import 'package:weather_bloc/ui/weather_ui.dart';

void main() {
  final WeatherRepository weatherRepository = WeatherRepository(
    weatherClient: WeatherClient(
      httpClient: Client(),
    ),
  );

  runApp(MyApp(weatherRepository: weatherRepository));
}

class MyApp extends StatelessWidget {
  final WeatherRepository weatherRepository;

  MyApp({Key key, @required this.weatherRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherUI(
        weatherRepository: weatherRepository,
      ),
    );
  }
}
