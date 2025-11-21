📱 Mini Lead Manager (CRM App)

A clean, modern, and persistent Lead Management Application built with Flutter. This app allows users to track sales leads, manage their statuses, and export data, simulating a real-world CRM environment.

Designed using Clean Architecture and Riverpod for robust state management.

✨ Features

Core Functionality

Dashboard: View all leads in a beautiful, animated list.

CRUD Operations: Add, Edit, and Delete leads seamlessly.

Status Management: Track leads through stages: New, Contacted, Converted, Lost.

Persistent Storage: All data is saved locally using SQLite (sqflite), ensuring data remains after app restarts.

Filtering: Filter leads by specific status (e.g., "Show only Converted leads").

🚀 Bonus Features (Implemented)

🔍 Search: Instant search by Name or Contact details.

🌗 Dark/Light Mode: Full theme support with a toggle switch.

✨ Animations: Smooth slide-and-fade entry animations for list cards.

📂 JSON Export: Export all lead data to a JSON file via system share (Gmail, Drive, WhatsApp, etc.).

🎨 UI Polish: Custom color palette, consistent typography, and CRM-style status indicators.

🛠️ Architecture

This project follows Clean Architecture principles to ensure separation of concerns, scalability, and testability.

Folder Structure

The code is organized into four main layers inside lib/:

lib/
 ├── core/              # Global constants and utilities
 │    ├── constants/    # AppColors, TextStyles
 │    └── utils/        # Status helpers, Date formatters
 │
 ├── data/              # Data Layer (The "Truth")
 │    ├── models/       # LeadModel (Data classes)
 │    ├── db/           # SQLite Database setup (sqflite)
 │    └── repositories/ # LeadRepository (CRUD methods)
 │
 ├── logic/             # Business Logic Layer (The "Brain")
 │    └── providers/    # Riverpod Providers
 │          ├── lead_provider.dart    # Manages Lead State & DB calls
 │          ├── filter_provider.dart  # Manages Search & Status filters
 │          └── theme_provider.dart   # Manages Dark/Light mode state
 │
 └── presentation/      # UI Layer (The "Face")
      ├── screens/      # Dashboard, Add/Edit, Details Screens
      └── widgets/      # Reusable widgets (LeadCard, StatusBadge)


State Management Strategy

Flutter Riverpod is used for dependency injection and state management.

StateNotifier: Used for the LeadList to handle complex CRUD updates.

StateProvider: Used for simple states like FilterStatus, SearchQuery, and ThemeMode.

Computed Providers: The dashboard list is a computed value derived from the raw database list + current search query + current status filter.

📦 Packages Used


flutter_riverpod - State Management and Dependency Injection.

sqflite -          Local SQLite database for persisting leads.

path -             Helper for finding the database path on the device.

uuid -             Generates unique string IDs for new leads.

path_provider -    Accessing the filesystem to save export files.

share_plus -       Native sharing dialog for exporting JSON.

🏃‍♂️ How to Run

Follow these steps to set up the project locally.

Prerequisites

Flutter SDK installed.

An Android Emulator or Physical Device.

Installation

Clone the repository (or extract the zip):

git clone <repository-url>
cd lead_manager_crm


Install dependencies:

flutter pub get


Run the app:

flutter run


⚠️ Troubleshooting Native Errors

If you encounter a MissingPluginException or PlatformException regarding path_provider or share_plus (common when adding native plugins to a running app), perform a clean build:

flutter clean
flutter pub get
flutter run
