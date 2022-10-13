import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_page.dart';
import 'chat_page.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthOrAppPage extends StatelessWidget {
  // Construtor
  const AuthOrAppPage({Key? key}) : super(key: key);

  // Metodos
  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
    await Provider.of<ChatNotificationService>(
      context, 
      listen: false,
      ).init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          return StreamBuilder<ChatUser?>(
            stream: AuthService().userChanges,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingPage();
              } else {
                return snapshot.hasData ? const ChatPage() : const AuthPage();
              }
            },
          );
        }
      },
    );
  }
}

/*
// Pagina / Screen

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:flutter/material.dart';

import '../core/services/auth/auth_service.dart';
import 'auth_page.dart';
import 'chat_page.dart';

class AuthOrAppPage extends StatelessWidget {
  // Construtor
  const AuthOrAppPage({Key? key}) : super(key: key);

  // Metodo
  Future<void> init(BuildContext context) async {
    // Inicializar Aplicação Firebase
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        } else {
          return StreamBuilder<ChatUser?>(
            stream: AuthService().userChanges,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingPage();
              } else {
                return snapshot.hasData ? ChatPage() : AuthPage();
              }
            },
          );
        }
      },
    );
  }
}
*/