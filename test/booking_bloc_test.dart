import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/bloc/booking_bloc.dart';
import 'package:hotel_booking/bloc/booking_event.dart';
import 'package:hotel_booking/bloc/booking_state.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/services/booking_logic.dart';

void main() {
  group('BookingBloc Tests', () {
    late BookingBloc bookingBloc;

    setUp(() {
      bookingBloc = BookingBloc();
    });

    tearDown(() {
      bookingBloc.close();
    });

    test('initial state is correct', () {
      expect(bookingBloc.state.checkIn, isNull);
      expect(bookingBloc.state.checkOut, isNull);
      expect(bookingBloc.state.selectedRoom, isNull);
      expect(bookingBloc.state.visibleRooms.length, equals(23));
      expect(bookingBloc.state.validationResult.status, equals(ValidationStatus.incomplete));
    });

    test('selecting checkIn and checkOut updates state and calculates nights', () async {
      final now = DateTime.now();
      final today = BookingLogic.dateOnly(now);
      final tomorrow = today.add(const Duration(days: 3));

      bookingBloc.add(SelectCheckInDateEvent(today));
      await expectLater(
        bookingBloc.stream,
        emits(predicate((BookingState s) => s.checkIn == today && s.checkOut == null)),
      );

      bookingBloc.add(SelectCheckOutDateEvent(tomorrow));
      await expectLater(
        bookingBloc.stream,
        emits(predicate((BookingState s) => s.checkOut == tomorrow && s.nights == 3 && s.validationResult.isValid)),
      );
    });

    test('selecting a room and customer name computes total price and validates booking', () async {
      final now = DateTime.now();
      final today = BookingLogic.dateOnly(now);
      final checkOut = today.add(const Duration(days: 2));
      const room = Room(code: 'R101', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2);

      bookingBloc.add(const UpdateCustomerInfoEvent(customerName: 'John Doe', customerPhone: '1234567890'));
      bookingBloc.add(SelectCheckInDateEvent(today));
      bookingBloc.add(SelectCheckOutDateEvent(checkOut));
      bookingBloc.add(const SelectRoomEvent(room));

      await expectLater(
        bookingBloc.stream,
        emitsThrough(predicate((BookingState s) =>
            s.customerName == 'John Doe' &&
            s.selectedRoom?.code == 'R101' &&
            s.totalPrice == 7000.0 &&
            s.isBookingValid)),
      );
    });

    test('customer name is mandatory for isBookingValid', () async {
      final now = DateTime.now();
      final today = BookingLogic.dateOnly(now);
      final checkOut = today.add(const Duration(days: 2));
      const room = Room(code: 'R101', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2);

      bookingBloc.add(SelectCheckInDateEvent(today));
      bookingBloc.add(SelectCheckOutDateEvent(checkOut));
      bookingBloc.add(const SelectRoomEvent(room));

      await expectLater(
        bookingBloc.stream,
        emitsThrough(predicate((BookingState s) =>
            s.selectedRoom?.code == 'R101' && !s.isBookingValid)),
      );

      bookingBloc.add(const UpdateCustomerInfoEvent(customerName: 'Mathew Hyden'));

      await expectLater(
        bookingBloc.stream,
        emits(predicate((BookingState s) => s.isBookingValid)),
      );
    });

    test('filtering by guest capacity updates visibleRooms', () async {
      bookingBloc.add(const FilterByGuestCountEvent(4));

      await expectLater(
        bookingBloc.stream,
        emits(predicate((BookingState s) => s.visibleRooms.length == 5)),
      );
    });

    test('ResetBookingEvent clears state back to initial', () async {
      final today = BookingLogic.dateOnly(DateTime.now());
      bookingBloc.add(SelectCheckInDateEvent(today));
      bookingBloc.add(const ResetBookingEvent());

      await expectLater(
        bookingBloc.stream,
        emitsThrough(predicate((BookingState s) => s.checkIn == null && s.selectedRoom == null)),
      );
    });
  });
}
