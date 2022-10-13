import 'dart:async';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  Stream<List<ChatMessage>> messagesStream() {
    // Atributos -Constante de Instância(Java)
    final store = FirebaseFirestore.instance;
    final snapshots = store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        ).orderBy('createdAt', descending: true)
        .snapshots();

    // return snapshots.map((snapshot) {
    //   return snapshot.docs.map((doc) {
    //     return doc.data();
    //   }).toList();
    // });

    return snapshots.map((snapshot) =>
      snapshot.docs.map((doc) =>
        doc.data()
      ).toList()
    );

    // return Stream<List<ChatMessage>>.multi((controller) {
    //   snapshots.listen((snapshot) {
    //     List<ChatMessage> lista =
    //         snapshot.docs.map((doc) => doc.data()).toList();
    //     controller.add(lista);
    //   });
    // });
  }

  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    final msg = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageURL,
    );

    final docRef = await store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .add(msg);

    // Snapshot
    final doc = await docRef.get();
    return doc.data()!;
  }

  Map<String, dynamic> _toFirestore(
    ChatMessage msg,
    SetOptions? options,
  ) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageURL': msg.userImageURL,
    };
  }

  ChatMessage _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return ChatMessage(
      id: doc.id,
      text: doc['text'],
      createdAt: DateTime.parse(doc['createdAt']),
      userId: doc['userId'],
      userName: doc['userName'],
      userImageURL: doc['userImageURL'],
    );
  }
}
