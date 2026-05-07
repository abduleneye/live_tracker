# # 🚚 Live Tracker Simulation App

A Flutter-based live tracking simulation app built as part of an interview assessment.  
The app simulates real-time movement of a vehicle along predefined routes and displays updates on an interactive map, mimicking a real-world delivery tracking experience.

---

## 📦 Download APK

👉 [Download Latest APK](https://github.com/abduleneye/live_tracker/releases/download/v1/app-release.apk)

---

## 📱 Features
---  
  
- 📍 Simulated real-time location tracking  
- 🗺️ Interactive map rendering using OpenStreetMap  
- 🚗 Route-based movement simulation  
- ⏱️ Continuous position updates (like a live delivery system)  
- 🌐 Network connectivity monitoring (UI-level handling using connectivity_plus and internet_connection_checker with user feedback via dialogs and toasts)  
- 📏 Distance calculation using the Haversine equation (for arrival detection)  
- 📦 Clean Architecture implementation  
- ⚡ State management using Riverpod  
- 🔄 MVVM-inspired presentation layer  
  

## 📸 App Screenshots

<p align="start">
  <img src="https://github.com/abduleneye/live_tracker/blob/master/screen_shots/1.jpg" width="200"/>
  <img src="https://github.com/abduleneye/live_tracker/blob/master/screen_shots/2.jpg" width="200"/>
  <img src="https://github.com/abduleneye/live_tracker/blob/master/screen_shots/4.jpg" width="200"/>
  <img src="https://github.com/abduleneye/live_tracker/blob/master/screen_shots/3.jpg" width="200"/>
  <img src="https://github.com/abduleneye/live_tracker/blob/master/screen_shots/5.jpg" width="200"/>
  <img src="https://github.com/abduleneye/live_tracker/blob/master/screen_shots/6.jpg" width="200"/>
</p>

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
  - Services (simulation logic + stream-based location updates)

---

## 🔄 Data Flow

Service (Stream of Coordinates) → Repository → Riverpod Controller → UI (Reactive updates via Consumer widgets)

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **Riverpod** (State Management & Dependency Injection)
- **flutter_osm_plugin** (Map rendering with OpenStreetMap)
- **Streams (Dart)** for real-time updates
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
│       │   ├── services/      # Simulation logic + streams
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
- Emitting state changes through a **Stream from the service layer**
- Riverpod controllers listen to the stream and update the UI reactively

This mimics how real-time tracking systems work in delivery or ride-hailing applications.

---

## 👨‍💻 Author

**Abdulhameed Abdulhakeem Eneye**  
Mobile App Developer (Flutter & Native Android)  
IoT & Embedded Systems Enthusiast

---

## 📄 License

This project is for assessment/demo purposes.
