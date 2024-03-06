import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({
    Key? key,
  }) : super(key: key);

  CollectionReference users = FirebaseFirestore.instance.collection("user");
  var name = "";

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> users =
        FirebaseFirestore.instance.collection("user").snapshots();

    CollectionReference usersW = FirebaseFirestore.instance.collection('user');
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Utenti",style: TextStyle(fontWeight: FontWeight.bold,fontSize:35),),
              SizedBox(height: 30),
              /*TextFieldContainer(
                child: (TextField(
                  onChanged: ((value) {
                    name = value;
                  }),
                  obscureText: false,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        size: 20,
                      ),
                      hintText: "User",
                      contentPadding: EdgeInsets.only(
                        bottom: 25 / 2, // HERE THE IMPORTANT PART
                      ),
                      border: InputBorder.none),
                )),
              ),
              ElevatedButton(
                  onPressed: () async {
                    usersW.add({'name': name});
                  },
                  child: Text("Add User")),*/
            
                  StreamBuilder<QuerySnapshot>(
                          
                              stream: users,
                              builder: (
                                
                                BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot,
                              ) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text("Loading");
                                }
                                final data = snapshot.requireData;

                                

                                return ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                    itemCount: data.size,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text("${data.docs[index]['name']}"),
                                        leading: Icon(Icons.person,size: 50,),
                                      );
                                    });
                              }),
               
                      
                  
              
              
              
            ],
                  ),
                ),
          )),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 50,
        width: size.width * 0.8,
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: child);
  }
}
