import 'package:alarm_application/functions/db_functions.dart';
import 'package:alarm_application/models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SetAlarmWidget extends StatefulWidget {
  const SetAlarmWidget({super.key});

  @override
  State<SetAlarmWidget> createState() => _SetAlarmWidgetState();
}

class _SetAlarmWidgetState extends State<SetAlarmWidget> {
  // final Box dataBox = Hive.box('alarm_box');
  DateTime selectedDateTime = DateTime.now();
  TextEditingController labelController = TextEditingController();
  TextEditingController alarmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // dataBox = Hive.box('alarm_box');
  }

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
        // print('aaaaaaaaaaaaaaaa${selectedDateTime}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return Padding(
        padding: EdgeInsets.all(h / 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () async {
                      // _createItem({
                      //   "alarm": selectedDateTime,
                      //   "label": labelController.text
                      // });
                      final data = AlarmModel(
                          time: selectedDateTime,
                          label: labelController.text,
                          id: null,
                          isActive: true);
                      // final box = Boxes.getData();
                      // box.add(data);
                      // print('bbbbbbbbbbb$selectedDateTime}');
                      // data.save();
                      // Navigator.pop(context);
                      // labelController.clear();

                      // dataBox.add(newData);
                      await addAlarm(data);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'))
              ],
            ),
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
            Padding(
              padding: EdgeInsets.only(top: h / 15),
              child: TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  hintText: 'Label',
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  getAllAlarms();
                },
                child: const Text('jjjj'))
          ],
        ));
  }
}
