import 'package:alarm/alarm.dart';
import 'package:alarm_application/bloc/hive_alarm_bloc.dart';
import 'package:alarm_application/bloc/weather_bloc.dart';
import 'package:alarm_application/models/alarm_model.dart';
import 'package:alarm_application/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(AlarmModelAdapter().typeId)) {
    Hive.registerAdapter(AlarmModelAdapter());
  }
  await Alarm.init();
  // Hive.registerAdapter(AlarmModelAdapter());
  // await Hive.openBox('alarm_box');

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => WeatherBloc(),
      ),
      BlocProvider(
        create: (context) => HiveAlarmBloc(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            context.read<WeatherBloc>().add(
                  WeatherProcess(snapshot.data as Position),
                );
            return const HomeScreen();
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        // child: HomeScreen(),
      ),
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
