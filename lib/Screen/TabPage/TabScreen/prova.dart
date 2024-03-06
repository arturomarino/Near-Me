import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  String _firstName = '';
  String _lastName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserisci i tuoi dati'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome',
              ),
              onChanged: (value) {
                setState(() {
                  _firstName = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Cognome',
              ),
              onChanged: (value) {
                setState(() {
                  _lastName = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            CupertinoButton(
              onPressed: () {
                // Azione da eseguire quando viene premuto il pulsante
                // Qui potresti, ad esempio, inviare i dati a un server o fare qualcos'altro con essi
                print('Nome: $_firstName, Cognome: $_lastName');
              },
              color: Colors.blue,
              child: Text(
                'Conferma',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
