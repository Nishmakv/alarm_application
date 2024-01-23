import 'package:alarm_application/data_source/alarm_hive.dart';
import 'package:alarm_application/models/alarm_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'hive_alarm_event.dart';
part 'hive_alarm_state.dart';

class HiveAlarmBloc extends Bloc<HiveAlarmEvent, HiveAlarmState> {
  AlarmHiveDataSource alarmHiveDataSource = AlarmHiveDataSource();
  HiveAlarmBloc() : super(HiveAlarmAddInitial()) {
    on<HiveAlarmEvent>(
      (event, emit) async {
        if (event is HiveAlarmLoad) {
          try {
            emit(HiveAlarmLoadLoading());
            List<AlarmModel> hiveModel = await alarmHiveDataSource.getAlarms();
            emit(HiveAlarmLoadSuccess(alarmModel: hiveModel));
          } catch (e) {
            print(e);
            emit(HiveAlarmLoadFailure());
          }
        } else if (event is HiveAlarmAdd) {
          emit(HiveAlarmAddLoading());
          // await alarmHiveDataSource.addAlarm(event.AlarmModel);
        }
      },
    );
  }
}
