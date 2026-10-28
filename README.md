# oauth_firebase_flutter

A Flutter mobile application implementing Firebase Authentication with OAuth providers.

---

## 🚀 Features

* Firebase Authentication
* OAuth Sign-In integration
* Cross-platform Flutter application
* Android & iOS support

---

## 🧱 Tech Stack

### Frontend

* Flutter
* Dart

### Authentication

* Firebase Authentication
* OAuth Providers

---

## ⚙️ Prerequisites

Before starting, make sure you have installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Xcode (for iOS development)
* A Firebase project

---

## 🔥 Firebase Setup

This project uses Firebase for authentication.

### Required Firebase files

The following files are required and are safe to keep in the repository:

```text
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
lib/firebase_options.dart
```

---

## 📦 Installation

### 1. Clone the repository

```bash
git clone <repository-url>
cd oauth_firebase_flutter
```

---

### 2. Install dependencies

```bash
flutter pub get
```

---

### 3. Run the application

```bash
flutter run
```

---

## 📁 Project Structure (MVVM)

```text
lib/
├── main.dart                     # Firebase init + dependency wiring
├── app.dart                      # Root widget, owns ViewModels, auth gate
├── core/theme/app_theme.dart
├── data/
│   ├── models/                   # AppUser, Article, AuthFailure
│   ├── services/auth_service.dart        # Firebase + Google SDK calls only
│   └── repositories/             # AuthRepository, ArticleRepository
└── ui/
    ├── auth/   login_view + login_viewmodel + session_viewmodel
    └── home/   medium_home_view + article_view + home_viewmodel
```

View -> ViewModel (ChangeNotifier) -> Repository -> Service. Views never import Firebase.

---

## 🔐 Enabling Google & Facebook sign-in

1. **Firebase console > Authentication > Sign-in method**: enable **Google** and **Facebook**.
2. **Google**
   * Add your Android **SHA-1 and SHA-256** (debug *and* release) under Project settings > Your apps:
     `cd android && ./gradlew signingReport`
   * Re-download `google-services.json` and `GoogleService-Info.plist` (they must now contain an `oauth_client` / `CLIENT_ID`).
   * iOS: paste `REVERSED_CLIENT_ID` from the plist into `ios/Runner/Info.plist` (placeholder is already there).
   * If Android still reports a missing client ID, run with the **Web client ID**:
     `flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=<id>.apps.googleusercontent.com`
3. **Facebook**
   * Create an app on developers.facebook.com, enable *Facebook Login*.
   * Put its App ID + App Secret in the Firebase Facebook provider.
   * Copy the OAuth redirect URI shown by Firebase
     (`https://oauthfirebaseflutter-f9872.firebaseapp.com/__/auth/handler`)
     into Facebook Login > Valid OAuth Redirect URIs.
   * No Facebook SDK is used: Firebase runs the OAuth flow in a browser tab.

## 🧪 Tests

```bash
flutter test
```

---

## 📱 Supported Platforms

* Android
* iOS

---

## 🛠 Development

To regenerate Firebase platform configuration:

```bash
flutterfire configure
```

---

## 📄 License

This project is licensed under the MIT License.
