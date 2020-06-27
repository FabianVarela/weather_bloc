import 'package:rxdart/rxdart.dart';
import 'package:weather_bloc/bloc/base_bloc.dart';

enum TemperatureUnits { fahrenheit, celsius }

class SettingsBloc implements BaseBloc {
  final _weatherConversion = BehaviorSubject<bool>();
  final _weatherUnits = PublishSubject<TemperatureUnits>();

  Stream<bool> get weatherConversion => _weatherConversion.stream;

  Stream<TemperatureUnits> get weatherUnits => _weatherUnits.stream;

  changeTemperatureConversion(bool isChanged) {
    _weatherConversion.sink.add(isChanged);

    if (isChanged)
      _weatherUnits.sink.add(TemperatureUnits.fahrenheit);
    else
      _weatherUnits.sink.add(TemperatureUnits.celsius);
  }

  @override
  void dispose() {
    _weatherConversion.close();
    _weatherUnits.close();
  }
}

final settingsBloc = SettingsBloc();
