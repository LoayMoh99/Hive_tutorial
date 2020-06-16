import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_tut/models/contact.dart';

import 'new_contact_form.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hive Tutorial'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildListView()),
            NewContactForm(),
          ],
        ));
  }

//Here we have to read the data from the Hive database:
  Widget _buildListView() {
    //we used here WatchBuilder instead of StreamBuilder as it eaisier:
    return WatchBoxBuilder(
      box: Hive.box('contacts'),
      builder: (context, contactsBox) {
        final contactBox = Hive.box('contacts');
        return ListView.builder(
          itemCount: contactBox.length,
          itemBuilder: (BuildContext context, int index) {
            final contact = contactBox.getAt(index) as Contact;
            return ListTile(
              title: Text(contact.name),
              subtitle: Text(contact.age.toString()),
              trailing: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      final newContact = Contact(
                        '${contact.name}*',
                        contact.age + 1,
                      );
                      //instead of edit or update->we could overwite the value:
                      contactBox.putAt(index, newContact);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      contactBox.deleteAt(index);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
