// Implementação da classe Abstracta "core/service/auth/AuthService"
// Implementação Mockada

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  // Atributo Estatico - Variavel de Classe (Java)

  static final _defaultUser = ChatUser(
    id: '456',
    name: 'Ana',
    email: 'ana@gmail.com',
    imageURL: 'assets/images/avatar.png',
  );

  static Map<String, ChatUser> _users = {_defaultUser.email: _defaultUser};
  static ChatUser? _currentUser;
  // Controller
  static MultiStreamController<ChatUser?>? _controller;

  // Constante de Classe(Java)
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_defaultUser);
  });

  // Metodo Estatico - Metodo de Classe (Java)
  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }


  // Metodos

  // Metodo Getter
  ChatUser? get currentUser {
    return _currentUser;
  }

  // Metodo Getter
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  Future<void> signup(
      String name, String email, String password, File? image) async {
    final newUser = ChatUser(
      id: Random().nextDouble().toString(),
      name: name,
      email: email,
      imageURL: image?.path ?? 'assets/images/avatar.png',
    );

    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
  }

  Future<void> login(String email, String password) async {
    _updateUser(_users[email]);
  }

  Future<void> logout() async {
    _updateUser(null);
  }
}
