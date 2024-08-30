class Rooms {
  final dynamic roomId;
  final String roomName;

  Rooms({
    required this.roomId,
    required this.roomName,
  });

  factory Rooms.fromJson(Map<String, dynamic> json) {
    return Rooms(roomId: json['id'], roomName: json['name']);
  }
}
