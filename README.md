# Smart Support Ticketing System - Mobile App (Flutter)

This is the cross-platform mobile frontend for the Smart Support Ticketing System, built with **Flutter**. It provides a sleek, user-friendly interface for customers to manage their support tickets and interact with AI-driven resolution suggestions.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Stable channel)
- Dart SDK
- An Android Emulator, iOS Simulator, or Desktop environment (Linux/Windows/macOS)

### Installation Steps

1. **Get Dependencies**
   Navigate to the project root and run:
   ```bash
   flutter pub get
   ```

2. **Configure API Endpoint**
   The application communicates with the Laravel backend. To adjust the connection settings, modify `lib/services/api_service.dart`:
   - **Localhost (Desktop/Web)**: Uses `http://127.0.0.1:8001/api`
   - **Android Emulator**: Uses `http://10.0.2.2:8001/api`
   - **Production**: Points to the deployed subdomain.

3. **Run the Application**
   ```bash
   # Run on the default device
   flutter run

   # For specific platforms
   flutter run -d linux
   flutter run -d chrome
   ```

## 🏗️ Architecture & State Management
- **Provider Pattern**: Used for clean state management across the app (Authentication, Settings).
- **Service-Oriented Design**: All API communication is encapsulated in `ApiService`.
- **Responsive UI**: Custom-styled widgets designed for a premium, modern feel.

## ✨ Features
- **Ticket Dashboard**: Overview of all active and closed tickets with real-time status updates.
- **Smart Suggestions**: Integration with the backend AI service to display troubleshooting steps directly in the ticket view.
- **Authentication**: Persistent login state handling with secure token storage.
- **Modern UI**: Card-based layouts, custom navigation, and intuitive user feedback.
