import 'package:alarm_application/functions/db_functions.dart';
import 'package:alarm_application/models/alarm_model.dart';
import 'package:alarm_application/widgets/weather.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:weather/weather.dart';

class SetAlarmWidget extends StatefulWidget {
  const SetAlarmWidget({super.key});
  @override
  State<SetAlarmWidget> createState() => _SetAlarmWidgetState();
}

class _SetAlarmWidgetState extends State<SetAlarmWidget> {
  
  DateTime selectedDateTime = DateTime.now();
  TextEditingController labelController = TextEditingController();
  TextEditingController alarmController = TextEditingController();

  @override
  void initState() {
    super.initState();
   
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
            WeatherWidgetState(),
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
                    var uuid = Uuid().v4();
                    int integerId = int.parse(uuid.substring(0, 8), radix: 16);
                    print('uuidddd${integerId}');
                    final data = AlarmModel(
                        time: selectedDateTime,
                        label: labelController.text,
                        id: integerId,
                        isActive: true);
                    
                    await addAlarm(data);

                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
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
          
          ],
        ));
  }
}
