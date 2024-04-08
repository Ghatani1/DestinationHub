import 'package:destination/modals/weathermodal.dart';
import 'package:destination/services/weatherservices.dart';
import 'package:destination/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<WeatherPage> {
  final _weatherService = WeatherService('e59731527376f38d1ac0528e03f17bcc');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'rain':
      case 'dizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
      case 'dust':
        return 'assets/cloudy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';

      default:
        // Handle cases where mainCondition doesn't match any specified condition
        return 'No Data Available';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Todays's Weather",
          style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 12, 107, 184),
              Color.fromARGB(255, 130, 203, 237)
            ],
          ),
        ),
        child: Center(
          child: _weather != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        style: const TextStyle(
                            fontSize: 18,
                            color: kWhite,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(_weather!.cityName,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kWhite)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        DateFormat('EEEE')
                            .format(DateTime.now()), // Display current day
                        style: const TextStyle(
                            fontSize: 18,
                            color: kWhite,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Lottie.asset(getWeatherAnimation(_weather!.mainCondition)),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('${_weather!.temperature.round()}°C',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kWhite)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(_weather!.mainCondition,
                          style: const TextStyle(
                              color: kWhite, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
