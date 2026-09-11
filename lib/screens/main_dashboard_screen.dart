import 'package:flutter/material.dart';
import '../core/theme.dart';

class MainDashboardScreen extends StatelessWidget {
  final Function(int tabIndex) onNavigate;

  const MainDashboardScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header title + Operational overview summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Main Dashboard',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              Text(
                'Today: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Operational Overview Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;
              return isWide
                  ? Row(
                      children: [
                        Expanded(flex: 3, child: _buildQuickActionGrid()),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: _buildOperationalOverviewCard(),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildOperationalOverviewCard(),
                        const SizedBox(height: 16),
                        _buildQuickActionGrid(),
                      ],
                    );
            },
          ),
          const SizedBox(height: 20),

          // Room Status - Interactive Floor View
          _buildInteractiveFloorView(),
          const SizedBox(height: 20),

          // Lower Section: Vacating rooms & Quick actions
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildVacatingRoomsCard()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildQuickActionsCard()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildVacatingRoomsCard(),
                        const SizedBox(height: 16),
                        _buildQuickActionsCard(),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionGrid() {
    final actions = [
      {
        'title': 'Guest Check-in',
        'icon': Icons.login,
        'color': AppColors.success,
        'tab': 1,
      },
      {
        'title': 'Guest Check-Out',
        'icon': Icons.logout,
        'color': Colors.amber.shade800,
        'tab': 2,
      },
      {
        'title': 'Reservations',
        'icon': Icons.calendar_month,
        'color': Colors.blue,
      },
      {
        'title': 'Housekeeping',
        'icon': Icons.cleaning_services,
        'color': Colors.cyan,
      },
      {'title': 'Restaurant', 'icon': Icons.restaurant, 'color': Colors.orange},
      {'title': 'WhatsApp', 'icon': Icons.chat, 'color': Colors.green},
      {'title': 'Rooms', 'icon': Icons.king_bed, 'color': Colors.purple},
      {
        'title': 'Staff',
        'icon': Icons.people,
        'color': Colors.indigo,
        'badge': '2 tasks',
      },
      {'title': 'Floors', 'icon': Icons.layers, 'color': Colors.teal},
      {'title': 'Reports', 'icon': Icons.bar_chart, 'color': Colors.deepOrange},
      {
        'title': 'Settings',
        'icon': Icons.settings,
        'color': Colors.grey.shade700,
      },
      {
        'title': 'Group Booking',
        'icon': Icons.group_add,
        'color': Colors.pink,
        'badge': 'New',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Access Modules',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth < 450
                  ? 2
                  : (constraints.maxWidth < 700 ? 3 : 4);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  childAspectRatio: cols == 2 ? 1.8 : 1.4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: actions.length,
                itemBuilder: (context, index) {
                  final item = actions[index];
                  final tab = item['tab'] as int?;
                  return InkWell(
                    onTap: () {
                      if (tab != null) onNavigate(tab);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  item['icon'] as IconData,
                                  color: item['color'] as Color,
                                  size: 24,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['title'] as String,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (item.containsKey('badge'))
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.navy,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['badge'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOperationalOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Operational Overview',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _metricBox('Occupancy', '4%', AppColors.accentBlue),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _metricBox('Pending Check-ins', '0', Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _metricBox('Pending Departures', '2', Colors.orange),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _metricBox(
                  'Revenue Today',
                  '₹15,400',
                  AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveFloorView() {
    final floor1Rooms = [
      {'code': '101', 'status': 'available'},
      {'code': '102', 'status': 'occupied'},
      {'code': '103', 'status': 'occupied'},
      {'code': '104', 'status': 'dirty'},
      {'code': '105', 'status': 'dirty'},
      {'code': '106', 'status': 'maintenance'},
      {'code': '107', 'status': 'maintenance'},
      {'code': '108', 'status': 'available'},
      {'code': '109', 'status': 'available'},
      {'code': '110', 'status': 'available'},
    ];

    final floor2Rooms = [
      {'code': '201', 'status': 'available'},
      {'code': '202', 'status': 'occupied'},
      {'code': '203', 'status': 'available'},
      {'code': '204', 'status': 'available'},
      {'code': '205', 'status': 'maintenance'},
      {'code': '206', 'status': 'blocked'},
      {'code': '207', 'status': 'available'},
      {'code': '208', 'status': 'dirty'},
      {'code': '209', 'status': 'available'},
      {'code': '210', 'status': 'available'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(

            children: [
              const Text(
                'Room Status - Interactive Floor View',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.navy,
                ),
              ),
              Text(
                '50 rooms total',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Legend
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _legendItem('Available', Colors.green),
              _legendItem('Occupied', Colors.blue),
              _legendItem('Dirty', Colors.red),
              _legendItem('Maintenance', Colors.orange),
              _legendItem('Blocked', Colors.grey),
            ],
          ),
          const SizedBox(height: 14),

          // Floor 1
          const Text(
            'Floor 1',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: floor1Rooms
                .map((r) => _roomBadge(r['code']!, r['status']!))
                .toList(),
          ),
          const SizedBox(height: 12),

          // Floor 2
          const Text(
            'Floor 2',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: floor2Rooms
                .map((r) => _roomBadge(r['code']!, r['status']!))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _roomBadge(String code, String status) {
    Color bg = Colors.green;
    if (status == 'occupied') bg = Colors.blue;
    if (status == 'dirty') bg = Colors.red;
    if (status == 'maintenance') bg = Colors.orange;
    if (status == 'blocked') bg = Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        border: Border.all(color: bg),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        code,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: bg),
      ),
    );
  }

  Widget _buildVacatingRoomsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Going to Vacate Rooms',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          _vacatingRow('Room 101', 'Mathew Hyden', 'Checkout: Today 11:00 AM'),
          const Divider(),
          _vacatingRow(
            'Room 102',
            'Sarah Thompson',
            'Checkout: Today 12:00 PM',
          ),
        ],
      ),
    );
  }

  Widget _vacatingRow(String room, String guest, String time) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.navy.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.king_bed, color: AppColors.navy, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                room,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                '$guest · $time',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => onNavigate(2),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          child: const Text('Check-out', style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }

  Widget _buildQuickActionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Room Status Changer',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Enter Room Number (e.g. 101)',
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  child: const Text(
                    'Set Ready',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text(
                    'Set Dirty',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
