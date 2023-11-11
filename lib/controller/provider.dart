import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote/model/note.dart';

class NoteProvider extends ChangeNotifier {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  Future<void> addNote(Note note) async {
    await _notesCollection.add(note.toMap());
    notifyListeners();
  }

  Future<void> deleteNote(String noteId) async {
    await _notesCollection.doc(noteId).delete();
    notifyListeners();
  }

  Stream<List<Note>> getNotesStream() {
    return _notesCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>?))
            .toList();
      },
    );
  }
}
