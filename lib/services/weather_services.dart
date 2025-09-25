import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:weather_app/models/current_weather.dart';

class WeatherServices {
  //http://api.weatherapi.com/v1/current.json?key=ac6c3926fbcf416896242113252509&q=Galle

  Future<CurrentWeather? > getCurrentWeather(String query) async {
    final endPoint =
        'http://api.weatherapi.com/v1/current.json?key=ac6c3926fbcf416896242113252509&q=$query';

    final response = await http.get(Uri.parse(endPoint));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      CurrentWeather currentweather = CurrentWeather.fromJson(body);
      Logger().f(currentweather.name);
      return currentweather;
    } else {
      Logger().e(response.statusCode);
      return null;
    }
  }
}
