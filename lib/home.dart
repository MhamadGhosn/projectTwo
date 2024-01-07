import 'package:flutter/material.dart';
import 'WeatherService.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherService _weatherService = WeatherService();
  String currentLocation = 'YourCity,Country'; // Set your default location here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App with History'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: _weatherService.getCurrentWeather(currentLocation),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Text('Failed to load weather data');
                } else {
                  var weatherData = snapshot.data?['main'];
                  if (weatherData != null) {
                    var temperature = weatherData['temp'];
                    var description = snapshot.data?['weather'][0]['description'];
                    return Column(
                      children: [
                        Text('Current Weather: $temperature°C, $description'),
                        ElevatedButton(
                          onPressed: () async {
                            var timestamp = DateTime.now().millisecondsSinceEpoch;
                            await _weatherService.insertWeather(currentLocation, temperature, description, timestamp);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Weather history saved!'),
                            ));
                          },
                          child: Text('Save Weather History'),
                        ),
                      ],
                    );
                  } else {
                    return Text('Error: Unable to retrieve weather data');
                  }
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var history = await _weatherService.getWeatherHistory();
                print('Weather History: $history');
              },
              child: Text('View Weather History'),
            ),
          ],
        ),
      ),
    );
  }
}
