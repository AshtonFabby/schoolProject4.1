import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_demo/models/todo.dart';
import 'package:flutter_login_demo/models/addJob.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_demo/models/placebid.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}
String userName;
String email;
String discription;
String title;

createAlertDialogue(BuildContext context){

    TextEditingController username = TextEditingController();
    TextEditingController ttc = TextEditingController();

    return showDialog(context: context,builder: (context){
      return AlertDialog(

        title: Text("Place Bid"),
        // content: TextField(
        //   controller: username,
        //   decoration: InputDecoration(hintText: "username"),
        // ), 
        content: SingleChildScrollView(child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          TextField(
            controller: username,
            decoration: InputDecoration(hintText: "username"),
          ), 
          TextField(
            controller: ttc,
            decoration: InputDecoration(hintText: "time to complete"),
          ),

        ],)
        
        ,),
        actions: <Widget>[
          MaterialButton(
            child: Text("submit"),            
            onPressed: (){
              // print(title);
              // print(username.text);
              // print(ttc.text);
              Firestore.instance.collection('bids').document()
              .setData({ 'projectId': title, 'bidder': username.text, 'ttc':ttc.text});
              Navigator.pop(context);
            })
        ],
        
      );

    });


  }
class _HomePageState extends State<HomePage> {
  List<Todo> _todoList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
 

  @override
  void initState() {
    super.initState();

  
  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _todoList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _todoList[_todoList.indexOf(oldEntry)] =
          Todo.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _todoList.add(Todo.fromSnapshot(event.snapshot));
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
  

  

  Widget showFirebaseData() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('jobs').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['userName']),
                  subtitle: new Text(document['title']),
                  onTap: () {
                          userName = document['userName'];
                          discription = document['discription'];
                          email = document['story'];
                          title = document['title'];

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SecondRoute()),
                          );
                        },
                );
              }).toList(),
            );
        }
      },
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Home'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
        body: showFirebaseData(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Addjob()),
            );
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }
}

class SecondRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Job"),
        ),
        body: Container(    
          padding: EdgeInsets.all(10.0),      
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
            
          children:<Widget>[
            Text(title,
            style:TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              ),
            ),  
             Text(userName,
              style:TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic
              ),
              
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child:Text(discription,
              style: TextStyle(fontSize:  18),
            ),
              
            ),
            Container(              
              padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Place Bid'),
                onPressed: () {
                  
                  
                  createAlertDialogue(context);
                  
                },
              )
            ), 
           
          ],
        ),

        )
        
        
        
        );
  }


}