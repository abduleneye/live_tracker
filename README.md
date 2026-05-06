# 🚚 Live Tracker Simulation App

A Flutter-based live tracking simulation app built as part of an interview assessment.  
The app simulates real-time movement of a vehicle along predefined routes and displays updates on an interactive map, mimicking a real-world delivery tracking experience.

---

## 📱 Features

- 📍 Simulated real-time location tracking
- 🗺️ Interactive map rendering using OpenStreetMap
- 🚗 Route-based movement simulation
- ⏱️ Continuous position updates (like a live delivery system)
- 🌐 Network connectivity monitoring (UI-level handling using connectivity_plus and internet_connection_checker with user feedback via dialogs and toasts)
- 📏 Distance calculation using the Haversine equation (for arrival detection)
- 📦 Clean Architecture implementation
- ⚡ State management using Riverpod
- 🔄 MVVM-inspired presentation layer

---

## 🧠 Architecture

This project follows **Clean Architecture** principles with a presentation layer structured in an **MVVM-like pattern**.

### 🔹 Layers

- **Presentation Layer**
  - Flutter UI (Widgets)
  - Riverpod Controllers (ViewModels)

- **Domain Layer**
  - Repository abstractions
  - Core business logic (kept minimal for this simulation)

- **Data Layer**
  - Repository implementations
  - Services (simulation logic)

---

## 🔄 Data Flow

UI → Controller (Riverpod) → Repository → Service → State Update → UI

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **Riverpod** (State Management & Dependency Injection)
- **flutter_osm_plugin** (Map rendering with OpenStreetMap)
- **Clean Architecture**
- **MVVM Pattern (Presentation Layer)**

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed
- Android Studio / VS Code
- Emulator or physical device

### Installation

~~~bash
git clone https://github.com/your-username/live-tracker.git
cd live-tracker
flutter pub get
flutter run
~~~

---

## 📂 Project Structure

~~~text
## 📂 Project Structure

~~~text
lib/
│
├── features/
│   └── live_tracking/
│       ├── presentation/
│       │   ├── ui/
│       │   ├── controllers/   # Riverpod ViewModels
│       │
│       ├── domain/
│       │   ├── repositories/  # Abstract contracts
│       │
│       ├── data/
│       │   ├── repositories/  # Implementations
│       │   ├── services/      # Simulation logic & network handling
│
└── core/
    └── utils/
~~~
> 💡 **Note:**  
> This project uses a **feature-first modular structure**, where each feature (e.g., `live_tracking`) contains its own `presentation`, `domain`, and `data` layers.  
> This approach improves scalability, maintainability, and separation of concerns, making it easier to extend the app with additional features without affecting existing modules.
---

## ⚙️ Simulation Logic

The app simulates movement by:
- Iterating through a list of coordinates (route points)
- Updating the current position at timed intervals
- Emitting state changes via Riverpod controllers

This mimics how real-time tracking systems work in delivery or ride-hailing applications.

---

## 📏 Distance Calculation (Haversine Formula)

To determine when the vehicle has reached the pickup/destination point, the app uses the **Haversine equation** to calculate the distance between two geographic coordinates (latitude and longitude).

This allows for accurate arrival detection based on real-world distance rather than simple coordinate comparison.

---

## 🌐 Network Handling Approach

Network connectivity is handled at the presentation layer due to its direct dependency on UI state and lifecycle events.

The app uses:
- `connectivity_plus` to detect network state changes
- `internet_connection_checker` to verify actual internet access
- UI feedback mechanisms such as dialogs and toast messages for user awareness

This approach ensures real-time feedback during map interactions and route simulation without introducing unnecessary abstraction into the data layer for a UI-driven concern.

---

## 📌 Notes

- This is a **simulation**, not a real GPS tracking system
- Designed to demonstrate architecture, state management, and real-time UI updates
- Focused on clean code structure, scalability, and separation of concerns

---

## 👨‍💻 Author

**Abdulhameed Abdulhakeem Eneye**  
Mobile App Developer (Flutter & Native Android)  
IoT & Embedded Systems Enthusiast

---

## 📄 License

This project is for assessment/demo purposes.
