import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'alarm_model.g.dart';

@HiveType(typeId: 0)
class AlarmModel {
  @HiveField(0)
  final DateTime time;
  @HiveField(1)
  final String label;
  const AlarmModel( this.time,  this.label);
}
