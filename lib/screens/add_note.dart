import 'package:flutter/material.dart';

import '../model/notes_model.dart';
import '../db/database_provider.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  //create an add notes function
  String title;
  String body;
  DateTime date;
  //create input controller
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  addNote(NoteModel note) {
    DatabaseProvider.db.addNewNote(note);
    print("note added succesfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Note Title",
              ),
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: TextField(
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: "your note"),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
         backgroundColor: Colors.yellow[800],
        onPressed: () {
          setState(() {
            title = titleController.text;
            body = bodyController.text;
            date = DateTime.now();
          });
          NoteModel note = NoteModel(title: title, body: body, date: date);
          addNote(note);
          //now when we save the note it will automstically return to home page
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        },
        label: Text("Save Note"),
        icon: Icon(Icons.save),
      ),
    );
  }
}
