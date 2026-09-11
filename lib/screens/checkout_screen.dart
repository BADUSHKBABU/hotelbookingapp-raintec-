import 'package:flutter/material.dart';
import 'package:hotel_booking/widgets/alertdialogue.dart';
import '../services/booking_logic.dart';
import '../core/theme.dart';
import '../widgets/section_panel.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  String _selectedRoom = '101';
  String _guestName = 'asd';
  String _paymentMethod = 'Credit Card';

  final List<Map<String, dynamic>> _roomCharges = [
    {
      'item': 'Room Stay (2 Nights @ ₹1,200/night)',
      'date': '02/04/2026',
      'amount': 2400.0,
    },
    {'item': 'Mini-bar (Water x2)', 'date': '03/04/2026', 'amount': 100.0},
    {'item': 'Room Service', 'date': '03/04/2026', 'amount': 1200.0},
    {
      'item': 'Restaurant Bill (Room 101)',
      'date': '03/04/2026',
      'amount': 850.0,
    },
  ];

  double get _subtotal =>
      _roomCharges.fold(0, (sum, item) => sum + (item['amount'] as double));

  void _processCheckout() {
    showDialog(
      context: context,
      builder: (ctx) => Alertdialogue(
        title: "Check-out",
        customerName: _guestName,
        roomCode: _selectedRoom,
        totalAmount:
            "${BookingLogic.formatCurrency(_subtotal)} via $_paymentMethod",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 820;
          return isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildLeftColumn()),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: _buildPaymentPanel()),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLeftColumn(),
                    const SizedBox(height: 16),
                    _buildPaymentPanel(),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      children: [
        SectionPanel(
          stepNumber: '1',
          title: 'Select Departing Guest',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedRoom,
                      decoration: const InputDecoration(
                        labelText: 'Select Room',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: '101',
                          child: Text('Room 101 · asd'),
                        ),
                        DropdownMenuItem(
                          value: '103',
                          child: Text('Room 103 · Sxyz'),
                        ),
                        DropdownMenuItem(
                          value: '201',
                          child: Text('Room 201 · pqr'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            _selectedRoom = v;
                            if (v == '103') _guestName = 'xyz';
                            if (v == '101') _guestName = 'asd';
                            if (v == '201') _guestName = 'pqr';
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guest Name: $_guestName',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Stay Dates: 02/04/2026 - 04/04/2026 (2 Nights)',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Room $_selectedRoom',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionPanel(
          stepNumber: '2',
          title: 'Review & Finalize Bill',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '[Room $_selectedRoom] Itemized Charges',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              ..._roomCharges.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['item'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              item['date'] as String,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        BookingLogic.formatCurrency(item['amount'] as num),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal Room Charges',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    BookingLogic.formatCurrency(_subtotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentPanel() {
    return SectionPanel(
      stepNumber: '3',
      title: 'Payment & Check-out',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount Due',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                BookingLogic.formatCurrency(_subtotal),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _paymentMethod,
            decoration: const InputDecoration(labelText: 'Payment Method'),
            items: const [
              DropdownMenuItem(
                value: 'Credit Card',
                child: Text('Credit / Debit Card'),
              ),
              DropdownMenuItem(value: 'Cash', child: Text('Cash')),
              DropdownMenuItem(value: 'M-Pay', child: Text('M-Pay / UPI')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _paymentMethod = v);
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _processCheckout,
            icon: const Icon(Icons.payment, size: 20),
            label: const Text(
              'Process Payment & Complete Check-out',
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.print, size: 18),
            label: const Text('Print Final Invoice'),
          ),
        ],
      ),
    );
  }
}
