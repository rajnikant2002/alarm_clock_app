import 'package:alarm_clock_app/models/alarm.dart';
import 'package:alarm_clock_app/providers/alarm_provider.dart';
import 'package:alarm_clock_app/providers/auth_provider.dart';
import 'package:alarm_clock_app/theme/app_theme.dart';
import 'package:alarm_clock_app/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditAlarmScreen extends StatefulWidget {
  const AddEditAlarmScreen({super.key, this.alarm});

  final Alarm? alarm;

  @override
  State<AddEditAlarmScreen> createState() => _AddEditAlarmScreenState();
}

class _AddEditAlarmScreenState extends State<AddEditAlarmScreen> {
  final TextEditingController labelController = TextEditingController();
  late TimeOfDay selectedTime;
  bool get _isEditing => widget.alarm != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      selectedTime = TimeOfDay(
        hour: widget.alarm!.hour,
        minute: widget.alarm!.minute,
      );
      labelController.text = widget.alarm!.label;
    } else {
      selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    labelController.dispose();
    super.dispose();
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
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

  Future<void> _saveAlarm() async {
    final label = labelController.text.trim();
    if (label.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an alarm label')),
      );
      return;
    }

    final uid = context.read<AuthProvider>().currentUserId;
    if (uid == null) return;

    final provider = context.read<AlarmProvider>();
    final String? error;

    if (_isEditing) {
      error = await provider.updateAlarm(
        uid: uid,
        alarm: widget.alarm!,
        label: label,
        hour: selectedTime.hour,
        minute: selectedTime.minute,
      );
    } else {
      error = await provider.addAlarm(
        uid: uid,
        label: label,
        hour: selectedTime.hour,
        minute: selectedTime.minute,
      );
    }

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<AlarmProvider>().isSaving;

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
                    Text(
                      _isEditing ? 'Edit Alarm' : 'New Alarm',
                      style: const TextStyle(
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
                                selectedTime.format(context),
                                style: const TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: 2,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to change time',
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
                        onPressed: isSaving ? null : _saveAlarm,
                        icon: isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check_rounded),
                        label: Text(_isEditing ? 'Update Alarm' : 'Save Alarm'),
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
