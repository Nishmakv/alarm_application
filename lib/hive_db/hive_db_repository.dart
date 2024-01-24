import 'package:hive/hive.dart';

class HiveDbRepository {
  addAlarm(id, item) async {
    return Hive.box("alarm_box").put(id, item);
  }

  getAlarm(id) {
    return Hive.box("alarm_box").get(id);
  }
}
