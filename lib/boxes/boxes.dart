import 'package:alarm_application/models/alarm_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<AlarmModel> getData() => Hive.box<AlarmModel>('alarm_box');
}
