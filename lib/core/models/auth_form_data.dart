// Classe

// ignore_for_file: constant_identifier_names

import 'dart:io';

enum AuthMode { Signup, Login }

class AuthFormData {
  // Atributos
  String name = '';
  String email = '';
  String password = '';
  File? image;
  AuthMode _mode = AuthMode.Login;

  // Metodos
  // Getter
  // Saber se estamos no modo Login
  bool get isLogin {
    return _mode == AuthMode.Login;
  }

  // Getter
  // Saber se estamos no modo Signup
  // Método desnecessário - temos o metodo isLogin
  bool get isSignup {
    return _mode == AuthMode.Signup;
  }

  // Getter
  // Metodo que alterna entre o modo Login e o modo Signup
  void toggleAuthMode() {
    _mode = isLogin ? AuthMode.Signup : AuthMode.Login;
  }

}
