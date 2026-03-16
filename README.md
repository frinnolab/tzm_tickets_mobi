# Smart Support Ticketing System (Frontend)

This is the frontend Flutter Mobile Application for the Smart Support Ticketing System.

## Setup Instructions

1. **Dependency Installation**
   Get the flutter packages defined in `pubspec.yaml`:
   ```bash
   flutter pub get
   ```

2. **Configure Backend URL (Optional)**
   By default, the application is configured to connect to `http://127.0.0.1:8000/api` for Web or native Linux execution. If testing on an Android Emulator, you may need to modify the `baseUrl` in `lib/services/api_service.dart` from `127.0.0.1` to `10.0.2.2`.

3. **Run the Application**
   You can run the application on Chrome, Windows/Linux Desktop, or a connected Emulator:
   ```bash
   flutter run
   ```

## Features

- User Authentication using Provider layout state management
- List all tickets associated with the logged-in user
- Create new tickets to send issues
- View Ticket Details, including fetching a dynamically generated AI response via OpenAI processing on the backend API.
