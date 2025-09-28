import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:weather_app/models/astro_model.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/hourly_weather.dart';
import 'package:weather_app/models/prediction_model.dart';

class WeatherServices {
  String apiKey = 'key=ac6c3926fbcf416896242113252509';
  //http://api.weatherapi.com/v1/current.json?key=ac6c3926fbcf416896242113252509&q=Galle

  Future<CurrentWeather?> getCurrentWeather(String query) async {
    final endPoint =
        'http://api.weatherapi.com/v1/current.json?$apiKey&q=$query';

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

  Future<List<PredictionModel>> getAutoCompleteResult(String text) async {
    final endPoint = 'http://api.weatherapi.com/v1/search.json?$apiKey&q=$text';

    final response = await http.get(Uri.parse(endPoint));
    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);
      List<PredictionModel> predictions = result
          .map((data) => PredictionModel.fromJson(data))
          .toList();
      return predictions;
    } else {
      Logger().e(response.statusCode);
      return [];
    }
  }

  Future<List<HourlyWeather>> getHourlyWeather(String query) async {
    final endPoint =
        'http://api.weatherapi.com/v1/forecast.json?$apiKey&q=$query&days=1&aqi=no&alerts=no';

    try {
      final response = await http.get(Uri.parse(endPoint));
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<dynamic> hourlyData = body['forecast']['forecastday'][0]['hour'];
        List<HourlyWeather> hourlyWeatherList = hourlyData
            .map((e) => HourlyWeather.fromJson(e))
            .toList();
        Logger().d(hourlyWeatherList.length);
        return hourlyWeatherList;
      } else {
        Logger().e(response.statusCode);
        return [];
      }
    } catch (e) {
      Logger().e(e);
      return [];
    }
  }

  Future<AstroModel?> getAstronomyData(String query) async {
    final endPoint =
        'http://api.weatherapi.com/v1/astronomy.json?$apiKey&q=$query';

    final response = await http.get(Uri.parse(endPoint));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      final astroModel = AstroModel.fromJson(body['astronomy']['astro']);
      return astroModel;
    } else {
      Logger().e(response.statusCode);
      return null;
    }
  }
}
