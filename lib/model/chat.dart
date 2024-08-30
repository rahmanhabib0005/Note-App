class Chat {
  final String message;
  final String chatroomId;
  final String userId;
  final String userName;

  Chat(
      {required this.message,
      required this.chatroomId,
      required this.userId,
      required this.userName});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      message: json['message'] ?? 'N/A',
      chatroomId: json['chatroom_id'].toString(),
      userId: json['user_id'].toString(),
      userName: json['user']['name'],
    );
  }
}
