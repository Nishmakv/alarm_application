// hive_repository.dart
import 'package:alarm_application/models/alarm_model.dart';
import 'package:hive/hive.dart';

class AlarmHiveDataSource {
  static const String boxName = 'alarms';

  Future<Box<AlarmModel>> _openBox() async {
    final appDocument = await Hive.openBox<AlarmModel>(boxName);
    return appDocument;
  }

  Future<void> addAlarm(AlarmModel alarm) async {
    final Box<AlarmModel> box = await _openBox();
    await box.add(alarm);
    print('Alarm added to Hive: $alarm');
    print('hey');
  }

  Future<List<AlarmModel>> getAlarms() async {
    print("function provoked");
    final Box<AlarmModel> box = await _openBox();
    print("done");
    return box.values.toList();
  }
}
