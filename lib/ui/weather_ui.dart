import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_bloc/bloc/settings_bloc.dart';
import 'package:weather_bloc/bloc/theme_bloc.dart';
import 'package:weather_bloc/bloc/weather_bloc.dart';
import 'package:weather_bloc/common/custom_theme_data.dart';
import 'package:weather_bloc/common/gradient_container.dart';
import 'package:weather_bloc/model/weather.dart';
import 'package:weather_bloc/repository/weather_repository.dart';
import 'package:weather_bloc/ui/weather_search_ui.dart';
import 'package:weather_bloc/ui/weather_settings_ui.dart';

class WeatherUI extends StatefulWidget {
  final WeatherRepository weatherRepository;

  WeatherUI({Key key, @required this.weatherRepository}) : super(key: key);

  @override
  _WeatherUIState createState() => _WeatherUIState();
}

class _WeatherUIState extends State<WeatherUI> with WidgetsBindingObserver {
  final Color _textColor = Colors.white;

  Completer<void> _refreshCompleter;

  WeatherBloc _weatherBloc;
  ThemeBloc _themeBloc;
  String _currentCity;

  AppLifecycleState _notification;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _refreshCompleter = Completer<void>();
    _weatherBloc = WeatherBloc(weatherRepository: widget.weatherRepository);
    _themeBloc = ThemeBloc();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_notification != null) {
      print('App status notification: $_notification');
    }

    return StreamBuilder(
      stream: _themeBloc.weatherTheme,
      builder: (context, AsyncSnapshot<CustomThemeData> customThemeSnapshot) {
        return Theme(
          data: customThemeSnapshot.hasData
              ? customThemeSnapshot.data.themeData
              : ThemeData.light(),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Weather BLoC"),
              centerTitle: true,
              actions: <Widget>[
                StreamBuilder(
                  stream: settingsBloc.weatherConversion,
                  builder: (context, settingsSnapshot) {
                    return IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherSettingsUI(
                                  isChecked: (settingsSnapshot.hasData &&
                                      settingsSnapshot.data),
                                ),
                          ),
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    _currentCity = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WeatherSearchUI()),
                    );

                    if (_currentCity != null)
                      _weatherBloc.fetchWeather(_currentCity);
                  },
                ),
              ],
            ),
            body: Stack(
              children: <Widget>[
                Center(
                  child: StreamBuilder(
                    stream: _weatherBloc.weather,
                    builder: (context, AsyncSnapshot<Weather> weatherSnapshot) {
                      _themeBloc.fetchThemeWeather((weatherSnapshot.hasData)
                          ? weatherSnapshot.data.condition
                          : null);

                      if (weatherSnapshot.hasData) {
                        return _buildData(
                          weatherSnapshot.data,
                          (customThemeSnapshot.hasData)
                              ? customThemeSnapshot.data.backgroundColor
                              : Colors.lightBlue,
                        );
                      } else if (weatherSnapshot.hasError) {
                        return Text(
                          "Something went wrong:\n${weatherSnapshot.error}",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 25),
                        );
                      } else {
                        return Text(
                          "Please select a location",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue, fontSize: 25),
                        );
                      }
                    },
                  ),
                ),
                StreamBuilder<bool>(
                  stream: _weatherBloc.isLoading,
                  builder: (context, loadingSnapshot) {
                    if (loadingSnapshot.hasData && loadingSnapshot.data) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.grey.withOpacity(.7),
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildData(Weather weather, Color backgroundColor) {
    _refreshCompleter?.complete();
    _refreshCompleter = Completer();

    return RefreshIndicator(
      onRefresh: () {
        _weatherBloc.fetchWeather(_currentCity);
        return _refreshCompleter.future;
      },
      child: GradientContainer(
        backgroundColor: backgroundColor,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: _getLocation(weather.location),
            ),
            Center(
              child: _getLastUpdate(weather.lastUpdated),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: _getImageCondition(weather.condition),
                        ),
                        StreamBuilder<TemperatureUnits>(
                          stream: settingsBloc.weatherUnits,
                          builder: (context, unitsSnapshot) {
                            return Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: _getTemperature(
                                    weather.temp,
                                    weather.maxTemp,
                                    weather.minTemp,
                                    unitsSnapshot.data),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Center(
                      child: Text(
                        weather.formattedCondition,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w200,
                          color: _textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getLocation(String location) {
    return Center(
      child: Text(
        location,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: _textColor,
        ),
      ),
    );
  }

  Widget _getLastUpdate(DateTime lastUpdate) {
    return Text(
      'Updated: ${TimeOfDay.fromDateTime(lastUpdate).format(context)}',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w200,
        color: _textColor,
      ),
    );
  }

  Image _getImageCondition(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
      case WeatherCondition.lightCloud:
        return Image.asset('assets/clear.png');
      case WeatherCondition.hail:
      case WeatherCondition.snow:
      case WeatherCondition.sleet:
        return Image.asset('assets/snow.png');
      case WeatherCondition.heavyCloud:
        return Image.asset('assets/cloudy.png');
      case WeatherCondition.heavyRain:
      case WeatherCondition.lightRain:
      case WeatherCondition.showers:
        return Image.asset('assets/rainy.png');
      case WeatherCondition.thunderstorm:
        return Image.asset('assets/thunderstorm.png');
      case WeatherCondition.unknown:
      default:
        return Image.asset('assets/clear.png');
    }
  }

  List<Widget> _getTemperature(
      double current, double max, double min, TemperatureUnits units) {
    return <Widget>[
      Padding(
        padding: EdgeInsets.only(right: 20),
        child: Text(
          "${_formatTemperature(current, units)}°",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
      ),
      Column(
        children: [
          Text(
            'max: ${_formatTemperature(max, units)}°',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w100,
              color: _textColor,
            ),
          ),
          Text(
            'min: ${_formatTemperature(min, units)}°',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w100,
              color: _textColor,
            ),
          )
        ],
      )
    ];
  }

  int _formatTemperature(double value, TemperatureUnits units) =>
      (units != null && units == TemperatureUnits.fahrenheit)
          ? _celsiusToFahrenheit(value)
          : value.round();

  int _celsiusToFahrenheit(double value) => ((value * 9 / 5) + 32).round();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _weatherBloc.dispose();

    super.dispose();
  }
}
