part of 'hive_alarm_bloc.dart';

sealed class HiveAlarmEvent extends Equatable {
  const HiveAlarmEvent();

  @override
  List<Object> get props => [];
}

class HiveAlarmLoad extends HiveAlarmEvent {
  const HiveAlarmLoad();
}

class HiveAlarmAdd extends HiveAlarmEvent {
  final AlarmModel;
  const HiveAlarmAdd(this.AlarmModel);
}

class HiveAlarmUpdate extends HiveAlarmEvent {
  const HiveAlarmUpdate();
}

class HiveAlarmDelete extends HiveAlarmEvent {
  const HiveAlarmDelete();
}
