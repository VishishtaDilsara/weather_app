import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/screens/home_page.dart';
import 'package:weather_app/services/weather_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      final position = await getLocation();
      Logger().f(position);

      String query = '';
      if (position == null) {
        query = 'colombo';
      } else {
        query = '${position.latitude},${position.longitude}';
      }

      final currentWeather = await WeatherServices().getCurrentWeather(query);
      if (currentWeather != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(currentWeather: currentWeather),
          ),
        );
      }
    });
  }

  Future<Position?> getLocation() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      await Geolocator.openLocationSettings();
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, return null.
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      await Geolocator.openAppSettings();
      return null;
    }

    // When permissions are granted, get the position.
    final position = await Geolocator.getCurrentPosition();
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 30,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'By Vishishta Dilsara',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lotties/cloudyDay.json',
              width: 200,
              height: 200,
            ),
            Text(
              'Weather App',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
