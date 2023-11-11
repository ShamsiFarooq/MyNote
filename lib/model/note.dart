import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String title;
  final String content;
  final DateTime timestamp;

  Note({
    required this.title,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory Note.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError("Map cannot be null");
    }
    return Note(
      title: map['title'] as String,
      content: map['content'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
