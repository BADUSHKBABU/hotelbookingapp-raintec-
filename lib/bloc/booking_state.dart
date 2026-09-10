import 'package:flutter/foundation.dart';
import '../models/room.dart';
import '../services/booking_logic.dart';

@immutable
class BookingState {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final Room? selectedRoom;
  final int? guestFilter;
  final DateValidationResult validationResult;
  final List<Room> visibleRooms;
  final int? nights;
  final double? totalPrice;
  final String? customerName;
  final String? customerPhone;

  const BookingState({
    this.checkIn,
    this.checkOut,
    this.selectedRoom,
    this.guestFilter,
    required this.validationResult,
    required this.visibleRooms,
    this.nights,
    this.totalPrice,
    this.customerName,
    this.customerPhone,
  });

  factory BookingState.initial() {
    return BookingState(
      validationResult: BookingLogic.validateDates(
        checkIn: null,
        checkOut: null,
      ),
      visibleRooms: sampleRooms,
    );
  }

  bool get isCustomerValid =>
      customerName != null && customerName!.trim().isNotEmpty;

  bool get isBookingValid =>
      validationResult.isValid && selectedRoom != null && isCustomerValid;

  BookingState copyWith({
    DateTime? Function()? checkIn,
    DateTime? Function()? checkOut,
    Room? Function()? selectedRoom,
    int? Function()? guestFilter,
    DateValidationResult? validationResult,
    List<Room>? visibleRooms,
    int? Function()? nights,
    double? Function()? totalPrice,
    String? Function()? customerName,
    String? Function()? customerPhone,
  }) {
    return BookingState(
      checkIn: checkIn != null ? checkIn() : this.checkIn,
      checkOut: checkOut != null ? checkOut() : this.checkOut,
      selectedRoom: selectedRoom != null ? selectedRoom() : this.selectedRoom,
      guestFilter: guestFilter != null ? guestFilter() : this.guestFilter,
      validationResult: validationResult ?? this.validationResult,
      visibleRooms: visibleRooms ?? this.visibleRooms,
      nights: nights != null ? nights() : this.nights,
      totalPrice: totalPrice != null ? totalPrice() : this.totalPrice,
      customerName: customerName != null ? customerName() : this.customerName,
      customerPhone: customerPhone != null
          ? customerPhone()
          : this.customerPhone,
    );
  }
}
