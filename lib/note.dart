
//Model Class for Movie Details
class Note {
  int _id;
  String _title;//for movie Name
  String _description;//For Director Name
  
  String _recordType;//For Image Storing
 
//Class Constructor for  assigning Values
  Note(
    this._title,
    this._recordType,
    this._description,
  );
//Named Constructor
  Note.withId(
    this._id,
    this._title,
    this._recordType,
    this._description,
  );
//Get the values
  int get id => _id;
  
  String get title => _title;

  String get description => _description;

  String get recordType => _recordType;

 //For Set the values
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set recordType(String newRecordType) {
    this._recordType = newRecordType;
   
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['recordType'] = _recordType;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._recordType = map['recordType'];
  }
}
