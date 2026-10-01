# Firebase Setup Guide for PlanPal

This guide explains how to configure Firebase Cloud Messaging (FCM) for push notifications in PlanPal.

## Prerequisites

1. A Firebase project (create one at https://console.firebase.google.com)
2. FlutterFire CLI installed: `dart pub global activate flutterfire_cli`

## Setup Steps

### 1. Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### 2. Login to Firebase

```bash
firebase login
```

### 3. Configure FlutterFire

Run the following command in the `app` directory:

```bash
flutterfire configure
```

This will:
- Select your Firebase project
- Register your Flutter app with Firebase
- Generate `firebase_options.dart` with your configuration
- Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

### 4. Android Configuration

The FlutterFire CLI should automatically add `google-services.json` to `android/app/`.

Verify that `android/build.gradle` has:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

And `android/app/build.gradle` has:

```gradle
apply plugin: 'com.google.gms.google-services'
```

### 5. iOS Configuration (if targeting iOS)

The FlutterFire CLI should add `GoogleService-Info.plist` to `ios/Runner/`.

You may need to add it manually in Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Drag `GoogleService-Info.plist` into the Runner folder
3. Make sure "Copy items if needed" is checked

### 6. Backend Configuration

Update your backend `.env` file with your Firebase credentials:

```env
# Firebase Admin SDK (for sending push notifications)
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project-id.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
```

To get these credentials:
1. Go to Firebase Console > Project Settings > Service Accounts
2. Click "Generate New Private Key"
3. Download the JSON file
4. Copy the values to your `.env` file

**Note:** The private key must be wrapped in quotes and include `\n` characters for line breaks.

### 7. Test Push Notifications

#### Android Testing

1. Build and run on a physical Android device:
   ```bash
   flutter run --release
   ```

2. Check logs for FCM token:
   ```
   FCM Token: xxxxxx...
   ```

3. Test sending a notification from the backend:
   ```bash
   curl -X POST http://localhost:3000/api/push/test \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     -d '{
       "title": "Test Notification",
       "body": "This is a test push notification"
     }'
   ```

#### Testing Scenarios

Test these scenarios:

1. **Foreground**: App is open and active
   - Should show in-app notification
   - Should appear in notifications list

2. **Background**: App is running but not visible
   - Should show OS notification
   - Tapping should open app and navigate to entity

3. **Terminated**: App is completely closed
   - Should show OS notification
   - Tapping should launch app and navigate to entity

## Troubleshooting

### Token Not Received

- Ensure you're testing on a physical device (emulator may have issues)
- Check Firebase project configuration
- Verify `google-services.json` is in the correct location
- Check app logs for initialization errors

### Notifications Not Appearing

- Check notification permissions are granted
- Verify FCM token is registered with backend
- Check backend logs for push sending errors
- Ensure Firebase service account credentials are correct

### Navigation Not Working

- Verify `globalNavigatorKey` is set on MaterialApp
- Check that entity types and IDs are valid
- Review navigation logs in app console

## Production Checklist

Before deploying to production:

- [ ] Firebase project is in production mode
- [ ] Backend service account credentials are secure
- [ ] Push notification privacy policy is added
- [ ] iOS push certificates are configured (if targeting iOS)
- [ ] Android signing is configured for release builds
- [ ] Test all notification scenarios on real devices
- [ ] Monitor FCM quota and usage
- [ ] Set up Firebase Analytics (optional but recommended)

## Resources

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [firebase_messaging Package](https://pub.dev/packages/firebase_messaging)
- [flutter_local_notifications Package](https://pub.dev/packages/flutter_local_notifications)
