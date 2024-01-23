part of 'hive_alarm_bloc.dart';

sealed class HiveAlarmState extends Equatable {
  const HiveAlarmState();

  @override
  List<Object> get props => [];
}

final class HiveAlarmLoadInitial extends HiveAlarmState {}

final class HiveAlarmLoadLoading extends HiveAlarmState {}

// ignore: must_be_immutable
final class HiveAlarmLoadSuccess extends HiveAlarmState {
  List<AlarmModel>? alarmModel;
  HiveAlarmLoadSuccess({required this.alarmModel});
}

final class HiveAlarmLoadFailure extends HiveAlarmState {}

final class HiveAlarmAddLoading extends HiveAlarmState {}

final class HiveAlarmAddInitial extends HiveAlarmState {}

final class HiveAlarmAddSuccess extends HiveAlarmState {}

final class HiveAlarmAddFailure extends HiveAlarmState {}

final class HiveAlarmUpdateLoadingInitial extends HiveAlarmState {}

final class HiveAlarmUpdateSuccess extends HiveAlarmState {}

final class HiveAlarmUpdateFailure extends HiveAlarmState {}

final class HiveAlarmDeleteLoadingInitial extends HiveAlarmState {}

final class HiveAlarmDeleteSuccess extends HiveAlarmState {}

final class HiveAlarmDeleteFailure extends HiveAlarmState {}
