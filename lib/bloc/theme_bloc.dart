import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_bloc/bloc/base_bloc.dart';
import 'package:weather_bloc/common/custom_theme_data.dart';
import 'package:weather_bloc/model/weather.dart';

class ThemeBloc implements BaseBloc {
  final _weatherTheme = PublishSubject<CustomThemeData>();

  Observable<CustomThemeData> get weatherTheme => _weatherTheme.stream;

  fetchThemeWeather(WeatherCondition condition) {
    CustomThemeData customThemeData;

    switch (condition) {
      case WeatherCondition.clear:
      case WeatherCondition.lightCloud:
        customThemeData = CustomThemeData(
          themeData: ThemeData(primaryColor: Colors.orangeAccent),
          backgroundColor: Colors.yellow,
        );
        break;
      case WeatherCondition.hail:
      case WeatherCondition.snow:
      case WeatherCondition.sleet:
        customThemeData = CustomThemeData(
          themeData: ThemeData(primaryColor: Colors.lightBlueAccent),
          backgroundColor: Colors.lightBlue,
        );
        break;
      case WeatherCondition.heavyCloud:
        customThemeData = CustomThemeData(
          themeData: ThemeData(primaryColor: Colors.blueGrey),
          backgroundColor: Colors.grey,
        );
        break;
      case WeatherCondition.heavyRain:
      case WeatherCondition.lightRain:
      case WeatherCondition.showers:
        customThemeData = CustomThemeData(
          themeData: ThemeData(primaryColor: Colors.indigoAccent),
          backgroundColor: Colors.indigo,
        );
        break;
      case WeatherCondition.thunderstorm:
        customThemeData = CustomThemeData(
          themeData: ThemeData(primaryColor: Colors.deepPurpleAccent),
          backgroundColor: Colors.deepPurple,
        );
        break;
      case WeatherCondition.unknown:
        customThemeData = CustomThemeData(
          themeData: ThemeData(primaryColor: Colors.blue),
          backgroundColor: Colors.lightBlue,
        );
        break;
    }

    return _weatherTheme.sink.add(customThemeData);
  }

  @override
  void dispose() {
    _weatherTheme.close();
  }
}
