import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/routes/app_pages.dart';
// import 'package:scrap_agent/app/modules/bottomnavbar/views/bottomnavbar.dart';
// import 'package:scrap_agent/app/modules/login/views/login.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('user provisional granted permission');
    } else {
      Get.snackbar('Notification Permission Denied',
          'Please allow notifications to recieve updates',
          snackPosition: SnackPosition.TOP);
      Future.delayed(const Duration(seconds: 3), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
  }

  Future<String> getDeviceToken() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, sound: true);
    String? token = await messaging.getToken();
    log('token=>$token');
    return token!;
  }

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitSetting =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitSetting = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitSetting,
      iOS: iosInitSetting,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen(
      (message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification!.android;

        if (kDebugMode) {
          print("notification title: ${notification!.title}");
          print("notification body: ${notification.body}");
        }
        if (Platform.isIOS) {
          iosForegroundMessage();
        }
        if (Platform.isAndroid) {
          initLocalNotification(context, message);
          // handleMessage(context, message);
          showNotification(message);
        }
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.high,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: "Channel Description",
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            sound: channel.sound);

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
        payload: "My_data",
      );
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        handleMessage(context, message);
      },
    );
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message != null && message.data.isNotEmpty) {
          handleMessage(context, message);
        }
      },
    );
  }

  Future<void> handleMessage(
      BuildContext context, RemoteMessage message) async {
    Get.offAllNamed(Routes.BOTTOMNAVIGATIONBAR);
  }

  Future iosForegroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }
}
