import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class IdentityPage extends StatefulWidget {
  const IdentityPage({Key? key}) : super(key: key);

  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Documento d'ìdentità",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black)),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Seleziona il numero di ospiti",style: TextStyle(fontWeight: FontWeight.bold),),
                ElevatedButton(
                  
                  style: ButtonStyle(),
                  
                    onPressed: () {
                      showPickerNumber(context);
                    },
                    child: Text("Seleziona"))
              ],
            )));
  }
}

showPickerNumber(BuildContext context) {
  new Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(begin: 0, end: 8),
      ]),
      hideHeader: true,
      title: new Text("Seleziona il numero di ospiti"),
      onConfirm: (Picker picker, List value) {
        print(value.toString());
        print(picker.getSelectedValues());
      }).showDialog(context);
}
