// Class de Utilizador "logado"

class ChatUser {
  final String id;
  final String name;
  final String email;
  final String imageURL;


  // Construtor com paâmetros nomeados
  const ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.imageURL,
  });
}