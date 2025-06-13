Hangman – Flutter Word Guessing Game

A fun and classic Hangman game built in **Flutter**, where players guess letters to uncover hidden words before the hangman is complete.

---

# 📁 Project Structure

```
hangman-main/
├── android/
│   ├── build.gradle.kts
│   ├── settings.gradle.kts
│   └── app/
│       ├── build.gradle.kts
│       └── src/
│           └── main/
│               ├── AndroidManifest.xml
│               └── kotlin/com/example/hangman/
│                   └── MainActivity.kt
├── lib/
│   └── main.dart              # Entry point and game logic
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
└── README.md
```

---

# 🎮 Screenshots

<p float="left"> <img src="https://github.com/user-attachments/assets/dc8784db-37e2-4015-b608-233abe79babf" width="200" /> <img src="https://github.com/user-attachments/assets/0f7b13de-0397-4bdd-87bf-1d45c05ffc7f" width="200" /> <img src="https://github.com/user-attachments/assets/7ef8bcae-b5a8-4088-97e6-db7249f8ab39" width="200" /> <img src="https://github.com/user-attachments/assets/2daf1de2-e478-4ab6-9a07-cd9489b45c5f" width="200" /> <img src="https://github.com/user-attachments/assets/4459e4a4-2650-4919-ad84-6ff7cb7c4c0e" width="200" /> <img src="https://github.com/user-attachments/assets/0a10223f-2077-4f76-9502-3d1e9a796a12" width="200" /> </p>

</p>

---

# ✨ Features

* 🔠 Guess letters to complete the word
* ⚰️ Classic hangman scaffold visualization
* 🎯 Letter tap interactions with feedback
* 🚀 Smooth UI animations
* 📱 Built for both Android & iOS

---

# ⚙️ Setup Instructions

### 1. Prerequisites

```bash
flutter --version
# Recommended: Flutter 3.0.0 or higher
```

### 2. Clone the Repository

```bash
git clone <repository-url>
cd hangman-main
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run           # Launch on device/emulator
flutter build apk     # Build Android release
flutter build ios     # Build iOS release
```

---

# 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
```

---

# 🧠 Game Logic

The `main.dart` file includes:

* Random word selection
* Letter guess tracking
* UI updates for win/loss states
* Button interactions and scorekeeping

---

# 🧱 Design Philosophy

* 🧩 Simple, clean UI
* 🎉 Classic gameplay mechanics
* 🔁 Easy to enhance with difficulty, themes, sound, etc.

---

