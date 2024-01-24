import 'package:alarm_application/bloc/hive_alarm_bloc.dart';
import 'package:alarm_application/functions/db_functions.dart';
import 'package:alarm_application/models/alarm_model.dart';
import 'package:alarm_application/screens/set_alarm_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AlarmModel> alarmModel = [];
  @override
  void initState() {
    super.initState();
    context.read<HiveAlarmBloc>().add(
          const HiveAlarmLoad(),
        );
  }

  void updateAlarmIsActive(int index, bool isActive) {
    // Retrieve the current list of alarms
    List<AlarmModel> currentAlarms = alarmListNotifier.value;

    // Update the isActive property for the specified alarm
    currentAlarms[index].isActive = isActive;

    // Update the list of alarms using the ValueNotifier
    alarmListNotifier.value = List<AlarmModel>.from(currentAlarms);

    // You may also want to update the database or perform any other necessary actions
    // based on the changes to the isActive property.
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    getAllAlarms();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: alarmListNotifier,
            builder: (context, List<AlarmModel> alarmList, Widget? child) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: w / 1,
                  child: ListView.separated(
                      itemBuilder: (ctx, index) {
                        final data = alarmList[index];
                        final formattedTime =
                            DateFormat.jm().format(data.time.toLocal());
                        return SizedBox(
                          height: h / 5.5,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            shadowColor: Colors.white,
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                formattedTime,
                                style: TextStyle(
                                  fontSize: w / 12,
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: h / 30),
                                child: Text(
                                  data.label,
                                  style: const TextStyle(),
                                ),
                              ),
                              trailing: Switch(
                                value: data.isActive ?? false,
                                onChanged: (value) {
                                  updateAlarmIsActive(index, value);
                                },
                              ),

                              // trailing: IconButton(
                              //   onPressed: () {
                              //     if (index != null) {
                              //       deleteAlarms(index);
                              //     } else {
                              //       print('hhhhh');
                              //     }
                              //   },
                              //   icon: Icon(Ionicons.trash_bin_outline),
                              // ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return const SizedBox();
                      },
                      itemCount: alarmList.length),
                ),
              );
            }),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: h / 20, right: w / 3),
        child: FloatingActionButton.large(
          onPressed: () {
            showModalBottomSheet<void>(
              backgroundColor: Colors.white,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: h / 1.5,
                  child: const Center(
                    child: Column(
                      children: <Widget>[SetAlarmWidget()],
                    ),
                  ),
                );
              },
            );
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: const Icon(
            Ionicons.add_outline,
          ),
        ),
      ),
    );
  }
}
