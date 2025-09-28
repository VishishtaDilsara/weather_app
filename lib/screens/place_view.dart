import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/hourly_weather.dart';
import 'package:weather_app/models/prediction_model.dart';
import 'package:weather_app/services/weather_services.dart';

class PlaceView extends StatefulWidget {
  final PredictionModel prediction;
  const PlaceView({super.key, required this.prediction});

  @override
  State<PlaceView> createState() => _PlaceViewState();
}

class _PlaceViewState extends State<PlaceView> {
  late Future<CurrentWeather?> getCurrentWeather;
  late Future<List<HourlyWeather>> hourlyWeatherList;

  @override
  void initState() {
    super.initState();
    getCurrentWeather = WeatherServices().getCurrentWeather(
      widget.prediction.name,
    );
    hourlyWeatherList = WeatherServices().getHourlyWeather(
      widget.prediction.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg6.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Align(alignment: Alignment.topLeft, child: BackButton()),
                    FutureBuilder(
                      future: getCurrentWeather,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (snapshot.hasError || snapshot.data == null) {
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: Text('Sorry...Something went wrong!'),
                            ),
                          );
                        }
                        CurrentWeather currentWeather = snapshot.data!;
                        return SizedBox(
                          height: 200,

                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${currentWeather.temp}°C',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Image.network(
                                      currentWeather.condition.icon,
                                      width: 40,
                                    ),
                                  ],
                                ),
                                Text(
                                  currentWeather.condition.text,
                                  style: TextStyle(color: Colors.grey.shade900),
                                ),
                                Text(
                                  widget.prediction.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 12),
                    child: Text(
                      'Hourly Weather Forecast',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade900,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: hourlyWeatherList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade200,
                          highlightColor: Colors.grey.shade300,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return Text('Something Went wrong...');
                      }
                      if (snapshot.data!.isEmpty) {
                        return Text('No data found...');
                      }
                      final list = snapshot.data!
                          .where(
                            (element) =>
                                element.time.hour > DateTime.now().hour,
                          )
                          .toList();
                      return MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final weather = list[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image.network(
                                  weather.condition.icon,
                                  width: 30,
                                ),
                              ),
                              title: Text(weather.condition.text),
                              subtitle: Text(
                                DateFormat('hh:mm a').format(weather.time),
                              ),
                              trailing: Text(
                                '${weather.temp}°C',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
