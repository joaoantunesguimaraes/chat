// Componente
// Autenticação
import 'dart:io';

import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  // Atributo
  // Função que vai ser usada para passar os dados do formulário para o componente Pai
  final void Function(AuthFormData) onSubmit;

  // Construtor
  const AuthForm({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  // Para aceder aos dados do Formulário através duma  Chave Global
  final _formKey = GlobalKey<FormState>();
  // Classe AuthFormData() - ajudar a armazenar os dados do Formulário
  final _formData = AuthFormData();

  // Metodos
  void handleImagePick(File image) {
    _formData.image = image;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).errorColor,
        ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_formData.image == null && _formData.isSignup) {
      return _showError('Imagem não selecionada!');
    }
    // Para passar os dados para o componente Pai (components/auth_form)
    widget.onSubmit(_formData);
  }

  validateName(String n) {
    final name = n ?? '';
    if (name.trim().length < 5) {
      return 'Nome deve ter no mínimo 5 caracteres.';
    }
  }

  // Devia ser uma regexp
  validateEmail(String e) {
    final email = e ?? '';
    if (!email.contains('@')) {
      return 'Email Inválido.';
    }
  }

  validatePassword(String p) {
    final password = p ?? '';
    if (password.length < 6) {
      return 'Password deve ter no mínimo 6 caracteres.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_formData.isSignup)
                UserImagePicker(
                  onImagePick: handleImagePick,
                ),
              if (_formData.isSignup)
                TextFormField(
                  key: ValueKey('name'),
                  initialValue: _formData.name,
                  onChanged: (name) => _formData.name = name,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (name) => validateName(name!),
                ),
              TextFormField(
                key: ValueKey('email'),
                initialValue: _formData.name,
                onChanged: (email) => _formData.email = email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (email) => validateEmail(email!),
              ),
              TextFormField(
                key: ValueKey('password'),
                initialValue: _formData.password,
                onChanged: (password) => _formData.password = password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (password) => validatePassword(password!),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_formData.isLogin ? 'Entrar' : 'Cadastrar'),
              ),
              TextButton(
                child: Text(_formData.isLogin
                    ? 'Criar uma nova conta?'
                    : 'Já tem conta?'),
                onPressed: () {
                  setState(() {
                    _formData.toggleAuthMode();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
