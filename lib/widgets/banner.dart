import 'package:flutter/material.dart';
import 'package:hotel_booking/theme.dart';

Widget banner(
  String message, {
  required bool isError,
  bool isInfo = false,
  bool isSuccess = false,
}) {
  Color bg = AppColors.danger.withValues(alpha: 0.08);
  Color border = AppColors.danger.withValues(alpha: 0.3);
  Color iconColor = AppColors.danger;
  IconData icon = Icons.error_outline;

  if (isSuccess) {
    bg = AppColors.success.withValues(alpha: 0.08);
    border = AppColors.success.withValues(alpha: 0.3);
    iconColor = AppColors.success;
    icon = Icons.check_circle_outline;
  } else if (isInfo) {
    bg = AppColors.accentBlue.withValues(alpha: 0.08);
    border = AppColors.accentBlue.withValues(alpha: 0.3);
    iconColor = AppColors.accentBlue;
    icon = Icons.info_outline;
  }

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: iconColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
