import 'package:alarm_application/models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

ValueNotifier<List<AlarmModel>> alarmListNotifier = ValueNotifier([]);

Future addAlarm(AlarmModel value) async {
  final alarmDb = await Hive.openBox<AlarmModel>('alarm_box');
  final _id = await alarmDb.add(value);
  value.id = _id;
  alarmListNotifier.value.add(value);
  alarmListNotifier.notifyListeners();
}

Future getAllAlarms() async {
  final alarmDb = await Hive.openBox<AlarmModel>('alarm_box');

  alarmListNotifier.value.addAll(alarmDb.values);

  alarmListNotifier.notifyListeners();
}

Future deleteAlarms(int id) async {
  final alarmDb = await Hive.openBox<AlarmModel>('alarm_box');
  await alarmDb.deleteAt(id);
  alarmListNotifier.value = List.from(alarmDb.values);
  alarmListNotifier.notifyListeners();
  getAllAlarms();
  print(alarmDb.values);
}
