import 'package:alarm_clock_app/models/alarm.dart';
import 'package:alarm_clock_app/providers/alarm_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditAlarmScreen extends StatefulWidget {
  const AddEditAlarmScreen({super.key});

  @override
  State<AddEditAlarmScreen> createState() => _AddEditAlarmScreenState();
}

class _AddEditAlarmScreenState extends State<AddEditAlarmScreen> {
  final TextEditingController labelController = TextEditingController();

  TimeOfDay? selectedTime;

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Alarm")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: labelController,
              decoration: const InputDecoration(
                labelText: "Alarm Label",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickTime,
              child: Text(
                selectedTime == null
                    ? "Select Time"
                    : selectedTime!.format(context),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedTime == null ||
                      labelController.text.trim().isEmpty) {
                    return;
                  }

                  final alarm = Alarm(
                    label: labelController.text.trim(),
                    time: selectedTime!.format(context),
                  );

                  Provider.of<AlarmProvider>(
                    context,
                    listen: false,
                  ).addAlarm(alarm);

                  Navigator.pop(context);
                },
                child: const Text("Save Alarm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
