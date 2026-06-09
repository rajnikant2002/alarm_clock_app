import 'package:alarm_clock_app/models/alarm.dart';
import 'package:alarm_clock_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AlarmTile extends StatelessWidget {
  const AlarmTile({
    super.key,
    required this.alarm,
    required this.timeLabel,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  final Alarm alarm;
  final String timeLabel;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isActive = alarm.isEnabled;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 52,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeLabel,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                        color: isActive
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alarm.label,
                      style: TextStyle(
                        fontSize: 14,
                        color: isActive
                            ? AppColors.textSecondary
                            : AppColors.textSecondary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
              Switch(
                value: alarm.isEnabled,
                onChanged: onToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
