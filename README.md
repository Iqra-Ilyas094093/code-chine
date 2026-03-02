# Flutter Authentication App

A clean and minimal Flutter authentication application featuring onboarding, sign in, registration, and a home screen powered by Firebase Authentication, Cloud Firestore, and Google Sign-In, built with MVVM architecture using Provider for state management.

![image_alt](https://github.com/Iqra-Ilyas094093/code-chine/blob/5f34595aeeb5fa2cf167341aed930b909f48932a/Screenshot%202026-03-02%20132443.png)

## App Overview

This app provides a complete authentication flow for mobile users with a smooth onboarding experience. It demonstrates best practices in Flutter development including separation of concerns, reactive state management, and Firebase integration.

### Screens

1.  **Onboarding** | Introduction slides shown on first launch 
2.  **Sign In** | Login with email & password via Firebase 
3.  **Register** | New user registration with Firebase 
4.  **Home** | Protected screen accessible after successful auth 

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern.

## Firebase Setup

### 1. Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add Project** and follow the setup wizard

### 2. Register Your App
- **Android**: Add your app's package name and download `google-services.json` → place it in `android/app/`
- **iOS**: Add your bundle ID and download `GoogleService-Info.plist` → place it in `ios/Runner/`

### 3. Enable Authentication
1. In Firebase Console, go to **Authentication → Sign-in method**
2. Enable **Email/Password** provider

### 4. Install FlutterFire CLI *(Recommended)*
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
This auto-generates `lib/firebase_options.dart`.

### 5. Initialize Firebase in `main.dart`
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

### Packages Used

1. firebase_core^2.x.x --> Firebase initialization
2. firebase_auth^4.x.x --> Email/password authentication
3. cloud_firestore^4.x.x --> Store & retrieve user data from Firestore
4. google_sign_in^6.x.x --> Google OAuth sign-in integration
5. provider^6.x.x --> State management (MVVM)
6. google_fonts^6.x.x --> Custom typography from Google Fonts

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/Iqra-Ilyas094093/code-chine.git
cd code-chine

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```


This project is open-source and available under the [MIT License](LICENSE).
