import 'package:dars64_statemanagement/controllers/cart_controller.dart';
import 'package:dars64_statemanagement/controllers/products_controller.dart';
import 'package:dars64_statemanagement/firebase_options.dart';
import 'package:dars64_statemanagement/services/firebase_push_notifications_service.dart';
import 'package:dars64_statemanagement/views/screens/auth/login_screen.dart';
import 'package:dars64_statemanagement/views/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import '../views/screens/products_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebasePushNotificationsService.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return CartController();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ProductsController();
          },
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.amber,
            ),
            scaffoldBackgroundColor: Colors.white,
          ),
          home: const HomeScreen()

          // StreamBuilder(
          //   stream: FirebaseAuth.instance.userChanges(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //     return snapshot.data == null
          //         ? const LoginScreen()
          //         : ProductsScreen();
          //   },
          // ),
          ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    setupInteractedMessage();
  }

  // In this example, suppose that all messages contain a data field with the key 'type'.
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'background') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) {
            return ChatScreen(message: message);
          },
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) {
            return ProductsScreen();
          },
        ),
      );
    }
  }

  Future<String?> getFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    // print(fcmToken);
    return fcmToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: FilledButton(
              onPressed: getFCMToken,
              child: const Text("Get FCM Token"),
            ),
          ),
          Center(
            child: FilledButton(
              onPressed: () async {
                final token = await getFCMToken();
                FirebasePushNotificationsService.sendPushMessage(
                  recipientToken: token!,
                  title: "Hello Man",
                  body: "From my phone",
                );
              },
              child: const Text("Send Push Notification"),
            ),
          ),
        ],
      ),
    );
  }
}
