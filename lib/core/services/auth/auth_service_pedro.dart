// Classe com os metodos e serviços
// que vamos necessitar na parte de Autenticação
/*
import 'dart:io';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_firebase_service.dart';

//import 'auth_mock_service.dart';

abstract class AuthService {
  // Metodos
  // Metodo Getter
  ChatUser? get currentUser;

  // Metodo Getter
  // Stream --
  Stream<ChatUser?> get userChanges;

  // Metodo onde vai ser alterado o Estado
  Future<void> signup(
    String nome,
    String email,
    String password,
    File? image,
  );

  // Metodo onde vai ser alterado o Estado
  Future<void> login(
    String email,
    String password,
  );

  // Metodo onde vai ser alterado o Estado
  Future<void> logout();

  // Construtor Factory
  // Não necessitamos de retornar uma instância da Classe "AuthService" - Classe Generica
  // Posso retornar o "AuthMockService"
  // Posso retornar uma Implementação
  // 
  factory AuthService() {
    //return AuthMockService();
    return AuthFirebaseService();
  }
}
*/