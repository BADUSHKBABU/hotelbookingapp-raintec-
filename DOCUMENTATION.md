# Raintech Hotel Room Booking & Management System
## Clean Architecture & BLoC Pattern Documentation

---

## 📌 Executive Summary & Architecture Overview

This project implements the **Raintech Hotel Room Booking & Management System** following **Clean Architecture** principles and the **BLoC (Business Logic Component)** pattern for state management.

- **Framework**: Flutter 3.x (Dart)
- **State Management**: `flutter_bloc` (^8.1.6)
- **Architecture**: Clean Architecture (Domain Models → Domain Services → BLoC Layer → Presentation Widgets)
- **Quality Assurance**: `18/18` passing unit & widget test suite with `0` static analysis issues (`flutter analyze` clean)

```text
lib/
├── bloc/
│   ├── booking_bloc.dart     # BLoC controller handling events & state transitions
│   ├── booking_event.dart    # Sealed BLoC event definitions
│   └── booking_state.dart    # Immutable BLoC state definition
├── models/
│   ├── room.dart             # Room entity & hardcoded sample dataset (R101-R301)
│   └── existing_booking.dart # Existing bookings model (for availability check)
├── services/
│   └── booking_logic.dart    # Pure domain validation & calculation service
├── widgets/
│   ├── room_tile.dart        # Selectable room card widget
│   └── section_panel.dart    # Styled panel layout widget
├── screens/
│   ├── booking_screen.dart   # Core room booking SPA consuming BLoC state
│   ├── main_dashboard_screen.dart # Main Hotel Dashboard overview
│   ├── checkout_screen.dart  # Guest Check-out & itemized billing screen
│   └── dashboard_shell.dart  # Top navigation bar shell container
├── theme.dart                # Design system colors, typography & input theme
└── main.dart                 # Application entry point
```

---

## 🧱 BLoC Layer Architecture

The BLoC pattern decouples state management completely from UI widgets:

### 1. BLoC Events ([`lib/bloc/booking_event.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/bloc/booking_event.dart))
- `SelectCheckInDateEvent(DateTime checkIn)`: User picks check-in date.
- `SelectCheckOutDateEvent(DateTime checkOut)`: User picks check-out date.
- `SelectRoomEvent(Room room)`: User selects a room tile.
- `FilterByGuestCountEvent(int? guestCount)`: User filters room list by capacity.
- `ResetBookingEvent()`: Resets booking form state.

### 2. BLoC State ([`lib/bloc/booking_state.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/bloc/booking_state.dart))
- `checkIn` & `checkOut`: Selected stay dates.
- `selectedRoom`: Active room selection.
- `guestFilter`: Active guest capacity filter.
- `validationResult`: Pure validation status (`valid`, `incomplete`, `invalid`).
- `visibleRooms`: Filtered list of rooms.
- `nights`: Computed integer stay duration.
- `totalPrice`: Computed total stay amount (`nights × rate/night`).
- `roomAvailabilityError`: Double-booking overlap message.
- `isBookingValid`: Helper getter (`validationResult.isValid && selectedRoom != null && roomAvailabilityError == null`).

### 3. BLoC Controller ([`lib/bloc/booking_bloc.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/bloc/booking_bloc.dart))
Encapsulates all business rules using `BookingLogic` service functions and emits immutable `BookingState` objects.

---

## 📑 Page-by-Page Technical Documentation

### 1. Core Room Booking Page ([`booking_screen.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/screens/booking_screen.dart))
Consumes `BookingBloc` state reactively via `BlocBuilder`:
- **Date Pickers**: Dispatches `SelectCheckInDateEvent` and `SelectCheckOutDateEvent`. Automatically resets invalid check-out dates.
- **Room List & Guest Filter**: Dispatches `FilterByGuestCountEvent` and `SelectRoomEvent`. Renders custom selectable [`RoomTile`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/widgets/room_tile.dart) cards.
- **Price Summary & Breakdown**: Computes nights, room rate, calculation breakdown, and total price in Indian rupee format (e.g. `₹10,500`).
- **Validation Error Handling**: Explicit red error banners for past check-in dates, same-day stays (`checkOut == checkIn`), reverse date ranges (`checkOut < checkIn`), and room availability conflicts.

### 2. Main Hotel Dashboard Page ([`main_dashboard_screen.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/screens/main_dashboard_screen.dart))
- **Operational Metrics**: Occupancy rate (`4%`), Pending Check-ins (`0`), Pending Departures (`2`), Revenue Today (`₹15,400`).
- **12 Action Modules**: Quick tiles for Guest Check-in, Guest Check-out, Reservations, Housekeeping, Restaurant, WhatsApp, Rooms, Staff, Floors, Reports, Settings, Group Booking.
- **Interactive Floor View**: Color-coded room grid (Floor 1 & Floor 2) with status legend.

### 3. Guest Check-out Page ([`checkout_screen.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/screens/checkout_screen.dart))
- **Departing Guest Lookup**: Search by room number (`Room 101 · Mathew Hyden`, `Room 103 · Sarah Thompson`).
- **Itemized Billing**: Room stay charges and add-ons (Mini-bar, Room Service, Restaurant Bill).
- **Payment & Settlement**: Payment method selector (`Credit Card`, `Cash`, `M-Pay`), Process Payment button, and Print Final Invoice option.

---

## 📊 Sample Room Dataset

```dart
const List<Room> sampleRooms = [
  Room(code: 'R101', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(code: 'R102', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(code: 'R201', type: 'Executive Suite', pricePerNight: 5800, maxGuests: 3),
  Room(code: 'R202', type: 'Executive Suite', pricePerNight: 5800, maxGuests: 3),
  Room(code: 'R301', type: 'Family Room', pricePerNight: 4200, maxGuests: 4),
];
```

---

## 🧪 Testing Suite Documentation

- **BLoC Unit Tests** ([`test/booking_bloc_test.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/test/booking_bloc_test.dart)): Tests event handling, state transitions, date pickers, room selection, guest filter, and reset.
- **Domain Logic Tests** ([`test/booking_logic_test.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/test/booking_logic_test.dart)): Pure unit tests for past dates, same-day stays, reverse ranges, currency formatting, guest filtering, and double-booking overlap logic.
- **Widget Tests** ([`test/widget_test.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/test/widget_test.dart)): Tests full widget rendering and user tile interaction.

```bash
# Run test suite (18 passing tests)
flutter test

# Run static analysis (0 issues found)
flutter analyze
```
