import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/prediction_model.dart';
import 'package:weather_app/screens/place_view.dart';
import 'package:weather_app/services/weather_services.dart';

class HomePage extends StatefulWidget {
  final CurrentWeather currentWeather;
  const HomePage({super.key, required this.currentWeather});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController queryController = TextEditingController();
  List<PredictionModel> predictions = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 380,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(color: Colors.grey),
                    child: Stack(
                      children: [
                        ClipRect(
                          child: Lottie.asset(
                            'assets/lotties/mountain.json',
                            width: double.infinity,
                            height: 350,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.currentWeather.name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.currentWeather.condition.text,
                                      style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6,
                                        right: 2,
                                      ),
                                      child: Text(
                                        '${widget.currentWeather.temp}°C',
                                        style: TextStyle(
                                          color: Colors.grey.shade200,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Image(
                                      image: NetworkImage(
                                        widget.currentWeather.condition.icon,
                                      ),
                                      height: 25,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            child: Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.black,
                          ),
                          Text(
                            'Weather App',
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade800,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?cs=srgb&dl=pexels-creationhill-1681010.jpg&fm=jpg',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Card(
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: size.width * 0.65,
                                child: TextField(
                                  controller: queryController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search here...',
                                  ),
                                  cursorColor: Colors.grey.shade800,
                                  onChanged: (value) async {
                                    if (value.isNotEmpty) {
                                      predictions = await WeatherServices()
                                          .getAutoCompleteResult(value);
                                    } else {
                                      predictions.clear();
                                    }

                                    setState(() {});
                                  },
                                ),
                              ),
                              Icon(Icons.search, color: Colors.grey.shade800),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (predictions.isNotEmpty && queryController.text.isNotEmpty)
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(predictions[index].name),
                      subtitle: Text(predictions[index].country),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlaceView(prediction: predictions[index]),
                          ),
                        );

                        setState(() {
                          queryController.clear();
                        });
                      },
                    );
                  },
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
                  SizedBox(
                    height: 136,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 100,
                            height: 120,
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '05:00 AM',
                                    style: TextStyle(
                                      color: Colors.grey.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.cloud_outlined,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  Text('28°C'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
