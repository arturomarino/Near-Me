/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({Key? key}) : super(key: key);

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay with Card'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: Row(
                children: [
                  Text(
                    'Card Form',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
            ),
            CardFormField(
              controller: CardFormEditController(),
            ),
            CupertinoButton(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  width: width,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),color: Colors.black),
                  child: Center(child: Text("Pay",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),),
                ),
                onPressed: () {})
          ],
        ),
      ),
    );
  }
}
*/