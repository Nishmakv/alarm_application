import 'dart:async';

import 'package:alarm/alarm.dart';

import 'package:alarm_application/functions/db_functions.dart';
import 'package:alarm_application/models/alarm_model.dart';
import 'package:alarm_application/screens/alarm_ring_screen.dart';
import 'package:alarm_application/screens/set_alarm_widget.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AlarmModel> alarmModel = [];

  late List<AlarmSettings> alarms;

  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
    }
    loadAlarms();

    print('Before subscription creation');
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) {
        print('jjjjjjjj');
        print('Received alarmSettings: $alarmSettings');
        navigateToRingScreen(alarmSettings);
      },
    );
    print('After subscription creation');
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.75,
            child: AlarmRingScreen(alarmSettings: settings!),
          );
        });

    if (res != null && res == true) loadAlarms();
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  void loadAlarms() async {
    final alarmDb = await Hive.openBox<AlarmModel>('alarm_box');

    setState(() {
      alarms = alarmDb.values
          .map((alarmModel) => convertToAlarmSettings(alarmModel))
          .toList();
      print('alaaarm${alarms}');
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  AlarmSettings convertToAlarmSettings(AlarmModel alarmModel) {
    return AlarmSettings(
      id: alarmModel.id,
      dateTime: alarmModel.time,
      assetAudioPath: '', 
      notificationTitle: '',
      notificationBody: '',
   
    );
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    getAllAlarms();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: alarmListNotifier,
            builder: (context, List<AlarmModel> alarmList, Widget? child) {
              // print('aaaaaaaaaaaaaaaaaa${alarmListNotifier}');
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: w / 1,
                  child: ListView.separated(
                      itemBuilder: (ctx, index) {
                        final data = alarmList[index];
                        final formattedTime =
                            DateFormat.jm().format(data.time.toLocal());
                        return SizedBox(
                          height: h / 5.5,
                          child: GestureDetector(
                            onLongPress: () {
                              showDeleteConfirmationDialog(context, data.id);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              shadowColor: Colors.white,
                              color: Colors.white,
                              child: ListTile(
                                title: Text(
                                  formattedTime,
                                  style: TextStyle(
                                    fontSize: w / 12,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: h / 30),
                                  child: Text(
                                    data.label,
                                    style: const TextStyle(),
                                  ),
                                ),
                                trailing: Switch(
                                  value: data.isActive ?? false,
                                  onChanged: (value) {
                                    // updateAlarmIsActive(index, value);
                                  },
                                ),

                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return const SizedBox();
                      },
                      itemCount: alarmList.length),
                ),
              );
            }),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: h / 20, right: w / 3),
        child: FloatingActionButton.large(
          onPressed: () {
            showModalBottomSheet<void>(
              backgroundColor: Colors.white,
              isScrollControlled: true,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: h / 1.5,
                  child: const Center(
                    child: Column(
                      children: [
                        SetAlarmWidget(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: const Icon(
            Ionicons.add_outline,
          ),
        ),
      ),

     
    
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, int id) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                deleteAlarms(id);
                Navigator.of(context).pop(); // Close the dialog
              
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Additional logic if "No" is pressed
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
