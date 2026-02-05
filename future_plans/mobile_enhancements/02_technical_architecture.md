# 02. Technical Architecture - Mobile Enhancements

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Mobile Device                              │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Push UI         │  │ Biometric UI    │  │ Camera UI    │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Native Services                            │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ FCM/APNs        │  │ Local Auth      │  │ Image Picker │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Flutter Layer                              │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Push Service    │  │ Biometric Svc   │  │ Offline Svc  │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Backend                                   │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Push Gateway    │  │ Notification DB  │  │ Sync Service │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### New Flutter Packages Required

```yaml
dependencies:
  # Push notifications
  firebase_messaging: ^15.0.0
  flutter_local_notifications: ^17.0.0
  
  # Biometric authentication
  local_auth: ^3.0.0
  
  # Camera and image
  image_picker: ^1.0.0
  camera: ^0.10.0
  image_cropper: ^5.0.0
  
  # Offline
  connectivity_plus: ^7.0.0  # Existing, extend usage
```

### Domain Services

```dart
class PushNotificationService {
  Future<void> initialize() async {
    final messaging = FirebaseMessaging.instance;
    
    // Request permissions
    final settings = await messaging.requestPermission();
    
    // Get token
    final token = await messaging.getToken();
    await _registerToken(token);
    
    // Listen to messages
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });
  }
  
  Future<void> _registerToken(String token) async {
    await _apiClient.post('/api/push/register', data: {'token': token});
  }
  
  Future<void> updatePreferences(NotificationPreferences prefs) async {
    await _apiClient.put('/api/push/preferences', data: prefs.toJson());
  }
}

class BiometricService {
  Future<bool> isAvailable() async {
    return await _localAuth.canCheckBiometrics;
  }
  
  Future<bool> authenticate() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      return authenticated;
    } catch (e) {
      return false;
    }
  }
  
  Future<void> enableBiometric() async {
    await _biometricSettingsRepository.save(BiometricSettings(
      userId: _currentUser.id,
      enabled: true,
      type: await _getBiometricType(),
      timeoutSeconds: 30,
    ));
  }
}

class CameraService {
  Future<File?> capturePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    return image?.path != null ? File(image!.path) : null;
  }
  
  Future<File?> pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path != null ? File(image!.path) : null;
  }
  
  Future<File?> cropImage(File image) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
      ],
    );
    return cropped != null ? File(cropped.path) : null;
  }
}
```

### Push Notification Implementation

```dart
class FirebasePushService {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  
  Future<void> initialize() async {
    // Initialize local notifications
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(initializationSettings);
    
    // Request permissions
    await _messaging.requestPermission();
    
    // Get FCM token
    final token = await _messaging.getToken();
    await _registerToken(token);
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });
    
    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _navigateToScreen(message);
    });
  }
  
  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = AndroidNotificationDetails(
      'default_channel',
      'Form Notifications',
      channelDescription: 'Notifications for form updates',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    _localNotifications.show(
      message.hashCode,
      notification?.title,
      notification?.body,
      NotificationDetails(android: android),
      payload: message.data.toString(),
    );
  }
}
```

### Biometric Authentication

```dart
class BiometricAuthService {
  final LocalAuthentication _localAuth;
  
  Future<bool> authenticate() async {
    try {
      final result = await _localAuth.authenticate(
        localizedReason: 'Sign in to your account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      return result;
    } on PlatformException catch (e) {
      if (e.code == 'not_available') {
        // Biometrics not available
        return false;
      } else if (e.code == 'not_enrolled') {
        // No biometrics enrolled
        return false;
      } else if (e.code == 'locked_out') {
        // Too many attempts
        return false;
      }
      return false;
    }
  }
  
  Future<void> enableBiometric(String userId) async {
    // Require password first
    final passwordVerified = await _verifyPassword();
    if (!passwordVerified) {
      throw PasswordVerificationFailedException();
    }
    
    // Save biometric settings
    await _settingsRepository.save(BiometricSettings(
      userId: userId,
      enabled: true,
      type: await _getAvailableBiometricType(),
      timeoutSeconds: 30,
    ));
  }
}
```

## Deployment Considerations

### Backend Requirements

1. **Push Notification Gateway**
   - Firebase Cloud Messaging (FCM)
   - Apple Push Notification Service (APNs)
   - Message queuing and delivery
   - Delivery tracking

2. **Notification Database**
   - Store notification history
   - User preferences
   - Delivery status
   - Retry logic

3. **Offline Sync**
   - Enhanced sync service
   - Conflict resolution
   - Background sync scheduling
   - Sync status tracking
