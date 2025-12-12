import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../service/api_service.dart';
import '../view/meal_detail_screen.dart';
import '../model/meal_details.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  FlutterLocalNotificationsPlugin? _notificationsPlugin;

  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init(FlutterLocalNotificationsPlugin plugin) async {
    _notificationsPlugin = plugin;

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin?.initialize(initializationSettings);
  }

  Future<void> scheduleDailyRecipeNotification() async {
    // Wait 5 seconds
    await Future.delayed(const Duration(seconds: 5));

    final meal = await ApiService().getRandomMeal();
    if (meal == null) return;

    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      _showWebNotification(meal);
      return;
    }

    // For Android/iOS, show a local notification
    await showNotification('Meal of the day!', meal.name, payload: meal.id);
  }

  Future<void> showNotification(
    String title,
    String body, {
    String? payload,
  }) async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'daily_recipe_channel',
      'Daily Recipe',
      channelDescription: 'Daily recipe notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin?.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  void _showWebNotification(MealDetails meal) {
    if (navigatorKey.currentContext == null) return;

    showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => AlertDialog(
        title: Text('Meal of the day! (${meal.name})'),
        content: meal.thumb.isNotEmpty
            ? Image.network(meal.thumb, height: 150)
            : null,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(navigatorKey.currentContext!);
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(navigatorKey.currentContext!);
              _openMealDetail(meal.id);
            },
            child: const Text('Visit Page'),
          ),
        ],
      ),
    );
  }

  void _openMealDetail(String mealId) {
    if (navigatorKey.currentContext != null) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: mealId)),
      );
    }
  }
}
