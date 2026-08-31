# AI Study Planner (Flutter)

A Flutter app that helps students manage their study schedule with AI-powered planning:

───────────────────┬────────────────────────────────────────────────────────────────────────────────
Feature            │What it does                                                                    
───────────────────┼────────────────────────────────────────────────────────────────────────────────
**Authentication** │Secure login with Firebase Auth, session persisted locally                   
───────────────────┼────────────────────────────────────────────────────────────────────────────────
**Dashboard**      │Daily study goal display + quick-access cards to all features                    
───────────────────┼────────────────────────────────────────────────────────────────────────────────
**Subject Manager**│Add / edit / delete subjects with difficulty ratings (1-5 levels)                
───────────────────┼────────────────────────────────────────────────────────────────────────────────
**Task Manager**   │Create tasks/exams with due dates, estimated time, and subject linking          
───────────────────┼────────────────────────────────────────────────────────────────────────────────
**AI Generator**   │One-tap AI schedule generation using Google Gemini API based on tasks and goals  
───────────────────┼────────────────────────────────────────────────────────────────────────────────
**Calendar**       │Interactive calendar view showing generated study blocks with completion tracking  
───────────────────┴────────────────────────────────────────────────────────────────────────────────

## Project structure

`lib/
  main.dart                  # entry point, Firebase initialization and app routing
  core/
    router.dart             # go_router configuration
    theme.dart              # colors & Material theme
    service.dart            # AI service integration
  models/
    schedule.dart           # schedule block data model
    subject.dart            # subject data model
    task.dart               # task data model
  providers/
    calendar.dart           # calendar state management
    subject.dart            # subject state management
  screens/
    auth.dart               # login/authentication screen
    dashboard.dart          # main dashboard with stats and navigation
    subjects.dart           # subject management screen
    tasks.dart              # task input screen
    generator.dart          # AI schedule generator screen
    calendar.dart           # interactive calendar view
  services/
    auth.dart               # Firebase authentication service
    dashboard.dart          # dashboard data services
  firebase_options.dart     # Firebase configuration
pubspec.yaml
`

## Getting started
1. **Install Flutter** (if you haven't): [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
2. **Set up Firebase project**:
   - Create a new project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password)
   - Create Firestore Database
   - Add Android/iOS apps to your Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place `google-services.json` in `android/app/`
   - Place `GoogleService-Info.plist` in `ios/Runner/`
3. **Create/copy the project**, then install dependencies:
   
   ```bash
   flutter pub get
   ```
4. **Configure your Google Gemini API key**:
   - Get an API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Replace `'YOUR_GEMINI_API_KEY'` in `lib/screens/generator.dart` with your actual API key
5. **Run it**:
   
   ```bash
   flutter run
   ```

## Required Firebase setup

### Android — `android/app/build.gradle`

Add the Google Services plugin:

```gradle
apply plugin: 'com.google.gms.google-services'
```

### Android — `android/build.gradle` (project level)

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

## How the AI Schedule Generation works
1. User adds subjects with difficulty ratings in Subject Manager.
2. User creates tasks/exams with due dates and estimated preparation time.
3. User sets their daily available study hours in their profile.
4. When user taps "Generate Schedule Now" in AI Generator:
   - App fetches all pending tasks from Firestore
   - App retrieves user's daily available hours
   - AI service sends this data to Google Gemini API
   - AI returns optimized time blocks for each task
   - App creates schedule entries in Firestore with start/end times
5. Calendar view displays the generated schedule blocks with completion tracking.

## Notes & next steps for production
* **API Key Security**: The Gemini API key is currently hardcoded in `generator.dart`. For production, move this to environment variables or a secure backend service.
* **Error Handling**: Add more robust error handling for API failures and network issues.
* **Enhanced AI Features**: Consider adding study reminders, difficulty-based time allocation, and break suggestions.
* **Offline Support**: Add local persistence for offline access to schedules and tasks.
* **Testing**: Add unit and widget tests for critical components.
* **Authentication**: Consider adding additional auth providers (Google Sign-in, etc.).

## Technologies Used
- **Flutter**: Cross-platform mobile development framework
- **Firebase**: Authentication and Firestore database
- **Riverpod**: State management
- **go_router**: Navigation and routing
- **Google Generative AI**: AI-powered schedule generation
- **table_calendar**: Interactive calendar widget
