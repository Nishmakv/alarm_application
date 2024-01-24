import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlarmSettingScreen extends StatefulWidget {
  const AlarmSettingScreen({super.key});

  @override
  State<AlarmSettingScreen> createState() => _AlarmSettingScreenState();
}

class _AlarmSettingScreenState extends State<AlarmSettingScreen> {
  DateTime selectedDateTime = DateTime.now();
  TextEditingController labelController = TextEditingController();
  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );

    if (res != null) {
      setState(() {
        final DateTime now = DateTime.now();

        selectedDateTime = now.copyWith(
            hour: res.hour,
            minute: res.minute,
            second: 0,
            millisecond: 0,
            microsecond: 0);
        if (selectedDateTime.isBefore(now)) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          // WeatherWidgetState(),
          RawMaterialButton(
            onPressed: pickTime,
            fillColor: Colors.grey[200],
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                DateFormat('h:mm a').format(selectedDateTime),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.blueAccent),
              ),
            ),
          ),
          TextField(
            controller: labelController,
            decoration: const InputDecoration(
              hintText: 'Label',
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     context.read<HiveAlarmBloc>().add(
          //           HiveAlarmAdd(
          //             AlarmModel(selectedDateTime, labelController.text),
          //           ),
          //         );
          //   },
          //   child: const Text('Add'),
          // ),
        ],
      )),
    );
  }
}
