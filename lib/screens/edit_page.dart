import 'package:flutter/material.dart';

import '../model/notes_model.dart';
import '../db/database_provider.dart';

class EditPage extends StatefulWidget {
  final int itemId;
  final String itembody;
  EditPage(this.itemId, this.itembody);
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController newTextController = new TextEditingController();
  DatabaseProvider databaseHelper = DatabaseProvider();

  @override
  void initState() {
    super.initState();
    setState(() {
      newTextController.text = widget.itembody;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Page"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                "Edit body",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: newTextController,
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.yellow[800]),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text(
                      'Cancel',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context, true);
                        //insertData();
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.yellow[800]),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text(
                      'Save',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        updateItem(
                            context, widget.itemId, newTextController.text);
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ));
  }



  void updateItem(BuildContext context, int itemId, String newItem) async {
    int result = await DatabaseProvider.db.updateNote(NoteModel.withId(itemId, newItem));
     print(result);
    Navigator.pop(context, true);
  }
}
