import 'package:alarm_clock_app/screens/add_edit_alarm_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alarm Clock'), centerTitle: true),
      body: const Center(
        child: Text(
          'No Alarms Yet',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditAlarmScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
