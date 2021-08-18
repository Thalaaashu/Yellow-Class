import 'dart:async';

import 'dart:io' as Io;
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:mymovies/database_helper.dart';

import 'package:sqflite/sqflite.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Note_details.dart';
import 'homepage.dart';
import 'main.dart';
import 'note.dart';

enum ConfirmAction { Cancel, Accept }

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Note> noteList;
  int count = 0;

  //var emiPeriod1 = new List(500);//removed on

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (noteList == null) noteList = List<Note>();
    updateListView();
  }

  SnackBar _snackBar;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    // cal();

    return Scaffold(
      appBar: AppBar(
          title: Text("Saved Movies"),
          centerTitle: true,
          //  backgroundColor: Colors.blueAccent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.red],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                // Write some code to control things, when user press back button in AppBar
                // Navigator.pop(context, true);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              })),
      body: getNoteListView(),//Function For Show List
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          //debugPrint('FAB clicked');
          navigateToDetail(
              Note(
                '',
                '',
                '',
              ),
              "Add Movie");//floatingActionButton for Add new Record 
        },
        tooltip: "Add Movie",
        child: Icon(Icons.add),
      ),
    );
  }

//List View For List
  ListView getNoteListView() {
    // TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          //debugPrint("print  me");
          return Card(
              // color: getPriorityColor(position),
              elevation: 2.0,
              child: Column(children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    //color: Color(0xFF81D4FA),

                    child: Row(children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.movie,
                        color: Colors.amberAccent,
                        size: 36.0,
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
//To Displya Movie Name
                      Expanded(
                          child: Text(
                        "\n" +
                            "Movie Name" +
                            ":\t" +
                            this.noteList[position].title +
                            "\n",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      )),
//dvr Function for Edit and Delete Records
                      dvr(context, noteList[position], position)
                    ])),
//To Display Director name,Image
                ListTile(
                    subtitle: Container(
                        child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 36.0,
                        ),
                        Text("Director Name:\t" +
                            this.noteList[position].description),
                      ]),
//For Image Display
                  Container(
                      height: 200,
                      child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: //Text(this.noteList[position].recordType)
                              Image.memory(
                            // bytes,
                            base64Decode(this.noteList[position].recordType),
                            fit: BoxFit.cover,
                          )))
                  //Container(child:Image(image: image1),
                  // child: Utility.imageFromBase64String(
                  //   this.noteList[position].recordType),
                ])))
              ]));
        });
  }

  //Function For Delete and Edit Performance
  Widget dvr(context, Note note, int position) {
    Item selectedUser;
    List<Item> users = <Item>[
      /*const*/
      /*const*/ Item(
          "Edit",
          Icon(
            Icons.edit,
            color: const Color(0xFF167F67),
          )),
      /*const*/ Item(
          "Delete",
          Icon(
            Icons.delete,
            color: const Color(0xFF167F67),
          )),
    ];
    return DropdownButton<Item>(
      hint: Text("Option"),
      value: selectedUser,
      onChanged: (Item Value) {
        setState(() {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          selectedUser = Value;
          operation(selectedUser, note, context, position);
        });
        // operation(selectedUser,note);
      },
      items: users.map((Item user) {
        return DropdownMenuItem<Item>(
          value: user,
          child: Row(
            children: <Widget>[
              user.icon,
              SizedBox(
                width: 10,
              ),
              Text(
                user.name,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void operation(Item op, Note note, BuildContext context, int position) {
    //debugPrint('${op.name}');
    switch (op.name) {
      case 'Delete':
        _delete(context, note);

        //do here
        break;

      case 'Edit':
        navigateToDetail(note, 'Edit Record');
        //do here
        break;

      default:
      //no option
    }
  }

  void _delete(BuildContext context, Note note) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    int d = await _asyncConfirmDialog(context);
    //debugPrint("d vlue is $d");
    if (d == 1) {
      int result = await databaseHelper.deleteNote(note.id);
      if (result != 0) {
        _showSnackBar(context, "Record Deleted");
        updateListView();
      }
    }
  }

  Future<int> _asyncConfirmDialog(BuildContext context) async {
    int d = 10;
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Do you Want to delete"),
          content: Text("Conform Deletion"), //add const
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () {
                setState(() {
                  d = 0;
                });
                // d = 0;

                Navigator.of(context).pop();
                // d = 0;
              },
            ),
            FlatButton(
              child: Text("Delete"), //con
              onPressed: () {
                setState(() {
                  d = 1;
                });

                Navigator.of(context).pop();
                // d = 1;
              },
            )
          ],
        );
      },
    );
    return d;
  }
//show Snack Bar to display Msg
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
          // int i = count + 1; //noteList.length;
          // for (int j = 0; j <= i; j++) chekcval[j] = false;
        });
      });
    });
  }

  // Widget compounded() {}
}

class Item {
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}
