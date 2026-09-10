import 'package:flutter/material.dart';
import '../models/room.dart';
import '../theme.dart';

/// A single selectable room row, styled after the room-tile look in the
/// reference dashboard (colored left accent + clear selected state).
class RoomTile extends StatelessWidget {
  final Room room;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback onTap;

  const RoomTile({
    super.key,
    required this.room,
    required this.isSelected,
    required this.isAvailable,
    required this.onTap,
  });

  Color get _accentColor {
    switch (room.type) {
      case 'Deluxe Room':
        return AppColors.accentBlue;
      case 'Executive Suite':
        return AppColors.warning;
      case 'Family Room':
        return AppColors.success;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isAvailable ? 1 : 0.45,
      child: InkWell(
        onTap: isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentBlue.withValues(alpha: 0.08) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.accentBlue : AppColors.cardBorder,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 42,
                decoration: BoxDecoration(
                  color: _accentColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${room.code} · ${room.type}',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.navy),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 14, color: isAvailable ? AppColors.textMuted : AppColors.danger),
                        const SizedBox(width: 4),
                        Text(
                          'Max ${room.maxGuests} guests'
                          '${isAvailable ? '' : ' · Booked for dates'}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isAvailable ? FontWeight.normal : FontWeight.w600,
                            color: isAvailable ? AppColors.textMuted : AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${room.formattedPrice}/night',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.navy),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.accentBlue : AppColors.cardBorder,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
