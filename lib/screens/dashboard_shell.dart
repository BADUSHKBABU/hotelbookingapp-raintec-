import 'package:flutter/material.dart';
import 'package:hotel_booking/widgets/datetimeshowwidget.dart';
import '../theme.dart';
import 'booking_screen.dart';
import 'checkout_screen.dart';
import 'main_dashboard_screen.dart';

class DashboardShell extends StatefulWidget {
  final int initialTabIndex;

  const DashboardShell({super.key, this.initialTabIndex = 0});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  late int _selectedTab = widget.initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(isMobile ? 56 : 64),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand logo & title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.navy,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.hotel,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Raintech',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                    if (!isMobile) ...[
                      // Desktop Navigation Tabs
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _navTab(0, 'Main Dashboard', Icons.dashboard_outlined),
                              const SizedBox(width: 8),
                              _navTab(1, 'Guest Check-in', Icons.meeting_room_outlined),
                              const SizedBox(width: 8),
                              _navTab(2, 'Guest Check-out', Icons.shopping_bag_outlined),
                            ],
                          ),
                        ),
                      ),
                    ],
                    // Date & Time widget
                    const DateTimeDisplay(),
                  ],
                ),
              ),
            ),
          ),
          body: IndexedStack(
            index: _selectedTab,
            children: [
              MainDashboardScreen(
                onNavigate: (idx) => setState(() => _selectedTab = idx),
              ),
              const BookingScreen(),
              const CheckOutScreen(),
            ],
          ),
          bottomNavigationBar: isMobile
              ? BottomNavigationBar(
                  currentIndex: _selectedTab,
                  onTap: (idx) => setState(() => _selectedTab = idx),
                  selectedItemColor: AppColors.navy,
                  unselectedItemColor: AppColors.textMuted,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard_outlined),
                      activeIcon: Icon(Icons.dashboard),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.meeting_room_outlined),
                      activeIcon: Icon(Icons.meeting_room),
                      label: 'Check-in',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_bag_outlined),
                      activeIcon: Icon(Icons.shopping_bag),
                      label: 'Check-out',
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }

  Widget _navTab(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.navy,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
