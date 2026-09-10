import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/main.dart';
import 'package:hotel_booking/widgets/room_tile.dart';

void main() {
  testWidgets('Hotel Booking App renders all sample rooms and main structure', (WidgetTester tester) async {
    // Build app frame
    await tester.pumpWidget(const HotelBookingApp());

    // Verify AppBar title
    expect(find.textContaining('Hotel · Room Booking'), findsOneWidget);

    // Verify step section headers
    expect(find.textContaining('Customer Information (Mandatory)'), findsOneWidget);
    expect(find.textContaining('Select Check-in & Check-out Dates'), findsOneWidget);
    expect(find.textContaining('Select a Room'), findsOneWidget);
    expect(find.textContaining('Booking Summary & Price Breakdown'), findsOneWidget);

    // Verify sample room tiles are rendered
    expect(find.byType(RoomTile), findsNWidgets(23));
    expect(find.textContaining('R101'), findsOneWidget);
    expect(find.textContaining('R102'), findsOneWidget);
    expect(find.textContaining('R201'), findsOneWidget);
    expect(find.textContaining('R202'), findsOneWidget);
    expect(find.textContaining('R301'), findsOneWidget);

    // Verify initial state info banner
    expect(find.textContaining('Please enter mandatory Customer Name'), findsOneWidget);
  });

  testWidgets('Room selection updates visual tile state', (WidgetTester tester) async {
    await tester.pumpWidget(const HotelBookingApp());

    // Scroll to and tap on Deluxe Room R101
    final roomTileFinder = find.byType(RoomTile).first;
    await tester.ensureVisible(roomTileFinder);
    await tester.tap(roomTileFinder);
    await tester.pumpAndSettle();

    // Verify check icon turns on
    expect(find.byIcon(Icons.check_circle), findsAtLeastNWidgets(1));
  });
}
