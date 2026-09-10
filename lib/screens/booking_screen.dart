import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_booking/core/fmt.dart';
import 'package:hotel_booking/widgets/alertdialogue.dart';
import 'package:hotel_booking/widgets/banner.dart';
import 'package:hotel_booking/widgets/summaryrow.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../models/room.dart';
import '../services/booking_logic.dart';
import '../theme.dart';
import '../widgets/room_tile.dart';
import '../widgets/section_panel.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingBloc>(
      create: (context) => BookingBloc(),
      child: const _BookingScreenContent(),
    );
  }
}

class _BookingScreenContent extends StatefulWidget {
  const _BookingScreenContent();

  @override
  State<_BookingScreenContent> createState() => _BookingScreenContentState();
}

class _BookingScreenContentState extends State<_BookingScreenContent> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final blocState = context.read<BookingBloc>().state;
    _nameController = TextEditingController(text: blocState.customerName ?? '');
    _phoneController = TextEditingController(
      text: blocState.customerPhone ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }



  Future<void> _pickDate(
    BuildContext context, {
    required bool isCheckIn,
  }) async {
    final bloc = context.read<BookingBloc>();
    final state = bloc.state;

    final now = DateTime.now();
    final today = BookingLogic.dateOnly(now);
    final initial = isCheckIn
        ? (state.checkIn ?? today)
        : (state.checkOut ??
              (state.checkIn ?? today).add(const Duration(days: 1)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(today) ? today : initial,
      firstDate: today,
      lastDate: today.add(const Duration(days: 730)),
    );

    if (picked == null) return;

    if (isCheckIn) {
      bloc.add(SelectCheckInDateEvent(picked));
    } else {
      bloc.add(SelectCheckOutDateEvent(picked));
    }
  }

  void confirmDialogue(
    BuildContext context,
    Room room,
    int nights,
    double total,
  ) {
    final bloc = context.read<BookingBloc>();
    final state = bloc.state;

    showDialog(
      context: context,
      builder: (ctx) => Alertdialogue(
        title: "Booking Confirmed!",
        customerName: state.customerName!,
        roomCode: room.code,
        roomType: room.type,
        dates: " ${fmt(state.checkIn)} to ${fmt(state.checkOut)}",
        totalAmount: "${BookingLogic.formatCurrency(total)}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.hotel, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  ' Hotel · Room Booking',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 768;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildLeftColumn(context, state),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: _buildSummaryPanel(context, state),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLeftColumn(context, state),
                        const SizedBox(height: 16),
                        _buildSummaryPanel(context, state),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeftColumn(BuildContext context, BookingState state) {
    final validation = state.validationResult;
    final datesValid = validation.isValid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionPanel(
          stepNumber: '1',
          title: 'Customer Information (Mandatory)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name *',
                  hintText: 'Enter guest full name (Required)',
                  prefixIcon: Icon(Icons.person, color: AppColors.navy),
                ),
                onChanged: (v) {
                  context.read<BookingBloc>().add(
                    UpdateCustomerInfoEvent(customerName: v),
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter contact phone number',
                  prefixIcon: Icon(Icons.phone, color: AppColors.navy),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (v) {
                  context.read<BookingBloc>().add(
                    UpdateCustomerInfoEvent(customerPhone: v),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionPanel(
          stepNumber: '2',
          title: 'Select Check-in & Check-out Dates',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LayoutBuilder(
                builder: (context, dateConstraints) {
                  if (dateConstraints.maxWidth < 400) {
                    return Column(
                      children: [
                        _dateField(
                          context,
                          'Check-in Date',
                          state.checkIn,
                          () => _pickDate(context, isCheckIn: true),
                        ),
                        const SizedBox(height: 12),
                        _dateField(
                          context,
                          'Check-out Date',
                          state.checkOut,
                          () => _pickDate(context, isCheckIn: false),
                        ),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: _dateField(
                          context,
                          'Check-in Date',
                          state.checkIn,
                          () => _pickDate(context, isCheckIn: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dateField(
                          context,
                          'Check-out Date',
                          state.checkOut,
                          () => _pickDate(context, isCheckIn: false),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (validation.isInvalid) ...[
                const SizedBox(height: 12),
                banner(validation.message!, isError: true),
              ] else if (datesValid && state.nights != null) ...[
                const SizedBox(height: 10),
                banner(
                  'Selected stay: ${state.nights} night(s)',
                  isError: false,
                  isSuccess: true,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionPanel(
          stepNumber: '3',
          title: 'Select a Room',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  const Text(
                    'Filter by Guest Capacity:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: state.guestFilter,
                        hint: const Text('All Rooms'),
                        isDense: true,
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Rooms'),
                          ),
                          DropdownMenuItem(value: 1, child: Text('1+ Guests')),
                          DropdownMenuItem(value: 2, child: Text('2+ Guests')),
                          DropdownMenuItem(value: 3, child: Text('3+ Guests')),
                          DropdownMenuItem(value: 4, child: Text('4+ Guests')),
                        ],
                        onChanged: (v) => context.read<BookingBloc>().add(
                          FilterByGuestCountEvent(v),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (state.visibleRooms.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'No rooms available for the selected guest filter.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                )
              else
                ...state.visibleRooms.map((room) {
                  return RoomTile(
                    room: room,
                    isSelected: state.selectedRoom?.code == room.code,
                    isAvailable: true,
                    onTap: () =>
                        context.read<BookingBloc>().add(SelectRoomEvent(room)),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryPanel(BuildContext context, BookingState state) {
    final validation = state.validationResult;

    return SectionPanel(
      stepNumber: '4',
      title: 'Booking Summary & Price Breakdown',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!state.isCustomerValid)
            banner(
              'Please enter mandatory Customer Name in Step 1.',
              isError: true,
            )
          else if (validation.isInvalid)
            banner(validation.message!, isError: true)
          else if (validation.isIncomplete)
            banner(
              'Select check-in and check-out dates to compute pricing.',
              isError: false,
              isInfo: true,
            )
          else if (state.selectedRoom == null)
            banner(
              'Select a room from the list to view the total price.',
              isError: false,
              isInfo: true,
            ),
          if (state.isCustomerValid ||
              state.selectedRoom != null ||
              validation.isValid) ...[
            if (state.customerName != null &&
                state.customerName!.trim().isNotEmpty)
              summaryRow('Customer Name', state.customerName!),
            if (state.customerPhone != null &&
                state.customerPhone!.trim().isNotEmpty)
              summaryRow('Phone Number', state.customerPhone!),
          ],
          if (state.selectedRoom != null) ...[
            const Divider(height: 20),
            summaryRow('Room Code', state.selectedRoom!.code),
            summaryRow('Room Type', state.selectedRoom!.type),
            summaryRow('Max Guests', '${state.selectedRoom!.maxGuests} Guests'),
          ],
          if (validation.isValid &&
              state.checkIn != null &&
              state.checkOut != null) ...[
            const Divider(height: 20),
            summaryRow('Check-in Date', fmt(state.checkIn)),
            summaryRow('Check-out Date', fmt(state.checkOut)),
            summaryRow(
              'Total Stay Duration',
              '${state.nights} ${state.nights == 1 ? 'night' : 'nights'}',
            ),
          ],
          if (state.selectedRoom != null && state.nights != null) ...[
            summaryRow('Rate per Night', state.selectedRoom!.formattedPrice),
            summaryRow(
              'Calculation',
              '${state.nights} night(s) × ${state.selectedRoom!.formattedPrice}',
            ),
          ],
          if (state.isBookingValid) ...[
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.navy,
                  ),
                ),
                Text(
                  BookingLogic.formatCurrency(state.totalPrice!),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => confirmDialogue(
                context,
                state.selectedRoom!,
                state.nights!,
                state.totalPrice!,
              ),
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: const Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _dateField(
    BuildContext context,
    String label,
    DateTime? value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(
            Icons.calendar_today,
            size: 18,
            color: AppColors.navy,
          ),
        ),
        child: Text(
          fmt(value),
          style: TextStyle(
            fontWeight: value != null ? FontWeight.w600 : FontWeight.normal,
            color: value != null ? AppColors.navy : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
