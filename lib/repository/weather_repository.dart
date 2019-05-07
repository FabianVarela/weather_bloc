import 'package:meta/meta.dart';
import 'package:weather_bloc/client/weather_client.dart';
import 'package:weather_bloc/model/weather.dart';

class WeatherRepository {
  final WeatherClient weatherClient;

  WeatherRepository({@required this.weatherClient});

  Future<Weather> getWeather(String city) async {
    final int locationId = await weatherClient.getLocationId(city);

    if (locationId != 0)
      return weatherClient.fetchWeather(locationId);
    else
      return null;
  }
}
