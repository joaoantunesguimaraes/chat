

class ChatMessage {
  // Atributos
  final String id;
  final String text;
  final DateTime createdAt;
  // Atributos relativos so Utilizador
  final String userId;
  final String userName;
  final String userImageURL;

  // Construtor
  const ChatMessage({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.userImageURL,
  });
}
