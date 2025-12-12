import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'service/favorites_service.dart';
import 'view/home_screen.dart';
import 'firebase_options.dart';
import 'service/notification_service.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  await NotificationService().init(notificationsPlugin);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FavoritesService())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    NotificationService().scheduleDailyRecipeNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService().showNotification(
        message.notification?.title ?? "Recipe",
        message.notification?.body ?? "Check today's recipe!",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NotificationService.navigatorKey,
      title: 'MealDB Recipes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
