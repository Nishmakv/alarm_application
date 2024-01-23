import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'alarm_model.g.dart';

@HiveType(typeId: 1)
class AlarmModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  final DateTime time;
  @HiveField(2)
  final String label;
  AlarmModel({required this.id, required this.time, required this.label});
}
