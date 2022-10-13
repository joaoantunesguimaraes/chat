import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:chat/pages/auth_or_app_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatNotificationService(),
        ),
      ],
      child: MaterialApp(
        title: 'Bindsolutions chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthOrAppPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
