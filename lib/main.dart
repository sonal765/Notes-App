import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/welcome.dart';
import './screens/login_acreen.dart';
import './screens/signup_screen.dart';
import 'screens/home_page.dart';
import './screens/add_note.dart';
import './screens/display_note.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   runApp(MyApp());}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       theme: ThemeData(primaryColor: Colors.orange),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
     
      
      routes: <String, WidgetBuilder>{
         "Login": (BuildContext context) => Login(),
        "SignUp": (BuildContext context) => SignUp(),
        "start": (BuildContext context) => Start(),
        "/home": (context) => HomePage(),
        "/AddNote": (context) => AddNote(),
        "/ShowNote": (context) => ShowNote(),
      },
    );
  }
}



















// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'model.dart';
// import 'dataBase.dart';
// import 'itemCardWidget.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           brightness: Brightness.dark,
//           floatingActionButtonTheme: FloatingActionButtonThemeData(
//             backgroundColor: Colors.blue,
//           )),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final DbManager dbManager = new DbManager();

//   Model model;
//   List<Model> modelList;
//   TextEditingController input1 = TextEditingController();
//   TextEditingController input2 = TextEditingController();
//   FocusNode input1FocusNode;
//   FocusNode input2FocusNode;

//   @override
//   void initState() {
//     input1FocusNode = FocusNode();
//     input2FocusNode = FocusNode();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     input1FocusNode.dispose();
//     input2FocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sqlite Demo'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//               context: context,
//               builder: (context) {
//                 return DialogBox().dialog(
//                   context: context,
//                   onPressed: () {
//                     Model model = new Model(
//                         fruitName: input1.text, quantity: input2.text);
//                     dbManager.insertModel(model);
//                     setState(() {
//                       input1.text = "";
//                       input2.text = "";
//                     });
//                     Navigator.of(context).pop();
//                   },
//                   textEditingController1: input1,
//                   textEditingController2: input2,
//                   input1FocusNode: input1FocusNode,
//                   input2FocusNode: input2FocusNode,
//                 );
//               });
//         },
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//       ),
//       body: FutureBuilder(
//         future: dbManager.getModelList(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             modelList = snapshot.data;
//             return ListView.builder(
//               itemCount: modelList.length,
//               itemBuilder: (context, index) {
//                 Model _model = modelList[index];
//                 return ItemCard(
//                     model: _model,
//                     input1: input1,
//                     input2: input2,
//                     onDeletePress: () {
//                       dbManager.deleteModel(_model);
//                       setState(() {});
//                     },
//                   onEditPress: () {
//                     input1.text = _model.fruitName;
//                     input2.text = _model.quantity;
//                     showDialog(
//                         context: context,
//                         builder: (context) {
//                           return DialogBox().dialog(
//                               context: context,
//                               onPressed: () {
//                                 Model __model = Model(
//                                     id: _model.id,
//                                     fruitName: input1.text,
//                                     quantity: input2.text);
//                                 dbManager.updateModel(__model);

//                                 setState(() {
//                                   input1.text = "";
//                                   input2.text = "";
//                                 });
//                                 Navigator.of(context).pop();
//                               },
//                               textEditingController2: input2,
//                               textEditingController1: input1);
//                         });
//                   },
//                 );
//               },
//             );
//           }
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
// }

