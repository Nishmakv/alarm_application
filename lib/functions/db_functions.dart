import 'package:alarm_application/models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

ValueNotifier<List<AlarmModel>> alarmListNotifier = ValueNotifier([]);

Future addAlarm(AlarmModel value) async {
  //  alarmListNotifier.value.clear();
  final alarmDb = await Hive.openBox<AlarmModel>('alarm_box');
  await alarmDb.add(value);
  getAllAlarms();
  alarmListNotifier.value.add(value);
  alarmListNotifier.notifyListeners();
}

Future getAllAlarms() async {
  final alarmDb = await Hive.openBox<AlarmModel>('alarm_box');
  alarmListNotifier.value = List.from(alarmDb.values);
  alarmListNotifier.notifyListeners();
  
}



Future deleteAlarms(int id) async {
  final alarmDb = await Hive.openBox<AlarmModel>('alarm_box');

  try {
   
    final index = alarmDb.values.toList().indexWhere((alarm) => alarm.id == id);

    if (index != -1) {
      // Delete the alarm at the found index
      await alarmDb.deleteAt(index);

      // Update the notifier and notify listeners
      alarmListNotifier.value = List.from(alarmDb.values);
      alarmListNotifier.notifyListeners();

      print('Alarm with id $id deleted successfully.');
    } else {
      print('Alarm with id $id not found.');
    }
  } catch (e) {
    print('Error deleting alarm: $e');
  }
}

Future updateAlarms(int index, AlarmModel alarm) async {
  final alarmDb = await Hive.openBox<AlarmModel>('alarm_box');
  await alarmDb.putAt(index, alarm);
  alarmListNotifier.notifyListeners();
}
