# Alarm Clock App

A Flutter alarm clock app with Firebase Authentication, Cloud Firestore sync, local offline cache, and local notifications.

## Features

- Email/password login and registration (Firebase Auth)
- Per-user alarm storage in Firestore with real-time sync
- Offline cache using `shared_preferences`
- Local alarm notifications via `flutter_local_notifications`
- Provider state management
- Add, edit, toggle, and delete alarms

## Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   └── alarm.dart
├── providers/
│   ├── alarm_provider.dart
│   └── auth_provider.dart
├── services/
│   ├── firebase_service.dart
│   ├── local_storage_service.dart
│   └── notification_service.dart
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   └── add_edit_alarm_screen.dart
├── widgets/
│   └── alarm_tile.dart
└── theme/
    └── app_theme.dart
```

## Firestore Structure

```
users/
└── {uid}/
    └── alarms/
        └── {alarmId}/
            ├── label: "Wake Up"
            ├── time: "07:00 AM"
            ├── hour: 7
            ├── minute: 0
            ├── isEnabled: true
            └── createdAt: timestamp
```

## Firebase Setup

### 1. Create a Firebase project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a project (or use existing `map-49d59`)
3. Add an **Android** app with package name: `com.example.alarm_clock_app`
4. Download `google-services.json` and place it in `android/app/`

### 2. Enable Authentication

1. Firebase Console → **Authentication** → **Sign-in method**
2. Enable **Email/Password**

### 3. Enable Firestore

1. Firebase Console → **Firestore Database** → **Create database**
2. Start in **test mode** for development, then apply rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/alarms/{alarmId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 4. FlutterFire configuration (optional for iOS/web)

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This regenerates `lib/firebase_options.dart` for all platforms.

## Run the App

```bash
flutter pub get
flutter run
```

## How It Works

| Layer | Responsibility |
|-------|----------------|
| `firebase_service.dart` | Auth + Firestore CRUD and streams |
| `local_storage_service.dart` | Cache alarms per user offline |
| `notification_service.dart` | Schedule/cancel local notifications |
| `auth_provider.dart` | Auth state, loading, errors |
| `alarm_provider.dart` | Alarm list, sync, notifications |
| `AuthGate` in `main.dart` | Routes unauthenticated users to Login |

## Testing Checklist

- [ ] Register a new account
- [ ] Login with existing account
- [ ] Add an alarm — appears on Home screen
- [ ] Toggle alarm off — notification cancelled
- [ ] Tap alarm to edit
- [ ] Delete alarm
- [ ] Logout — returns to Login screen
- [ ] Login again — alarms restored from Firestore

## Dependencies

- `provider` — state management
- `firebase_core`, `firebase_auth`, `cloud_firestore` — Firebase
- `shared_preferences` — offline cache
- `flutter_local_notifications`, `timezone` — local alarms

## Notes

- Disabled alarms do not schedule notifications
- Alarms repeat daily at the set time
- FCM push notifications are not implemented (bonus feature)
