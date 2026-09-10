import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/existing_booking.dart';
import '../models/room.dart';
import '../services/booking_logic.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final List<ExistingBooking> existingBookings;

  BookingBloc({List<ExistingBooking>? bookings})
    : existingBookings = bookings ?? buildSampleExistingBookings(),
      super(BookingState.initial()) {
    on<SelectCheckInDateEvent>(_onSelectCheckIn);
    on<SelectCheckOutDateEvent>(_onSelectCheckOut);
    on<SelectRoomEvent>(_onSelectRoom);
    on<FilterByGuestCountEvent>(_onFilterByGuests);
    on<UpdateCustomerInfoEvent>(_onUpdateCustomerInfo);
    on<ResetBookingEvent>(_onReset);
  }

  void _onSelectCheckIn(
    SelectCheckInDateEvent event,
    Emitter<BookingState> emit,
  ) {
    final newCheckIn = event.checkIn;
    DateTime? currentCheckOut = state.checkOut;

    // Reset checkOut if it is no longer after checkIn
    if (currentCheckOut != null && !currentCheckOut.isAfter(newCheckIn)) {
      currentCheckOut = null;
    }

    _recalculate(
      emit,
      checkIn: newCheckIn,
      checkOut: currentCheckOut,
      selectedRoom: state.selectedRoom,
      guestFilter: state.guestFilter,
    );
  }

  void _onSelectCheckOut(
    SelectCheckOutDateEvent event,
    Emitter<BookingState> emit,
  ) {
    _recalculate(
      emit,
      checkIn: state.checkIn,
      checkOut: event.checkOut,
      selectedRoom: state.selectedRoom,
      guestFilter: state.guestFilter,
    );
  }

  void _onSelectRoom(SelectRoomEvent event, Emitter<BookingState> emit) {
    _recalculate(
      emit,
      checkIn: state.checkIn,
      checkOut: state.checkOut,
      selectedRoom: event.room,
      guestFilter: state.guestFilter,
    );
  }

  void _onFilterByGuests(
    FilterByGuestCountEvent event,
    Emitter<BookingState> emit,
  ) {
    _recalculate(
      emit,
      checkIn: state.checkIn,
      checkOut: state.checkOut,
      selectedRoom: state.selectedRoom,
      guestFilter: event.guestCount,
    );
  }

  void _onUpdateCustomerInfo(
    UpdateCustomerInfoEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        customerName: () => event.customerName ?? state.customerName,
        customerPhone: () => event.customerPhone ?? state.customerPhone,
      ),
    );
  }

  void _onReset(ResetBookingEvent event, Emitter<BookingState> emit) {
    emit(BookingState.initial());
  }

  void _recalculate(
    Emitter<BookingState> emit, {
    required DateTime? checkIn,
    required DateTime? checkOut,
    required Room? selectedRoom,
    required int? guestFilter,
  }) {
    final validation = BookingLogic.validateDates(
      checkIn: checkIn,
      checkOut: checkOut,
    );
    final filteredRooms = BookingLogic.filterByGuests(sampleRooms, guestFilter);

    Room? activeRoom = selectedRoom;
    if (activeRoom != null &&
        !filteredRooms.any((r) => r.code == activeRoom!.code)) {
      activeRoom = null;
    }

    int? nuberOfNights;
    double? totalPrice;

    if (validation.isValid && checkIn != null && checkOut != null) {
      nuberOfNights = BookingLogic.calculateNights(checkIn, checkOut);

      if (activeRoom != null) {
        totalPrice = BookingLogic.calculateTotal(
          checkIn: checkIn,
          checkOut: checkOut,
          room: activeRoom,
        );
      }
    }

    emit(
      BookingState(
        checkIn: checkIn,
        checkOut: checkOut,
        selectedRoom: activeRoom,
        guestFilter: guestFilter,
        validationResult: validation,
        visibleRooms: filteredRooms,
        nights: nuberOfNights,
        totalPrice: totalPrice,
        customerName: state.customerName,
        customerPhone: state.customerPhone,
      ),
    );
  }
}
