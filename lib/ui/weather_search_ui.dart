import 'package:flutter/material.dart';

class WeatherSearchUI extends StatefulWidget {
  @override
  _WeatherSearchUIState createState() => _WeatherSearchUIState();
}

class _WeatherSearchUIState extends State<WeatherSearchUI> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search City"),
        centerTitle: true,
      ),
      body: Form(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      labelText: "City", hintText: "Type a city (i.e. London)"),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () =>
                  Navigator.pop(context, _textEditingController.text),
            ),
          ],
        ),
      ),
    );
  }
}
