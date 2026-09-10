import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/models/existing_booking.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/services/booking_logic.dart';

void main() {
  final referenceNow = DateTime(2026, 9, 10); // Simulated "today"

  group('BookingLogic - Date Validation Edge Cases', () {
    test('returns incomplete status when checkIn or checkOut is null', () {
      final res1 = BookingLogic.validateDates(
        checkIn: null,
        checkOut: DateTime(2026, 9, 12),
        now: referenceNow,
      );
      expect(res1.status, ValidationStatus.incomplete);
      expect(res1.message, contains('select check-in and check-out dates'));

      final res2 = BookingLogic.validateDates(
        checkIn: DateTime(2026, 9, 10),
        checkOut: null,
        now: referenceNow,
      );
      expect(res2.status, ValidationStatus.incomplete);
    });

    test('returns invalid when checkIn is in the past', () {
      final pastDate = DateTime(2026, 9, 9);
      final checkOut = DateTime(2026, 9, 12);

      final res = BookingLogic.validateDates(
        checkIn: pastDate,
        checkOut: checkOut,
        now: referenceNow,
      );

      expect(res.status, ValidationStatus.invalid);
      expect(res.message, equals('Check-in date cannot be in the past.'));
    });

    test('returns invalid for same-day stay (checkOut equals checkIn)', () {
      final sameDay = DateTime(2026, 9, 10);

      final res = BookingLogic.validateDates(
        checkIn: sameDay,
        checkOut: sameDay,
        now: referenceNow,
      );

      expect(res.status, ValidationStatus.invalid);
      expect(res.message, contains('same-day stays are not allowed'));
    });

    test('returns invalid when checkOut is before checkIn', () {
      final checkIn = DateTime(2026, 9, 15);
      final checkOut = DateTime(2026, 9, 12);

      final res = BookingLogic.validateDates(
        checkIn: checkIn,
        checkOut: checkOut,
        now: referenceNow,
      );

      expect(res.status, ValidationStatus.invalid);
      expect(res.message, contains('Check-out date cannot be before check-in date'));
    });

    test('returns valid for legitimate date ranges starting today or future', () {
      final checkIn = DateTime(2026, 9, 10);
      final checkOut = DateTime(2026, 9, 13);

      final res = BookingLogic.validateDates(
        checkIn: checkIn,
        checkOut: checkOut,
        now: referenceNow,
      );

      expect(res.status, ValidationStatus.valid);
      expect(res.isValid, isTrue);
      expect(res.message, isNull);
    });
  });

  group('BookingLogic - Night & Price Calculation Logic', () {
    test('calculateNights computes correct integer duration', () {
      final ci = DateTime(2026, 9, 10);
      final co = DateTime(2026, 9, 14);

      expect(BookingLogic.calculateNights(ci, co), equals(4));
    });

    test('calculateNights returns 0 if checkOut is not after checkIn', () {
      final ci = DateTime(2026, 9, 10);
      expect(BookingLogic.calculateNights(ci, ci), equals(0));
      expect(BookingLogic.calculateNights(ci, DateTime(2026, 9, 8)), equals(0));
    });

    test('calculateTotal computes nights * pricePerNight accurately', () {
      const room1 = Room(code: 'R101', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2);
      const room2 = Room(code: 'R201', type: 'Executive Suite', pricePerNight: 5800, maxGuests: 3);

      final ci = DateTime(2026, 9, 10);
      final co = DateTime(2026, 9, 13); // 3 nights

      final total1 = BookingLogic.calculateTotal(checkIn: ci, checkOut: co, room: room1);
      final total2 = BookingLogic.calculateTotal(checkIn: ci, checkOut: co, room: room2);

      expect(total1, equals(3 * 3500.0)); // 10500
      expect(total2, equals(3 * 5800.0)); // 17400
    });

    test('formatCurrency formats amounts with comma separators and symbol', () {
      expect(BookingLogic.formatCurrency(3500), equals('₹3,500'));
      expect(BookingLogic.formatCurrency(5800), equals('₹5,800'));
      expect(BookingLogic.formatCurrency(17400), equals('₹17,400'));
    });
  });

  group('BookingLogic - Guest Filtering & Availability', () {
    test('filterByGuests filters rooms according to maxGuests capacity', () {
      const testRooms = [
        Room(code: 'R101', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
        Room(code: 'R102', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
        Room(code: 'R201', type: 'Executive Suite', pricePerNight: 5800, maxGuests: 3),
        Room(code: 'R202', type: 'Executive Suite', pricePerNight: 5800, maxGuests: 3),
        Room(code: 'R301', type: 'Family Room', pricePerNight: 4200, maxGuests: 4),
      ];

      final anyFilter = BookingLogic.filterByGuests(testRooms, null);
      expect(anyFilter.length, equals(5));

      final twoGuests = BookingLogic.filterByGuests(testRooms, 2);
      expect(twoGuests.length, equals(5));

      final threeGuests = BookingLogic.filterByGuests(testRooms, 3);
      expect(threeGuests.length, equals(3)); // R201, R202, R301

      final fourGuests = BookingLogic.filterByGuests(testRooms, 4);
      expect(fourGuests.length, equals(1)); // R301
      expect(fourGuests.first.code, equals('R301'));

      final fiveGuests = BookingLogic.filterByGuests(testRooms, 5);
      expect(fiveGuests, isEmpty);
    });

    test('isRoomAvailable detects date overlaps correctly', () {
      const room = Room(code: 'R101', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2);
      final existingBookings = [
        ExistingBooking(
          roomCode: 'R101',
          checkIn: DateTime(2026, 9, 15),
          checkOut: DateTime(2026, 9, 18),
        ),
      ];

      // Non-overlapping range before existing booking
      final availableBefore = BookingLogic.isRoomAvailable(
        room: room,
        checkIn: DateTime(2026, 9, 10),
        checkOut: DateTime(2026, 9, 15),
        existingBookings: existingBookings,
      );
      expect(availableBefore, isTrue);

      // Overlapping range
      final availableOverlap = BookingLogic.isRoomAvailable(
        room: room,
        checkIn: DateTime(2026, 9, 14),
        checkOut: DateTime(2026, 9, 17),
        existingBookings: existingBookings,
      );
      expect(availableOverlap, isFalse);
    });
  });
}
