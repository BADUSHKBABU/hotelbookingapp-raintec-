
class ExistingBooking {
  final String roomCode;
  final DateTime checkIn;
  final DateTime checkOut;

  const ExistingBooking({
    required this.roomCode,
    required this.checkIn,
    required this.checkOut,
  });
}


List<ExistingBooking> buildSampleExistingBookings() {
  final now = DateTime.now();
  DateTime d(int addDays) => DateTime(now.year, now.month, now.day).add(Duration(days: addDays));

  return [
    ExistingBooking(roomCode: 'R101', checkIn: d(5), checkOut: d(8)),
    ExistingBooking(roomCode: 'R201', checkIn: d(2), checkOut: d(4)),
  ];
}
