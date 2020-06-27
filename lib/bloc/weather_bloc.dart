import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_bloc/bloc/base_bloc.dart';
import 'package:weather_bloc/model/weather.dart';
import 'package:weather_bloc/repository/weather_repository.dart';

class WeatherBloc implements BaseBloc {
  final WeatherRepository weatherRepository;

  final _weatherFetcher = PublishSubject<Weather>();
  final _loading = PublishSubject<bool>();

  WeatherBloc({@required this.weatherRepository});

  Stream<Weather> get weather => _weatherFetcher.stream;

  Stream<bool> get isLoading => _loading.stream;

  fetchWeather(String city) async {
    _loading.sink.add(true);

    Weather currentWeather = await weatherRepository.getWeather(city);

    if (currentWeather != null)
      _weatherFetcher.sink.add(currentWeather);
    else
      _weatherFetcher.sink.addError("City not found");

    _loading.sink.add(false);
  }

  @override
  void dispose() {
    _weatherFetcher.close();
    _loading.close();
  }
}
