import 'package:alarm_application/bloc/hive_alarm_bloc.dart';
import 'package:alarm_application/functions/db_functions.dart';
import 'package:alarm_application/models/alarm_model.dart';

import 'package:alarm_application/screens/set_alarm_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
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
          HiveAlarmLoad(),
        );
  }

  @override
  Widget build(BuildContext context) {
    getAllAlarms();
    return BlocListener<HiveAlarmBloc, HiveAlarmState>(
      listener: (context, state) {
        if (state is HiveAlarmLoadSuccess) {
          alarmModel.addAll(state.alarmModel!.toList());
          setState(() {});
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: alarmListNotifier,
              builder: (context, List<AlarmModel> alarmList, Widget? child) {
                return ListView.separated(
                    itemBuilder: (ctx, index) {
                      final data = alarmList[index];
                      return Card(
                        child: Column(
                          children: [
                            Text(data.label),
                            Text(data.time.toString()),
                            IconButton(
                                onPressed: () {
                                  if (data.id != null) {
                                    deleteAlarms(data.id!);
                                  }
                                },
                                icon: Icon(Ionicons.ice_cream_outline))
                          ],
                        ),
                      );
                      // print('answwwwwwwwwwwwwww${alarmList[1].label}');
                    },
                    separatorBuilder: (ctx, index) {
                      return const Divider();
                    },
                    itemCount: alarmList.length);
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 600,
                  child: Center(
                    child: Column(
                      children: <Widget>[SetAlarmWidget()],
                    ),
                  ),
                );
              },
            );
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (ctx) => const AlarmSettingScreen(),
            //   ),
            // );
          },
          child: const Icon(
            Ionicons.add_outline,
          ),
        ),
      ),
    );
  }
}
