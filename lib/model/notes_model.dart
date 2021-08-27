class NoteModel {
  int id;
  String title;
  String body;
  DateTime date;

  NoteModel({this.id, this.title, this.body, this.date});
  NoteModel.withId(
    this.id,
    this.body,
  );

  //create a function to convert our item to map
  // Map<String, dynamic> toMap() {
  //   return ({
  //     // "uid": uid,
  //     "id": id,
  //     "title": title,
  //     "body": body,
  //     "date": date.toString(),
  //   });
  // }

  // Converting a data list object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['title'] = title;
    map['body'] = body;
    map['date'] = date.toString();
    return map;
  }

  // Extract a Data List object from a Map object
  NoteModel.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.body = map['body'];
  }
}
