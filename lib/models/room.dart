/// Represents a single hotel room as given in the assessment's sample data.
class Room {
  final String code;
  final String type;
  final double pricePerNight;
  final int maxGuests;

  const Room({
    required this.code,
    required this.type,
    required this.pricePerNight,
    required this.maxGuests,
  });

  String get formattedPrice =>
      '₹${pricePerNight.toInt().toString().replaceAllMapped(RegExp(r'(\d+?)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
}

const List<Room> sampleRooms = [
  Room(code: 'R101', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(code: 'R102', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(
    code: 'R201',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  ),
  Room(
    code: 'R202',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  ),
  Room(code: 'R301', type: 'Family Room', pricePerNight: 4200, maxGuests: 4),
  Room(code: 'R103', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(code: 'R104', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(code: 'R105', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(code: 'R106', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(code: 'R107', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(code: 'R108', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(code: 'R109', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(code: 'R110', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),

  Room(
    code: 'R203',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  ),
  Room(
    code: 'R204',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  ),
  Room(
    code: 'R205',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  ),
  Room(
    code: 'R206',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  ),
  Room(
    code: 'R207',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  ),
  Room(
    code: 'R208',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  ),

  Room(code: 'R302', type: 'Family Room', pricePerNight: 4200, maxGuests: 4),
  Room(code: 'R303', type: 'Family Room', pricePerNight: 4200, maxGuests: 4),
  Room(code: 'R304', type: 'Family Room', pricePerNight: 4200, maxGuests: 4),
  Room(code: 'R305', type: 'Family Room', pricePerNight: 4200, maxGuests: 4),
];
