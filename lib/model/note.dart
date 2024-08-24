class Note {
  final String note;
  final String userName;
  final String email;

  Note({required this.note, required this.userName, required this.email});
}

class NoteUser {
  final String userName;
  final String email;

  NoteUser({
    required this.userName,
    required this.email,
  });
}
