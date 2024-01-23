import 'package:alarm_application/bloc/hive_alarm_bloc.dart';
import 'package:alarm_application/models/alarm_model.dart';
import 'package:alarm_application/screens/alarm_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocListener<HiveAlarmBloc, HiveAlarmState>(
      listener: (context, state) {
        if (state is HiveAlarmLoadSuccess) {
          alarmModel.addAll(state.alarmModel!.toList());
          setState(() {});
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<HiveAlarmBloc, HiveAlarmState>(
                builder: (context, state) {
                  if (state is HiveAlarmLoadLoading) {
                    return Center(
                      child: Text('hy'),
                    );
                  } else if (state is HiveAlarmLoadSuccess) {
                    return SizedBox(
                      height: 50,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return Container(
                              height: 50,
                              width: 50,
                              child: Text(alarmModel[index].label),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemCount: alarmModel.length),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const AlarmSettingScreen(),
              ),
            );
          },
          child: const Icon(
            Ionicons.add_outline,
          ),
        ),
      ),
    );
  }
}
