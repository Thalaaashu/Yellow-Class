import 'dart:async';
//import 'dart:io';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:mymovies/note.dart';
import 'package:mymovies/note_list.dart';

import 'Note_details.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      // drawer: NavDrawer(),
      appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.red],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          title: Text(
            "My Movies",
            // AppLocalizations.of(context).homePage_title,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      body: mybody(context),
    ));
  }

  //Body Widget
  Widget mybody(context1) {
    return (Stack(children: <Widget>[
      new Container(
        height: ((MediaQuery.of(context1).size.height) - 94 - 10),
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage(
              "images/back2.jpg",
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.8), BlendMode.srcATop),
          ),
        ),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: 10,
        ),
//Save New Record Container
        InkWell(
//Container show 600  millisends late 
            child: DelayedDisplay(
                delay: Duration(milliseconds: 600),
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.only(
                    top: 40,
                  ),
                  width: ((MediaQuery.of(context).size.width)),
                  height: 100,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.red],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                      border: Border.all(
                        color: Colors.cyanAccent,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: DelayedDisplay(
                      delay: Duration(milliseconds: 650),
                      child: Text(
                        // AppLocalizations.of(context).dashboard,
                        "Add movie",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                )),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NoteDetail(Note("", "", ""), "Add Movie")));
            }),
//Get Saved record container
        InkWell(
            child: DelayedDisplay(
                delay: Duration(milliseconds: 600),
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.only(
                    top: 40,
                  ),
                  width: ((MediaQuery.of(context).size.width)),
                  height: 100,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.red],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                      border: Border.all(
                        color: Colors.cyanAccent,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: DelayedDisplay(
                      delay: Duration(milliseconds: 650),
                      child: Text(
                        // AppLocalizations.of(context).dashboard,
                        "Get saved Movie",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                )),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NoteList()));
            }),

      ]),
    ]));
  }
}
