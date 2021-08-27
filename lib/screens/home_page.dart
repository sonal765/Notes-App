import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../db/database_provider.dart';
import '../model/notes_model.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }


  //getting all the notes
  getNotes() async {
    final notes = await DatabaseProvider.db.getNotes();
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes'),
        
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow[900],
        onPressed: () {
          //let's navigate to the note creation screen
          Navigator.pushNamed(context, "/AddNote");
        },
        child: Icon(Icons.note_add),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: !isloggedin? Center(child: CircularProgressIndicator(),): FutureBuilder(
          future: getNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.data == Null) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 150),

                        // height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/home.png"),
                              fit: BoxFit.fitWidth),
                        ),
                      ),
                      Text(
                        "You don't have any notes yet, create one",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ]));
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occured',
                    style: TextStyle(fontSize: 18),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {
                // Extracting data from snapshot object
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      //setting the different items
                      String title = snapshot.data[index]['title'];
                      String body = snapshot.data[index]['body'];
                      String date = snapshot.data[index]['date'];
                      int id = snapshot.data[index]['id'];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, "/ShowNote",
                                arguments: NoteModel(
                                  title: title,
                                  body: body,
                                  date: DateTime.parse(date),
                                  id: id,
                                ));
                          },
                          title: Text(title),
                          subtitle: Text(body),
                        ),
                      );
                    },
                  ),
                );
              }
            }

            return Center(
              child: Text("You don't have any notes yet, create one"),
            );
          },
        ),
      ),
    );
  }
}
