# Movement

Movement is an app all about (surprise) moving. It's an iOS app that tracks your daily movement and activity.

## Demo

https://github.com/user-attachments/assets/a1ad1890-c3ec-4db3-a63b-0dcf1ed68175

## Tech Stack
 
- **SwiftUI** -  Declarative UI, for building user interfaces on iOS
- **Firebase Auth** - Email/password authentication 
- **Cloud Firestore** - User profile storage
- **HealthKit** - Step count, heart rate, and active energy data

## Setup
 
1. Clone the repository
 
   ```bash
   git clone https://github.com/jarvin-s/movement.git
   cd movement
   ```
 
2. Open the project in Xcode
 
   ```bash
   open health-and-lifestyle.xcodeproj
   ```
 
3. Add your `GoogleService-Info.plist` to the project root (excluded from version control, see `.gitignore`)
 
4. Firebase dependencies are managed via the Swift Package Manager and will resolve automatically on first build
 
5. Run the app on a real device to access HealthKit data (simulator support is limited)
