//import 'dart:async';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io' as Io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mymovies/database_helper.dart';
//import 'package:mymovies/utility.dart';
import 'homepage.dart';
import 'main.dart';

import 'note.dart';
import 'note_list.dart';
//import 'package:intrest_calculator/SimpleIntrest.dart';

//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
 
  final _formKey1 = GlobalKey<FormState>();

  DatabaseHelper helper = DatabaseHelper();
  

  String appBarTitle;
  Note note;
  
  var bytes;
  

  TextEditingController titleController = TextEditingController();//Controller for Name 
  TextEditingController descriptionController = TextEditingController();//Controller for Director 


  TextEditingController recordtypeController = TextEditingController();//Controller for Image if required

  NoteDetailState(this.note, this.appBarTitle);
  @override
  void dispose() {
    super.dispose();
  }
//Image Picker Code for store and recieve image and Conver in String
  pickImageFromGallery()  {
    setState(() {
      bytes = null;
    });
    final ImagePicker _picker = ImagePicker();
    _picker.pickImage(source: ImageSource.gallery).then((imgFile) {
      setState(() {
        bytes = Io.File(imgFile.path).readAsBytesSync();
        String img64 = base64Encode(bytes);

       
        note.recordType = img64;
      });
     

     
    });
  }
  BuildContext context1;
  @override
  Widget build(BuildContext context) {
  
context1=context;
    titleController.text = note.title;

    descriptionController.text = note.description;
    note.recordType != ""
        ? bytes = base64Decode(note.recordType)
        : bytes = null;

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(appBarTitle),
              // backgroundColor: Colors.blueAccent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.red],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }),
            ),
            body: Stack(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                child: Form(
                  key: _formKey1,
                  child: ListView(
                    children: <Widget>[


                      // Form field for name
                      Container(
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 5),
                            child: TextFormField(
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              validator: (String input) {
                                if (input.isEmpty) return "Please Enter Input";
                              },
                              controller: titleController,
                              // style: textStyle,
                              onChanged: (value) {
                                // debugPrint('Something changed in Title Text Field');
                                updateTitle();
                              },
                              decoration: InputDecoration(
                                  labelText: "Movie Name",
                                  // labelStyle: textStyle,
                                  prefixIcon: Icon(Icons.movie),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0))),
                            )),
                      ),
//Form Field for Director name
                      Container(
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 5),
                            child: TextFormField(
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              validator: (String input) {
                                if (input.isEmpty) return "Please Enter Input";
                              },
                              controller: descriptionController,
                              // style: textStyle,
                              onChanged: (value) {
                                // debugPrint('Something changed in Title Text Field');
                                updateDescription();
                              },
                              decoration: InputDecoration(
                                  labelText: "Director Name",
                                  // labelStyle: textStyle,
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0))),
                            )),
                      ),

//A Button For Image Recieving
                      Container(
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 5),
                              child: RaisedButton(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.camera,
                                          color: Colors.blue,
                                          //size: 36.0,
                                        ),
                                        bytes == null
                                            ? Text("Upload  photo")
                                            : Text("Change Photo")
                                      ]),
                                  onPressed: () {
                                    pickImageFromGallery();
                                  }))),

//Display Image in bellow of Button After Uploading

                      bytes != null
                          ? Container(
                              height: 200,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Image.memory(
                                    bytes,
                                    fit: BoxFit.cover,
                                  )))
                          : Container(),
           //Save and Reset Button Code
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: RaisedButton(
                                padding: const EdgeInsets.all(15),
                                color: Colors.redAccent,
                                textColor: Colors.white,
                                child: Text(
                                  "Save",
                                  //  textScaleFactor: 1.5,
                                ),
                                onPressed: () {
                                  setState(() {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    if (_formKey1.currentState.validate() &&
                                        bytes != null) {
                                      _formKey1.currentState.save();
                                     // moveToLastScreen();
                                      //  debugPrint("Save button clicked");
                                      _save();
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),

//Rest Button
                            Expanded(
                              child: RaisedButton(
                                padding: const EdgeInsets.all(15),
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Text(
                                  "Reset",
                                  // textScaleFactor: 1.5,
                                ),
                                onPressed: () {
                                  setState(() {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    //  _value = 1;

                                    note.recordType = ""; //_value.toString();

                                    titleController.text = "";
                                    descriptionController.text = "";

                                    titleController.text = note.title;
                                    note.description = "";

                                    note.title = "";
                                    bytes = null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ])));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the Movie Name 
  void updateTitle() {
    note.title = titleController.text;
  }
//Upladte Image 
  void updateRecordType() {
    // note.recordType = _value.toString();
  }

  // Update Director name
  void updateDescription() {
    note.description = descriptionController.text;
  }

//update pricipal

  // Save data to database
  void _save() async {
   // moveToLastScreen();

    int result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showAlertDialog("Sucess", "Saved");
     // moveToLastScreen();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NoteList()));
    } else {
      // Failure
      _showAlertDialog("Not Saved", "problem Saving");
    }
  }
//Delete Data from Database
  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog("Not deleted", "No Record Found");
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog("Sucess", "Record Deleted");
    } else {
      _showAlertDialog("Failed", "Failed to delet");
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context1, builder: (_) => alertDialog);
  }
}
