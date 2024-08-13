import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/utils/helpers.dart';

class MainCard extends StatelessWidget {
  final String temp;
  final String weather;
  final String icon;
  const MainCard(
      {super.key,
      required this.temp,
      required this.weather,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 15,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    kelvintocelcius(double.parse(temp)),
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.network(
                    "http://openweathermap.org/img/w/$icon.png",
                    width: 42,
                    height: 42,
                  ),
                  // Icon(
                  //   weather == 'Clouds'
                  //       ? Icons.cloud
                  //       : weather == 'Rain'
                  //           ? Icons.thunderstorm
                  //           : Icons.sunny,
                  //   size: 40,
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    weather,
                    style: const TextStyle(fontSize: 24),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
