import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UploadCard extends StatefulWidget {
  const UploadCard({Key? key}) : super(key: key);

  @override
  _UploadCardState createState() => _UploadCardState();
}

class _UploadCardState extends State<UploadCard> {
  FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    //TUTTE LE TEXTFIELD
    final TextEditingController name1 = TextEditingController();
    final TextEditingController surname1 = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Carica i tuoi documenti"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 240,
              decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    ),
                  ],
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 20, right: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextFieldContainer(
                          larghezza: 180,
                          child: TextField(
                            controller: name1,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                                hintText: "Nome",
                                contentPadding: EdgeInsets.only(
                                  bottom: 25 / 2, // HERE THE IMPORTANT PART
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        Expanded(child: Container()),
                        TextFieldContainer(
                          larghezza:105,
                          child: TextField(
                            controller: name1,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                                hintText: "ID",
                                contentPadding: EdgeInsets.only(
                                  bottom: 25 / 2, // HERE THE IMPORTANT PART
                                ),
                                border: InputBorder.none),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final double larghezza;
  const TextFieldContainer({
    Key? key,
    required this.child,
    required this.larghezza
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 40,
        width: larghezza,
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: child);
  }
}
