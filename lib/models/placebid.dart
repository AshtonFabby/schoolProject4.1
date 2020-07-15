import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class PlaceBid extends StatelessWidget{
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController(); 
  TextEditingController discriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: new AppBar(
        title: Text("Add job"),
      ),

      body: Padding(padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(  
                controller: nameController,                  
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(  
                controller: emailController,                  
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(  
                controller: titleController,                  
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'title',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              
              child: TextField( 
                controller: discriptionController, 
                maxLines: 8,                  
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Job discription',
                  
                ),
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Submit'),
                onPressed: () {
                  // postData();
                  Firestore.instance.collection('jobs').document()
                  .setData({ 'userName': nameController.text,'title': titleController.text, 'email': emailController.text, 'discription': discriptionController.text });
                  Navigator.pop(context);
                  
                },
              )
            ), 
          ],

        ),
      
      ),

    );
  }
}

// postData(){
//   Firestore.instance.collection('jobs').document()
//   .setData({ 'userName': 'fabby', 'email': 'fabby@fabby.com', 'discription': 'test12345' });

// }