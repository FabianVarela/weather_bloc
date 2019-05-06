import 'package:flutter/material.dart';
import 'package:weather_bloc/bloc/weather_bloc.dart';
import 'package:weather_bloc/model/weather.dart';
import 'package:weather_bloc/repository/weather_repository.dart';

class WeatherUI extends StatefulWidget {
  final WeatherRepository weatherRepository;

  WeatherUI({Key key, @required this.weatherRepository}) : super(key: key);

  @override
  _WeatherUIState createState() => _WeatherUIState();
}

class _WeatherUIState extends State<WeatherUI> {
  WeatherBloc _weatherBloc;

  @override
  void initState() {
    super.initState();
    _weatherBloc = WeatherBloc(weatherRepository: widget.weatherRepository);
    _weatherBloc.fetchWeather("london");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather BLoC"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: StreamBuilder(
              stream: _weatherBloc.weather,
              builder: (context, AsyncSnapshot<Weather> snapshot) {
                if (snapshot.hasData) {
                  return _buildData(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text(
                    "Something went wrong",
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  return Text(
                    "Please select a location",
                    style: TextStyle(color: Colors.blue),
                  );
                }
              },
            ),
          ),
          StreamBuilder<bool>(
            stream: _weatherBloc.isLoading,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data) {
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
    );
  }

  Widget _buildData(Weather weather) {
    return ListView(
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
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: _getTemperature(
                            weather.temp, weather.maxTemp, weather.minTemp),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    weather.formattedCondition,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getLocation(String location) {
    return Center(
      child: Text(
        location,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black,
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
        color: Colors.black,
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

  List<Widget> _getTemperature(double current, double max, double min) {
    return <Widget>[
      Padding(
        padding: EdgeInsets.only(right: 20),
        child: Text(
          "${_formatTemperature(current)}°",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      Column(
        children: [
          Text(
            'max: ${_formatTemperature(max)}°',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w100,
              color: Colors.black,
            ),
          ),
          Text(
            'min: ${_formatTemperature(min)}°',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w100,
              color: Colors.black,
            ),
          )
        ],
      )
    ];
  }

  int _formatTemperature(double value) => value.round();

  @override
  void dispose() {
    _weatherBloc.dispose();
    super.dispose();
  }
}