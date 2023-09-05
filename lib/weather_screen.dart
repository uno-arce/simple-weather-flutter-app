import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:weather/weather_model.dart';
import 'package:weather/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextStyle appTitle =
      GoogleFonts.dmSans(color: Colors.black, fontWeight: FontWeight.bold);
  TextStyle appFont = GoogleFonts.dmSans(
      fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);
  TextStyle appCityFont = GoogleFonts.dmSans(
      fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black);
  TextStyle appTempFont = GoogleFonts.dmSans(
      fontSize: 52, fontWeight: FontWeight.bold, color: Colors.black);
  TextStyle appDescriptionFont = GoogleFonts.dmSans(
      fontSize: 18, fontWeight: FontWeight.w100, color: Colors.black);
  final _weatherService = WeatherService();
  final _defaultCity = TextEditingController(text: 'Manila');

  WeatherResponse? _weatherResponse;

  void _search() async {
    final response = await _weatherService.apiCall(_defaultCity.text);
    setState(() => _weatherResponse = response);
  }

  String _getImageAssetForWeather(String weatherDescription) {
    if (weatherDescription.contains('cloud') ||
        weatherDescription.contains('clouds')) {
      return 'lib/assets/cloudy.png';
    }
    return 'lib/assets/sunny.jpg';
  }

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDED6),
      appBar: AppBar(
        title: Text('Weather', style: appTitle),
        backgroundColor: const Color(0xFFFFCEC2),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            _weatherResponse != null
                ? SingleChildScrollView(
                    child: Container(
                      height: 300,
                      width: 400,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Stack(
                            children: [
                              FractionallySizedBox(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Image.asset(
                                  _getImageAssetForWeather(_weatherResponse!
                                      .weatherInfo.description),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Card(
                                elevation: 4,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  width: 400,
                                  padding: EdgeInsets.only(left: 8, right: 24),
                                  child: Row(
                                    children: [
                                      Icon(
                                        PhosphorIcons.magnifying_glass_bold,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          controller: _defaultCity,
                                          onSubmitted: (value) => _search(),
                                          style: appFont,
                                          decoration: const InputDecoration(
                                              hintText: 'Enter a city',
                                              border: InputBorder.none,
                                              isDense: true),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 32, top: 38, bottom: 32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_weatherResponse!.city,
                                        style: appCityFont),
                                    const SizedBox(height: 30),
                                    Center(
                                      child: Text(
                                          '${_weatherResponse!.temperatureInfo.temperature.toString()}°',
                                          style: appTempFont),
                                    ),
                                    Center(
                                      child: Text(
                                        _weatherResponse!
                                            .weatherInfo.description,
                                        style: appDescriptionFont,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
