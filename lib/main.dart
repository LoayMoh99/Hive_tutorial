import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_tut/models/contact.dart';
import 'package:path_provider/path_provider.dart' as pathProv;
import 'contact_page.dart';

void main() async {
  final documentDirectory = await pathProv.getApplicationDocumentsDirectory();
  Hive.init(documentDirectory.path);
  //here we have to register out TyptAdapter
  //or it could be registered for a specific box only..
  Hive.registerAdapter(ContactAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Tutorial',
      home: FutureBuilder(
        future: Hive.openBox(
          'contacts',
          compactionStrategy: (int total, int deleted) {
            return deleted > 20;
          },
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else
              return ContactPage();
          } else
            return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  void dispose() {
    //compact aims to decrese any data holes; occured when delete or uppdateing data:
    //we can update compactStrategy in opening of the boxes;
    Hive.box('contacts').compact();
    Hive.close(); //this close all the opened boxes..
    super.dispose();
  }
}
