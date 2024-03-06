import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final Stream<QuerySnapshot> _orderStream =
      FirebaseFirestore.instance.collection('Ordini').snapshots();

  @override
  Widget build(BuildContext context) {
    final bwColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    final background =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(236, 0, 0, 0)
            : Colors.white;
    final buttonColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(255, 20, 20, 20)
            : Colors.white;

    final textColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    return Scaffold(
      appBar: AppBar(
          title: Text("Storico Ordini"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _orderStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: GestureDetector(
                      onDoubleTap: () {},
                      child: Container(
                          decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.20),
                                  blurRadius: 30,
                                  offset: Offset(0, 10),
                                ),
                                
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                        Text("Cliente: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                    
                                   
                                        Text(
                                          "${data['order']['001']['info']['email']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),

                                    
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(children: [
                                        Text(
                                        'Ha Pagato:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)
                                        ),
                                        Text("€${data['order']['001']['info']['amount']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                                color: Colors.black)),
                                      ],),
                                SizedBox(height: 3),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Ha Ordinato:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "${data['order']['001']['itemList']['item']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text("Id: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text(
                                            "${data['order']['001']['info']['transactionId']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ),
                  );
                  /*Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
                    child: Container(
                     decoration: BoxDecoration(
                      color: Colors.white,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.20),
                                        blurRadius: 30,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                    /*gradient: data['color'] == "arancione"
                                        ? gradient2
                                        : data['color'] == 'blu'
                                            ? gradient3
                                            : gradient1,*/
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                              children: [
                                Text("Cliente: "),
                                Text('${data['order']['001']['info']['email']}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
                              ],
                            ),
                            SizedBox(height: 2),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("Ha Ordinato: "),
                                    Text('${data['order']['001']['itemList']['item']}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Text("Ha Ordinato: "),
                                Text(': €${data['order']['001']['info']['amount']}'),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text('Id Transazione Stripe: ${data['order']['001']['info']['transactionId']}'),
                            SizedBox(height: 2),
                              ],
                            )
                            

                          ],
                        ),
                      ),
                    ),
                  );*/
                }).toList(),
              );
            },
          )
          /*return Text(
                  snapshot["bookedEvents"]["KFXvCj63y7GTjQcMKfVy"]["eventName"],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                );*/
        ],
      ))),
    );
  }
}
