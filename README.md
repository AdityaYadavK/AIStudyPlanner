# AI Study Planner 

A Flutter app that helps students manage their study schedule with AI-powered planning. Get personalized study schedules generated instantly using Google Gemini AI.

##  Features

| Feature | Description |
|---------|-------------|
| **Authentication** | Secure login with Firebase Auth, sessions persisted locally |
| **Dashboard** | Daily study goal display + quick-access cards to all features |
| **Subject Manager** | Add, edit, or delete subjects with difficulty ratings (1-5 levels) |
| **Task Manager** | Create tasks/exams with due dates, estimated time, and subject linking |
| **AI Generator** | One-tap AI schedule generation using Google Gemini API |
| **Calendar** | Interactive calendar view showing study blocks with completion tracking |

##  Project Structure

```
lib/
├── main.dart                 # Entry point, Firebase initialization and routing
├── core/
│   ├── router.dart          # go_router configuration
│   ├── theme.dart           # Colors & Material theme
│   └── service.dart         # AI service integration
├── models/
│   ├── schedule.dart        # Schedule block data model
│   ├── subject.dart         # Subject data model
│   └── task.dart            # Task data model
├── providers/
│   ├── calendar.dart        # Calendar state management
│   └── subject.dart         # Subject state management
├── screens/
│   ├── auth.dart            # Login/authentication screen
│   ├── dashboard.dart       # Main dashboard with stats and navigation
│   ├── subjects.dart        # Subject management screen
│   ├── tasks.dart           # Task input screen
│   ├── generator.dart       # AI schedule generator screen
│   └── calendar.dart        # Interactive calendar view
├── services/
│   ├── auth.dart            # Firebase authentication service
│   ├── dashboard.dart       # Dashboard data services
│   └── firebase_options.dart # Firebase configuration
└── pubspec.yaml
```

##  Getting Started

### 1. Install Flutter
If you haven't already, install Flutter from [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

### 2. Set Up Firebase
- Create a new project at [Firebase Console](https://console.firebase.google.com/)
- Enable Authentication (Email/Password)
- Create a Firestore Database
- Add Android/iOS apps to your Firebase project
- Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- Place `google-services.json` in `android/app/`
- Place `GoogleService-Info.plist` in `ios/Runner/`

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Configure Google Gemini API
- Get an API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
- Replace `'YOUR_GEMINI_API_KEY'` in `lib/screens/generator.dart` with your actual key

### 5. Run the App
```bash
flutter run
```

##  Firebase Configuration

### Android — `android/app/build.gradle`
Add the Google Services plugin:
```gradle
apply plugin: 'com.google.gms.google-services'
```

### Android — `android/build.gradle` (Project Level)
Add Google Services classpath:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

### iOS — `ios/Runner/Info.plist`
No special permissions required for this app.

##  How AI Schedule Generation Works

1. **Add Subjects** → Add subjects with difficulty ratings in Subject Manager
2. **Create Tasks** → Add tasks/exams with due dates and estimated preparation time
3. **Set Study Hours** → Set your daily available study hours in your profile
4. **Generate Schedule** → Tap "Generate Schedule Now" in AI Generator
   - App fetches pending tasks from Firestore
   - Retrieves your daily available hours
   - Sends data to Google Gemini API
   - AI returns optimized time blocks for each task
   - App creates schedule entries in Firestore
5. **View Schedule** → Calendar displays generated blocks with completion tracking

##  Notes & Production Considerations

- **API Key Security** — The Gemini API key is currently hardcoded. For production, use environment variables or a secure backend service
- **Error Handling** — Add robust error handling for API failures and network issues
- **Enhanced Features** — Consider adding study reminders, difficulty-based time allocation, and break suggestions
- **Offline Support** — Add local persistence for offline access to schedules and tasks
- **Testing** — Add unit and widget tests for critical components
- **Authentication** — Consider adding additional auth providers (Google Sign-in, etc.)

##  Technologies Used

- **Flutter** — Cross-platform mobile development framework
- **Firebase** — Authentication and Firestore database
- **Riverpod** — State management
- **go_router** — Navigation and routing
- **Google Generative AI** — AI-powered schedule generation
- **table_calendar** — Interactive calendar widget

##  License

This project is open source and available under the MIT License.
