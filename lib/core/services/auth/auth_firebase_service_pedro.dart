// Implementação da classe Abstracta "core/service/auth/AuthService"
// Implementação Firebase

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;

  //static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    //_controller = controller;
    // firebase - Metodo authStateChanges()
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  // Metodo Getter
  ChatUser? get currentUser {
    return _currentUser;
  }

  // Metodo Getter
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    // Firebase instância - FirebaseAuth.instance
    final auth = FirebaseAuth.instance;

    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Firebase
    if (credential.user == null) return;

    // Firebase Metodo updateDisplayName - Actualiza o nome
    credential.user?.updateDisplayName(name);
    // Firebase Metodo updatePhotoURL - Actualiza a fotografia
    //credential.user?.updatePhotoURL(photoURL);
  }

  //_users.putIfAbsent(email, () => newUser);
  //_updateUser(newUser);

  Future<void> login(String email, String password) async {}

  Future<void> logout() async {
    // firebase - Logout
    FirebaseAuth.instance.signOut();
  }

// Metodo Estatico - Metodo de Classe
// converte uma Stream do Firebase numa Stream de Utilizador da nossa aplicação de Chat
  static ChatUser _toChatUser(User user) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageURL: user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}
