class Chat {
  final String message;
  final String chatroomId;
  final String userId;
  final String userName;

  Chat({
    required this.message,
    required this.chatroomId,
    required this.userId,
    required this.userName
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      message: json['message'],
      chatroomId: json['chatroom_id'],
      userId: json['user_id'],
      userName: json['user']['name'],
    );
  }
}
