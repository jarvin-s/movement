# Movement

Movement is an app all about (surprise) moving. It's an iOS app that tracks your daily movement and activity.

### Tech Stack
 
- **SwiftUI** -  Declarative UI, built for iOS 18+
- **Firebase Auth** - Email/password authentication
- **Cloud Firestore** - User profile storage
- **Firebase Storage** - Asset storage
- **HealthKit** - Step count, heart rate, and active energy data with background delivery

### Setup
 
1. Clone the repository
 
   ```bash
   git clone https://github.com/your-username/movement.git
   cd movement
   ```
 
2. Open the project in Xcode
 
   ```bash
   open health-and-lifestyle.xcodeproj
   ```
 
3. Add your `GoogleService-Info.plist` to the project root (excluded from version control - see `.gitignore`)
 
4. Firebase dependencies are managed via Swift Package Manager and will resolve automatically on first build
 
5. Run the app on a real device to access HealthKit data (simulator support is limited)
