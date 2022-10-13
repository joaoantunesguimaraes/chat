import 'dart:io';
import 'dart:async';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  ChatUser? get currentUser {
    return _currentUser;
  }

  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final auth = FirebaseAuth.instance;
    late UserCredential credential;

    //try {
    credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    //if (credential.user == null) return;

    // 1 - Upload da Foto do Utilizador
    //final imageName = '${credential.user!.uid}.jpg';
    //final imageURL = await _uploadUserImage(image, imageName);
    // 2 - Atualizar os atributos do Utilizador
    //credential.user?.updateDisplayName(name);
    //credential.user?.updatePhotoURL(imageURL);
    /*} on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }*/
    if (credential.user == null) return;

    // 1 - Upload da Foto do Utilizador
    //final imageName = '${credential.user!.uid}.jpg';
    final imageName = '${credential.user!.uid}.jpg';
    final imageURL = await _uploadUserImage(image, imageName);
    // 2 - Atualizar os atributos do Utilizador
    await credential.user?.updateDisplayName(name);
    await credential.user?.updatePhotoURL(imageURL);
    // 3- Gravar utilizador na Base de Dados (Firestore) não relacional (Opcional)
    _currentUser = _toChatUser(credential.user!, name, imageURL);
    await _saveChatUser(_currentUser!);
  }

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((err) {
      print('Error: $err'); // Prints 401.
      print('Error: $err.code'); // Prints 401.
      print('Error: $err.message'); // Prints 401.;
    });
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    // Storage Bucket
    final imageRef = storage.ref().child('user_images').child(imageName);
    //final imageRef = storage.ref().child(imageName);
    try {
      final listResult = await imageRef.listAll();
    } on FirebaseException catch (e) {
      // Caught an exception from Firebase.
      print("Failed with error '${e.code}': ${e.message}");
    }

    // Upload do ficheiro
    await imageRef.putFile(image).whenComplete(() => {});
    return await imageRef.getDownloadURL();
  }

  Future<void> _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageURL': user.imageURL,
    });
  }

  // Metodo Estatico - Metodo de Classe (Java)
  // Parâmetro Opcional
  static ChatUser _toChatUser(User user, [String? name, String? imageURL]) {
    return ChatUser(
      id: user.uid,
      name: name ?? user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageURL: imageURL ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}
