import 'package:flutter/foundation.dart';
import '../models/room.dart';

@immutable
abstract class BookingEvent {
  const BookingEvent();
}

class SelectCheckInDateEvent extends BookingEvent {
  final DateTime checkIn;
  const SelectCheckInDateEvent(this.checkIn);
}

class SelectCheckOutDateEvent extends BookingEvent {
  final DateTime checkOut;
  const SelectCheckOutDateEvent(this.checkOut);
}

class SelectRoomEvent extends BookingEvent {
  final Room room;
  const SelectRoomEvent(this.room);
}

class FilterByGuestCountEvent extends BookingEvent {
  final int? guestCount;
  const FilterByGuestCountEvent(this.guestCount);
}

class UpdateCustomerInfoEvent extends BookingEvent {
  final String? customerName;
  final String? customerPhone;

  const UpdateCustomerInfoEvent({this.customerName, this.customerPhone});
}

class ResetBookingEvent extends BookingEvent {
  const ResetBookingEvent();
}
