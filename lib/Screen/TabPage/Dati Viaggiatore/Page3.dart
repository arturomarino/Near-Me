import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:near_me/Screen/TabPage/TabScreen/Page1.dart';


import '../../DetailsView/core/utils/size_utils.dart';

class Page3 extends StatefulWidget {
  final String structure;
  final String nome;
  final String cognome;
  final String sesso;
  final String dataNascita;
  final String nazionalita;
  const Page3(
      {Key? key,
      required this.nome,
      required this.cognome,
      required this.sesso,
      required this.dataNascita,
      required this.nazionalita,
      required this.structure})
      : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  late TextEditingController nDocController;

  @override
  void initState() {
    nDocController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nDocController.dispose();
    super.dispose();
  }

  void showSnackBarAdd(BuildContext context) {
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      content: Row(
        children: [
          Text(
            'Documento di viaggio aggiunto',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          )
        ],
      ),
      backgroundColor: Colors.blue,
      //Color.fromARGB(255, 35, 34, 34),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  int _selectedOption = 0;

  final List<String> _options = [
    '-',
    'Passaporto',
    'Carta D\'Identità',
  ];

  void documentoBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          Container(
            height: 150.0,
            child: CupertinoPicker(
              itemExtent: 32.0,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _selectedOption = index;
                });
              },
              children: _options
                  .map(
                    (option) => Center(
                      child: Text(
                        option,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Fatto'),
        ),
      ),
    );
  }

  String countryName = '';

  void _showCountrySheet() {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 500, // Optional. Country list modal height
        //Optional. Sets the border radius for the bottomsheet.
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        //Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          countryName = '${country.name}';
        });
      },
    );
  }

  DateTime _selectedDate1 = DateTime.now();

  void dateBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          Container(
            height: 170.0,
            child: CupertinoDatePicker(
              initialDateTime: _selectedDate1,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  _selectedDate1 = newDate;
                });
              },
              mode: CupertinoDatePickerMode.date,
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            // Codice da eseguire quando viene premuto il pulsante "Annulla"
            Navigator.pop(context);
          },
          child: Text('Fatto'),
        ),
      ),
    );
  }

  DateTime _selectedDate2 = DateTime.now();

  void dateBottomSheet2() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          Container(
            height: 170.0,
            child: CupertinoDatePicker(
              initialDateTime: _selectedDate2,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  _selectedDate2 = newDate;
                });
              },
              mode: CupertinoDatePickerMode.date,
              minimumDate: DateTime.now().subtract(Duration(days: 1)),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            // Codice da eseguire quando viene premuto il pulsante "Annulla"
            Navigator.pop(context);
          },
          child: Text('Fatto'),
        ),
      ),
    );
  }

  bool erroreBool = false;
  String error = 'Compila tutti i campi!';

  _errorFunction() {
    setState(() {
      erroreBool = true;
    });
  }

  String currentUser = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: textColor,
        elevation: 1,
        title: Text(
          "Documenti di viaggio",
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aggiungi un documento di viaggio',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 29, 134, 219)),
              ),
              SizedBox(height: 10),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text('Assicurati che questi dati corrispondano a quelli riportati nel tuo documento'),
                ),
                decoration: BoxDecoration(color: Color.fromARGB(255, 255, 249, 192), borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Tipo di documento',
                style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                    onTap: () {
                      documentoBottomSheet();
                    },
                    child: Container(
                        width: width,
                        height: 35,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color.fromARGB(255, 214, 214, 214),
                            width: 0.7,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_options[_selectedOption],style: TextStyle(color: textColor),),
                        ))),
              ),
              SizedBox(height: 20),
              Text(
                'Numero documento',
                style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CupertinoTextField(
                  controller: nDocController,
                  style: TextStyle(color: textColor),
                  decoration: BoxDecoration(
                    color: buttonColor,
                    
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Color.fromARGB(255, 214, 214, 214),
                      width: 0.7,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Paese',
                style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                    onTap: () {
                      _showCountrySheet();
                    },
                    child: Container(
                        width: width,
                        height: 35,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color.fromARGB(255, 214, 214, 214),
                            width: 0.7,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(countryName,style: TextStyle(color: textColor),),
                        ))),
              ),
              SizedBox(height: 20),
              Text(
                'Data di emissione',
                style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                    onTap: () {
                      dateBottomSheet();
                    },
                    child: Container(
                        width: width,
                        height: 35,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color.fromARGB(255, 214, 214, 214),
                            width: 0.7,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${DateFormat('dd/MM/yyyy').format(_selectedDate1)}' != '${DateFormat('dd/MM/yyyy').format(DateTime.now())}'
                              ? '${DateFormat('dd/MM/yyyy').format(_selectedDate1)}'
                              : '',style: TextStyle(color: textColor),),
                        ))),
              ),
              SizedBox(height: 20),
              Text(
                'Data di scadenza',
                style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                    onTap: () {
                      dateBottomSheet2();
                    },
                    child: Container(
                        width: width,
                        height: 35,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color.fromARGB(255, 214, 214, 214),
                            width: 0.7,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${DateFormat('dd/MM/yyyy').format(_selectedDate2)}' != '${DateFormat('dd/MM/yyyy').format(DateTime.now())}'
                              ? '${DateFormat('dd/MM/yyyy').format(_selectedDate2)}'
                              : '',style: TextStyle(color: textColor),),
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  erroreBool == true ? error : '',
                  style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ),
              Spacer(),
              CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                      width: width,
                      height: 50,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                      child: Center(
                          child: Text(
                        "Salva",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ))),
                  onPressed: () async {
                    if (nDocController.text != '' &&
                        _options[_selectedOption] != '-' &&
                        '${DateFormat('dd/MM/yyyy').format(_selectedDate1)}' != '${DateFormat('dd/MM/yyyy').format(DateTime.now())}' &&
                        '${DateFormat('dd/MM/yyyy').format(_selectedDate2)}' != '${DateFormat('dd/MM/yyyy').format(DateTime.now())}' &&
                        countryName != '') {
                      await FirebaseDatabase.instance.ref().child('users/$currentUser/documents/${widget.nome} ${widget.cognome}').update({
                        'nome': widget.nome,
                        'cognome': widget.cognome,
                        'sesso': widget.sesso,
                        'dataNascita': widget.dataNascita,
                        'nazionalita': widget.nazionalita,
                        'tipoDoc': _options[_selectedOption],
                        'nDoc': nDocController.text,
                        'paese': countryName,
                        'dataEmissione': '${DateFormat('dd/MM/yyyy').format(_selectedDate1)}',
                        'dataScadenza': '${DateFormat('dd/MM/yyyy').format(_selectedDate2)}'
                      }).then((value) {
                        showSnackBarAdd(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Page1(
                                    structure: widget.structure,
                                  )),
                        );
                      });
                    }
                    /*print(namecontroller.text);
                      print(surnamecontroller.text);
                      print(_options[_selectedOption]);
                      print('${DateFormat('dd/MM/yyyy').format(_selectedDate)}');
                      print(countryName);*/

                    if (nDocController.text == '' ||
                        _options[_selectedOption] == '-' ||
                        '${DateFormat('dd/MM/yyyy').format(_selectedDate1)}' == '${DateFormat('dd/MM/yyyy').format(DateTime.now())}' ||
                        '${DateFormat('dd/MM/yyyy').format(_selectedDate2)}' == '${DateFormat('dd/MM/yyyy').format(DateTime.now())}' ||
                        countryName == '') {
                      _errorFunction();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
