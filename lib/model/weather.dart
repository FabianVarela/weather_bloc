enum WeatherCondition {
  snow,
  sleet,
  hail,
  thunderstorm,
  heavyRain,
  lightRain,
  showers,
  heavyCloud,
  lightCloud,
  clear,
  unknown
}

class Weather {
  final WeatherCondition condition;
  final String formattedCondition;
  final double minTemp;
  final double temp;
  final double maxTemp;
  final int locationId;
  final String created;
  final DateTime lastUpdated;
  final String location;

  Weather({
    this.condition,
    this.formattedCondition,
    this.minTemp,
    this.temp,
    this.maxTemp,
    this.locationId,
    this.created,
    this.lastUpdated,
    this.location,
  });

  static Weather fromJson(Map<String, dynamic> json) {
    final consolidatedWeather = json['consolidated_weather'][0];
    final weatherCondition =
        _mapStringToWeatherCondition(consolidatedWeather['weather_state_abbr']);

    return Weather(
      condition: weatherCondition,
      formattedCondition: consolidatedWeather['weather_state_name'],
      minTemp: consolidatedWeather['min_temp'] as double,
      temp: consolidatedWeather['the_temp'] as double,
      maxTemp: consolidatedWeather['max_temp'] as double,
      locationId: json['woeid'] as int,
      created: consolidatedWeather['created'],
      lastUpdated: DateTime.now(),
      location: json['title'],
    );
  }

  static WeatherCondition _mapStringToWeatherCondition(String input) {
    switch (input) {
      case 'sn':
        return WeatherCondition.snow;
      case 'sl':
        return WeatherCondition.sleet;
      case 'h':
        return WeatherCondition.hail;
      case 't':
        return WeatherCondition.thunderstorm;
      case 'hr':
        return WeatherCondition.heavyRain;
      case 'lr':
        return WeatherCondition.lightRain;
      case 's':
        return WeatherCondition.showers;
      case 'hc':
        return WeatherCondition.heavyCloud;
      case 'lc':
        return WeatherCondition.lightCloud;
      case 'c':
        return WeatherCondition.clear;
      default:
        return WeatherCondition.unknown;
    }
  }
}
