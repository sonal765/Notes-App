import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

import '../db/database_provider.dart';
import '../model/notes_model.dart';
import 'edit_page.dart';

enum ConfirmAction { Cancel, Accept }

class ShowNote extends StatefulWidget {
  @override
  _ShowNoteState createState() => _ShowNoteState();
}

class _ShowNoteState extends State<ShowNote> {
  @override
  void initState() {
    super.initState();
    refreshDataList();
  }

  refreshDataList() {
    setState(() {
      DatabaseProvider.db.getDbData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final NoteModel note =
        ModalRoute.of(context).settings.arguments as NoteModel;

    void updateNote(int id, String body) async {
      bool result =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return EditPage(id, body);
      }));
      if (result == true) {
        refreshDataList();
      }
    }

    Future<ConfirmAction> _confirm(BuildContext ctx) async {
      return showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete This Note?'),
            content: const Text('This will delete the note from your device.'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.Cancel);
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  DatabaseProvider.db.deleteNote(note.id);
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/home", (route) => false);
                },
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Note'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.content_copy),
              onPressed: () async {
                await FlutterClipboard.copy(note.body);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✓   Copied to Clipboard')),
                );
              },
            ),
          ),
          IconButton(
              onPressed: () {
                updateNote(note.id, note.body);
              },
              icon: Icon(Icons.edit)),
          IconButton(
            onPressed: () async {
              final ConfirmAction action = await _confirm(context);
              print("Confirm Action $action");
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              note.title,
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              note.body,
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
