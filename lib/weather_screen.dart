import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/components/main_card.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secret.dart';
import 'package:weather_app/utils/helpers.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // double temp = 0;
  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  Future<dynamic> getWeatherData() async {
    String city = "Chennai";
    try {
      final res = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$apiKey"));
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "Something went wrong";
      }
      // log("https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$apiKey");
      // setState(() {
      //   temp = data['list'][0]['main']['temp'];
      // });
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getWeatherData(),
        builder: (context, snapshot) {
          log("dart ${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return SnackBar(content: Text(snapshot.error.toString()));
          }
          final data = snapshot.data['list'];
          final weatherData = data[0]['main'];
          final temp = weatherData['temp'];
          final pressure = weatherData['pressure'];
          final humidity = weatherData['humidity'];
          final wind = data[0]['wind']['speed'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainCard(
                  weather: (data[0]['weather'][0]['main']),
                  temp: '$temp',
                  icon: data[0]['weather'][0]['icon'],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    const Text(
                      "Hourly Forecast",
                      maxLines: 1,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${data[0]['dt_txt']}",
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data['list'].length - 1,
                    itemBuilder: (context, index) {
                      final hourlyData = data[index + 1];
                      final time =
                          DateTime.parse(hourlyData['dt_txt'].toString());
                      final timeStamp = DateFormat.j().format(time);
                      final weatherIcon = hourlyData['weather'][0]['main'];
                      return ForeCaseCard(
                          time: timeStamp.toString(),
                          icon: weatherIcon == 'Clouds'
                              ? Icons.cloud
                              : weatherIcon == 'Rain'
                                  ? Icons.thunderstorm
                                  : Icons.sunny,
                          temperature:
                              kelvintocelcius(hourlyData['main']['temp']),
                          img: hourlyData['weather'][0]['icon']);
                    },
                  ),
                ),
                // const SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       // ListView.builder(
                //       //   scrollDirection: Axis.horizontal,
                //       //   itemCount: 5,
                //       //   itemBuilder: (context, index) => const ForeCaseCard(
                //       //       time: "01:43",
                //       //       icon: Icons.sunny,
                //       //       temperature: "31"),
                //       // ),
                //       // const ForeCaseCard(
                //       //     time: "02:12",
                //       //     icon: Icons.thunderstorm,
                //       //     temperature: "20"),
                //       // ForeCaseCard(
                //       //     time: "12:00",
                //       //     icon: Icons.sunny_snowing,
                //       //     temperature: "29"),
                //       // ForeCaseCard(
                //       //     time: "05:22", icon: Icons.cloud, temperature: "27"),
                //       // ForeCaseCard(
                //       //     time: "01:33", icon: Icons.cloud, temperature: "28"),
                //       // ForeCaseCard(
                //       //     time: "11:54", icon: Icons.sunny, temperature: "22"),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InformationCard(
                          icon: Icons.water_drop,
                          text: "Humidity",
                          val: humidity.toString()),
                      InformationCard(
                          icon: Icons.wind_power,
                          text: "Wind",
                          val: wind.toString()),
                      InformationCard(
                        icon: Icons.temple_buddhist,
                        text: "Pressure",
                        val: pressure.toString(),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ForeCaseCard extends StatelessWidget {
  const ForeCaseCard(
      {super.key,
      required this.time,
      required this.icon,
      required this.temperature,
      required this.img});

  final String time;
  final IconData icon;
  final String temperature;
  final String img;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 8,
              ),
              Image.network("http://openweathermap.org/img/w/$img.png"),
              // Icon(
              //   icon,
              //   size: 32,
              // ),
              const SizedBox(
                height: 8,
              ),
              Text(temperature)
            ],
          ),
        ),
      ),
    );
  }
}

class InformationCard extends StatelessWidget {
  const InformationCard(
      {super.key, required this.icon, required this.text, required this.val});

  final IconData icon;
  final String text;
  final String val;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 8,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(val)
        ],
      ),
    );
  }
}
