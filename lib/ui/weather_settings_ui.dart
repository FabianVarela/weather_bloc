import 'package:flutter/material.dart';
import 'package:weather_bloc/bloc/settings_bloc.dart';

class WeatherSettingsUI extends StatelessWidget {
  final bool isChecked;

  WeatherSettingsUI({this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          StreamBuilder(
            stream: settingsBloc.weatherConversion,
            builder: (context, AsyncSnapshot<bool> snapshot) => ListTile(
                  title: Text("Temperature Units"),
                  isThreeLine: true,
                  subtitle:
                      Text("Use metric measurements for temperature units."),
                  trailing: Switch(
                    value: (snapshot.hasData) ? snapshot.data : isChecked,
                    onChanged: (value) =>
                        settingsBloc.changeTemperatureConversion(value),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
