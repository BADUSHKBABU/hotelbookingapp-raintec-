import 'package:flutter/material.dart';
import 'package:hotel_booking/core/theme.dart';

class Alertdialogue extends StatelessWidget {
  final String customerName;
  String title;
  final String? customerPhone;
  final String roomCode;
  final String roomType;
  final String dates;
  final String totalAmount;
  final VoidCallback? onBookAnother;

  Alertdialogue({
    this.title = "",
    super.key,
    required this.customerName,
    this.customerPhone,
    this.roomCode = "",
    this.roomType = "",
    this.dates = "",
    required this.totalAmount,
    this.onBookAnother,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 10),
          SizedBox(width: 10),
          Text(title),
        ],
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer: $customerName',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          if (customerPhone != null && customerPhone!.trim().isNotEmpty)
            Text('Phone: $customerPhone'),

          const SizedBox(height: 6),

          if (roomType.trim().isNotEmpty && roomCode.trim().isNotEmpty)
            Text(
              'Room: $roomCode ($roomType)',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

          const SizedBox(height: 4),
          if (dates.trim().isNotEmpty) Text('Dates: $dates'),

          const SizedBox(height: 4),

          Text(
            'Total Amount: $totalAmount',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onBookAnother?.call();
          },
          child: const Text('Book Another Room'),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
