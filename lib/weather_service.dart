import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/weather_model.dart';

class WeatherService {
  Future<WeatherResponse> apiCall(String? city) async {
    var url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': city,
      'appid': '77db0e7892f469d270e5c6e26a03c2e4',
      'units': 'metric'
    });

    var response = await http.get(
      url,
    );

    print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}
