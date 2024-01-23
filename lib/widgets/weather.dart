import 'package:alarm_application/bloc/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class WeatherWidgetState extends StatefulWidget {
  const WeatherWidgetState({super.key});

  @override
  State<WeatherWidgetState> createState() => _WeatherWidgetStateState();
}

class _WeatherWidgetStateState extends State<WeatherWidgetState> {
  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return Shimmer.fromColors(
            baseColor: const Color.fromARGB(31, 220, 217, 217),
            highlightColor: Colors.white,
            child: Container(
              width: double.infinity,
              height: 160,
              color: Colors.white,
            ),
          );
        } else if (state is WeatherSuccess) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.038),
                        blurRadius: 12,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(19, 145, 145, 145),
                    ),
                  ),
                  height: h / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${DateFormat('EEE').format(DateTime.now())}, ${TimeOfDay.now().format(context)}',
                            style: TextStyle(
                                fontSize: w / 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${state.weather.temperature?.celsius?.toStringAsFixed(0)}°',
                            style: TextStyle(
                                fontSize: w / 10,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 15, 177, 21),
                                leadingDistribution:
                                    TextLeadingDistribution.even),
                          ),
                          Text(
                            (state.weather.areaName!),
                            style: TextStyle(
                                fontSize: w / 25, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
