import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../features/admin/screens/order_requests_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling background messaging: ${message.messageId}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static const String _adminDocId = 'user_sukhjinder_singh';

  static const AndroidNotificationChannel _orderChannel = AndroidNotificationChannel(
    'pal_jewellers_orders',
    'Order Inquiries & Updates',
    description: 'Instant alerts for customer order requests at Pal Jewellers',
    importance: Importance.high,
    playSound: true,
  );

  Future<void> initialize() async {
    final NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint("Notifications permission denied by user.");
      return;
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationClick(response.payload);
      },
    );

    if (!kIsWeb && Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_orderChannel);
    }

    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handlePayloadNavigation(message.data);
    });

    final RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handlePayloadNavigation(initialMessage.data);
    }

    _fcm.onTokenRefresh.listen((newToken) {
      _saveTokenToFirestore(newToken);
    });
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _orderChannel.id,
          _orderChannel.name,
          channelDescription: _orderChannel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data['screen'] ?? '/admin/orders',
    );
  }

  void _handleNotificationClick(String? payload) {
    if (payload == '/admin/orders') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const OrderRequestsScreen()),
      );
    }
  }

  void _handlePayloadNavigation(Map<String, dynamic> data) {
    if (data['screen'] == '/admin/orders') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const OrderRequestsScreen()),
      );
    }
  }

  Future<void> registerAdminToken() async {
    try {
      final String? token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToFirestore(token);
        debugPrint("FCM Admin Token Registered: $token");
      }
    } catch (e) {
      debugPrint("Error registering FCM token: $e");
    }
  }

  Future<void> _saveTokenToFirestore(String token) async {
    final docRef = _firestore.collection('admin_fcm_tokens').doc(_adminDocId);
    await docRef.set({
      'role': 'admin',
      'ownerName': 'Sukhjinder Singh',
      'fcmTokens': FieldValue.arrayUnion([token]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeAdminToken() async {
    try {
      final String? token = await _fcm.getToken();
      if (token != null) {
        await _firestore.collection('admin_fcm_tokens').doc(_adminDocId).update({
          'fcmTokens': FieldValue.arrayRemove([token]),
        });
        debugPrint("FCM Admin Token removed.");
      }
    } catch (e) {
      debugPrint("Error removing FCM token: $e");
    }
  }
}