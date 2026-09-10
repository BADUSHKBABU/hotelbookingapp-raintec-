# Hotel Room Booking App (Single-Page Frontend)

A clean, modular single-page hotel room booking application built with **Flutter (Dart)** for Web and Desktop platforms.

---

## 🛠 Framework & Technology Choice

- **Framework**: Flutter 3.x (Dart)
- **Target Platform**: Web & Desktop (Single-Page App)
- **State Management & Architecture**: Clean Separation of Concerns (Domain Models, Services/Pure Logic, UI Widgets)
- **Styling & Theme**: Custom design system inspired by Raintech Hotel management dashboards (deep navy accents, card panels, status banners).

---

## 📁 Code Structure

The project strictly separates pure business logic from UI rendering to ensure testability and maintainability:

```text
lib/
├── models/
│   ├── room.dart             # Room entity & hardcoded sample dataset (R101-R301)
│   └── existing_booking.dart # Existing bookings model (for availability check)
├── services/
│   └── booking_logic.dart    # Pure, framework-independent business & validation logic
├── widgets/
│   ├── room_tile.dart        # Selectable room tile with guest capacity & pricing badges
│   └── section_panel.dart    # Structured card layout with dark navy step headers
├── screens/
│   ├── booking_screen.dart   # Core single-page room booking & date validation app
│   ├── main_dashboard_screen.dart # Main Hotel Dashboard (occupancy stats & floor grid)
│   ├── checkout_screen.dart  # Guest Check-out & itemized billing screen
│   └── dashboard_shell.dart  # Top navigation bar shell container
├── theme.dart                # Design system colors, typography, and input decorations
└── main.dart                 # Application entry point
```

---

## 📋 Evaluation Criteria & Requirements Matrix

| Requirement / Evaluation Area | Implementation Details | Location in Code |
| :--- | :--- | :--- |
| **Sample Data** | Hardcoded sample rooms (`R101`, `R102`, `R201`, `R202`, `R301`) with correct types, prices (₹), and guest capacities. | [`lib/models/room.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/models/room.dart) |
| **Date Selection** | Interactive check-in and check-out date pickers with formatting (`DD/MM/YYYY`). | [`lib/screens/booking_screen.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/screens/booking_screen.dart) |
| **Room Selection** | Single-room selection list with visual tile highlights & guest filter dropdown. | [`lib/widgets/room_tile.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/widgets/room_tile.dart) |
| **Date Validation** | Validates past check-ins, same-day stays (`checkOut == checkIn`), and invalid ranges (`checkOut < checkIn`). | [`lib/services/booking_logic.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/services/booking_logic.dart#L36-L60) |
| **Error Handling** | Displays explicit, non-silent red error banners detailing the exact validation failure. | [`lib/screens/booking_screen.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/screens/booking_screen.dart#L318-L346) |
| **Night & Price Calculation** | Calculates total nights and total price (`nights × price/night`) formatted as currency (e.g. ₹10,500). | [`lib/services/booking_logic.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/services/booking_logic.dart#L62-L80) |
| **Bonus Features** | Room capacity filter & double-booking overlap protection against existing reservations. | [`lib/services/booking_logic.dart`](file:///d:/clean%20Archtecture/raintech/hotel_booking/lib/services/booking_logic.dart#L88-L115) |

---

## 🧪 Testing & Edge Case Verification

Comprehensive automated test suites cover all business logic edge cases and widget rendering:

- **Past Check-in Dates**: Throws `Check-in date cannot be in the past.`
- **Same-Day Stays**: Throws `Check-out date must be after check-in date (same-day stays are not allowed).`
- **Reverse Date Ranges**: Throws `Check-out date cannot be before check-in date.`
- **Price Computation**: Verifies exact calculation across single & multi-night stays.
- **Guest Capacity Filter**: Verifies filtering down to valid room types.
- **Room Overlap Check**: Verifies double-booking prevention.

### Running Tests

To run the automated unit and widget test suite:

```bash
flutter test
```

---

## 🚀 How to Run the Application

To launch the single-page web app in your browser:

```bash
# Run on Chrome
flutter run -d chrome

# Or build static web app
flutter build web
```
