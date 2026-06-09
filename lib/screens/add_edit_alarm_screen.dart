import 'package:alarm_clock_app/models/alarm.dart';
import 'package:alarm_clock_app/providers/alarm_provider.dart';
import 'package:alarm_clock_app/theme/app_theme.dart';
import 'package:alarm_clock_app/widgets/gradient_background.dart';
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

  @override
  void dispose() {
    labelController.dispose();
    super.dispose();
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  void _saveAlarm() {
    if (selectedTime == null || labelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a label and select a time')),
      );
      return;
    }

    final alarm = Alarm(
      label: labelController.text.trim(),
      time: selectedTime!.format(context),
    );

    context.read<AlarmProvider>().addAlarm(alarm);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                    const Text(
                      'New Alarm',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: pickTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.3),
                                AppColors.accent.withValues(alpha: 0.15),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 32,
                                color: AppColors.primaryLight.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                selectedTime == null
                                    ? '--:--'
                                    : selectedTime!.format(context),
                                style: TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: 2,
                                  color: selectedTime == null
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                selectedTime == null
                                    ? 'Tap to set time'
                                    : 'Tap to change',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'LABEL',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: labelController,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: 'e.g. Morning Workout',
                          prefixIcon: Icon(Icons.label_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: _saveAlarm,
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Save Alarm'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
