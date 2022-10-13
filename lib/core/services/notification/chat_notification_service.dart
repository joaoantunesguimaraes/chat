// Mixin

import 'package:chat/core/models/chat_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatNotificationService with ChangeNotifier {
  // Atributos
  final List<ChatNotification> _items = [];

  // Metodo Getter
  int get itemsCount {
    return _items.length;
  }

  // Metodo Getter
  List<ChatNotification> get items {
    // retorna um clone
    return [..._items];
  }

  void add(ChatNotification notification) {
    _items.add(notification);
    notifyListeners();
  }

  void remove(int i) {
    _items.removeAt(i);
    notifyListeners();
  }

  // Metodo - Inicializar as Push Notifications
  Future<void> init() async {
    await _configureTerminated();
    await _configureForeground();
    await _configureBackground();
  }

  // Permissão para executar Push Notifications
  Future<bool> get _isAutorized async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> _configureForeground() async {
    if (await _isAutorized) {
      FirebaseMessaging.onMessage.listen(_messageHandler);
    }
  }

  Future<void> _configureBackground() async {
    if (await _isAutorized) {
      FirebaseMessaging.onMessageOpenedApp.listen(_messageHandler);
    }
  }

  // Quando a A+plicação está Terminada
  Future<void> _configureTerminated() async {
    if (await _isAutorized) {
      //FirebaseMessaging.onMessageOpenedApp.listen(_messageHandler);
      // Pegar a mensagem inicial
      RemoteMessage? initialMsg =
          await FirebaseMessaging.instance.getInitialMessage();
      _messageHandler(initialMsg);
    }
  }

  void _messageHandler(RemoteMessage? msg) {
    if (msg == null || msg.notification == null) return;
    add(ChatNotification(
      title: msg.notification!.title ?? 'Não informado!',
      body: msg.notification!.body ?? 'Não informado!',
    ));
  }
}
