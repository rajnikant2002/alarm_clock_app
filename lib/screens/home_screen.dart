import 'package:alarm_clock_app/providers/alarm_provider.dart';
import 'package:alarm_clock_app/providers/auth_provider.dart';
import 'package:alarm_clock_app/screens/add_edit_alarm_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Clock'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.read<AuthProvider>().logout(),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Consumer<AlarmProvider>(
        builder: (context, provider, child) {
          if (provider.alarms.isEmpty) {
            return const Center(
              child: Text('No Alarms Yet', style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            itemCount: provider.alarms.length,
            itemBuilder: (context, index) {
              final alarm = provider.alarms[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    alarm.time,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(alarm.label),
                  trailing: Switch(
                    value: alarm.isEnabled,
                    onChanged: (value) {
                      provider.toggleAlarm(index, value);
                    },
                  ),
                ),
              );
            },
          );
        },
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
