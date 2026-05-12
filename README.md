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

## 📁 Project Structure

```text
.
├── android/
├── ios/
├── lib/
│   ├── firebase_options.dart
│   └── main.dart
├── pubspec.yaml
└── README.md
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
