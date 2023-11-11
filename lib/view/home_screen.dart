import 'package:flutter/material.dart';
import 'package:mynote/controller/provider.dart';
import 'package:mynote/model/note.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note App'),
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, _) {
          return StreamBuilder<List<Note>>(
            stream: noteProvider.getNotesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Note> notes = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(notes[index].title),
                      subtitle: Text(notes[index].content),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          //noteProvider.deleteNote(notes[index].id);
                        },
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the note creation screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNotePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CreateNotePage extends StatefulWidget {
  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _contentController.text.isNotEmpty) {
                  final note = Note(
                    title: _titleController.text,
                    content: _contentController.text,
                    timestamp: DateTime.now(),
                  );

                  Provider.of<NoteProvider>(context, listen: false)
                      .addNote(note);
                  Navigator.pop(context);
                } else {
                  // Show an error message if title or content is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Title and content cannot be empty.'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
