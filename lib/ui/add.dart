import 'package:flutter/material.dart';
import 'package:flutter_assignment_03/service/todo.dart';

String nametitle = "New Subject";
class Add extends StatefulWidget {
  AddfromState createState() {
    // TODO: implement createState
    return AddfromState();
  }
}
class AddfromState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _subject;
  String _pass;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("$nametitle"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25, 30, 25, 30),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Subject",
                  hintText: "Please fill Subject",
                  // icon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.text,
                onSaved: (subject) => print(subject),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill Subject";
                  } else {
                    _subject = value;
                  }
                },
              ),
              RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  print("save");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}