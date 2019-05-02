import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment_03/service/todo.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String nametitle = "Todo";
  int _currentIndex = 0;
  List<Todo> list_undone = [];
  List<Todo> list_done = [];
  int lenall = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> listbtn = [
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          print("Pressed +");
          Navigator.pushNamed(context, "/add");
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          print("Del -");
        },
      ),
    ];
    final List<Widget> _children = [
      Center(
        child: _buildBody(context),
      ),
      Center(
        child: Center(
          child: Text("Done"),
        ),
      )
    ];
    return Scaffold(
      appBar: AppBar(
          title: Text("$nametitle"), actions: <Widget>[listbtn[_currentIndex]]),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text('Task'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.done_all),
            title: new Text('Completed'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('todo').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return new Center(
            child: Text("No data found..."),
          );
        ;

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final todo = Todo.fromSnapshot(data);

    return Padding(
      key: ValueKey(todo.id),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(todo.title),
          trailing: Checkbox(
            value: todo.done,
          ),
          onTap: () => Firestore.instance.runTransaction((transaction) async {
                final freshSnapshot = await transaction.get(todo.reference);
                final fresh = Todo.fromSnapshot(freshSnapshot);

                await transaction
                    .update(todo.reference, {'done': fresh.done = !todo.done});
              }),
        ),
      ),
    );
  }
}
