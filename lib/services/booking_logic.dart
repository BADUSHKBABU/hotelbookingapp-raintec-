import '../models/existing_booking.dart';
import '../models/room.dart';

enum ValidationStatus {
  valid,
  incomplete,
  invalid,
}


class DateValidationResult {
  final ValidationStatus status;
  final String? message;

  const DateValidationResult.valid()
      : status = ValidationStatus.valid,
        message = null;

  const DateValidationResult.incomplete(this.message)
      : status = ValidationStatus.incomplete;

  const DateValidationResult.invalid(this.message)
      : status = ValidationStatus.invalid;

  bool get isValid => status == ValidationStatus.valid;
  bool get isIncomplete => status == ValidationStatus.incomplete;
  bool get isInvalid => status == ValidationStatus.invalid;
}

/// All pure, framework-independent logic for the booking app.
class BookingLogic {
  /// Strips the time component so comparisons are date-only (00:00:00).
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Validates a check-in / check-out pair.
  /// Rules:
  ///  - Dates must be selected
  ///  - check-in cannot be in the past (today is allowed)
  ///  - check-out must be strictly after check-in (same-day stay is invalid)
  static DateValidationResult validateDates({
    required DateTime? checkIn,
    required DateTime? checkOut,
    DateTime? now,
  }) {
    if (checkIn == null || checkOut == null) {
      return const DateValidationResult.incomplete('Please select check-in and check-out dates.');
    }

    final today = dateOnly(now ?? DateTime.now());
    final checkin = dateOnly(checkIn);
    final checkoout = dateOnly(checkOut);

    if (checkin.isBefore(today)) {
      return const DateValidationResult.invalid('Check-in date cannot be in the past.');
    }

    if (checkoout.isAtSameMomentAs(checkin)) {
      return const DateValidationResult.invalid('Check-out date must be after check-in date (same-day stays are not allowed).');
    }

    if (checkoout.isBefore(checkin)) {
      return const DateValidationResult.invalid('Check-out date cannot be before check-in date.');
    }

    return const DateValidationResult.valid();
  }

  /// Number of nights between check-in and check-out.
  static int calculateNights(DateTime checkIn, DateTime checkOut) {
    final ci = dateOnly(checkIn);
    final co = dateOnly(checkOut);
    final diff = co.difference(ci).inDays;
    return diff > 0 ? diff : 0;
  }

  /// Total price = nights x price per night.
  static double calculateTotal({
    required DateTime checkIn,
    required DateTime checkOut,
    required Room room,
  }) {
    final nights = calculateNights(checkIn, checkOut);
    return nights * room.pricePerNight;
  }

  /// Currency formatting helper (e.g. ₹3,500, ₹11,600).
  static String formatCurrency(num amount) {
    final str = amount.toInt().toString();
    final regExp = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
    return '₹${str.replaceAllMapped(regExp, (m) => '${m[1]},')}';
  }

  /// Bonus: checks whether room is available for the given date range against existing bookings.
  static bool isRoomAvailable({
    required Room room,
    required DateTime checkIn,
    required DateTime checkOut,
    required List<ExistingBooking> existingBookings,
  }) {
    final ci = dateOnly(checkIn);
    final co = dateOnly(checkOut);

    for (final booking in existingBookings) {
      if (booking.roomCode != room.code) continue;
      final bCi = dateOnly(booking.checkIn);
      final bCo = dateOnly(booking.checkOut);

      final overlaps = ci.isBefore(bCo) && bCi.isBefore(co);
      if (overlaps) return false;
    }
    return true;
  }

  /// Filters room list by guest capacity.
  static List<Room> filterByGuests(List<Room> rooms, int? guestCount) {
    if (guestCount == null || guestCount <= 0) return rooms;
    return rooms.where((r) => r.maxGuests >= guestCount).toList();
  }
}
