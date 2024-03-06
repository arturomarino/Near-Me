import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';
import 'package:near_me/Screen/TabPage/Dati%20Viaggiatore/Page3.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';

class Page2 extends StatefulWidget {
  final String structure;
  const Page2({Key? key, required this.structure}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  late TextEditingController namecontroller;
  late TextEditingController surnamecontroller;
  @override
  void initState() {
    namecontroller = TextEditingController();
    surnamecontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    surnamecontroller.dispose();
    super.dispose();
  }

  int _selectedOption = 0;

  final List<String> _options = [
    '-',
    'Altro',
    'M',
    'F',
  ];

  DateTime _selectedDate = DateTime.now();

  void dateBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          Container(
            height: 170.0,
            child: CupertinoDatePicker(
              initialDateTime: _selectedDate,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  _selectedDate = newDate;
                });
              },
              mode: CupertinoDatePickerMode.date,
              maximumDate: DateTime.now(),
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

  void sessoBottomSheet() {
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
            // Codice da eseguire quando viene premuto il pulsante "Annulla"
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

  bool erroreBool = false;
  String error = 'Compila tutti i campi!';

  _errorFunction() {
    setState(() {
      erroreBool = true;
    });
  }

  _okFunction() {
    setState(() {
      erroreBool = false;
    });
  }

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
          "Aggiungi un viaggiatore",
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
                'Dati personali',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 29, 134, 219)),
              ),
              SizedBox(height: 10),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text('Inserisci i dati del viaggiatore esattamente come appaiono sul suo passaporto o su un altro documento di viaggio'),
                ),
                decoration: BoxDecoration(color: Color.fromARGB(255, 255, 249, 192), borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(height: 20),
              Text(
                'Nome',
                style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CupertinoTextField(
                  style: TextStyle(color: textColor),
                  decoration: BoxDecoration(
                    color: buttonColor,
                    
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Color.fromARGB(255, 214, 214, 214),
                      width: 0.7,
                    ),
                  ),
                  controller: namecontroller,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Cognome',
                style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CupertinoTextField(
                  style: TextStyle(color: textColor),
                  decoration: BoxDecoration(
                    color: buttonColor,

                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Color.fromARGB(255, 214, 214, 214),
                      width: 0.7,
                    ),
                  ),
                  controller: surnamecontroller,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Sesso',
                style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                    onTap: () {
                      sessoBottomSheet();
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
                'Data di nascita',
                style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
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
                          child: Text('${DateFormat('dd/MM/yyyy').format(_selectedDate)}',style: TextStyle(color: textColor),),
                        ))),
              ),
              SizedBox(height: 20),
              Text(
                'Nazionalità',
                style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
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
                          borderRadius: BorderRadius.circular(5),
                          color: buttonColor,
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
                        "Continua",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ))),
                  onPressed: () {
                    if (namecontroller.text != '' &&
                        surnamecontroller.text != '' &&
                        _options[_selectedOption] != '-' &&
                        '${DateFormat('dd/MM/yyyy').format(_selectedDate)}' != '${DateFormat('dd/MM/yyyy').format(DateTime.now())}' &&
                        countryName != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Page3(
                                  nome: namecontroller.text,
                                  cognome: surnamecontroller.text,
                                  sesso: _options[_selectedOption],
                                  dataNascita: '${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                                  nazionalita: countryName,
                                  structure: widget.structure,
                                )),
                      );
                    }
                    /*print(namecontroller.text);
                    print(surnamecontroller.text);
                    print(_options[_selectedOption]);
                    print('${DateFormat('dd/MM/yyyy').format(_selectedDate)}');
                    print(countryName);*/

                    if (namecontroller.text == '' ||
                        surnamecontroller.text == '' ||
                        _options[_selectedOption] == '-' ||
                        '${DateFormat('dd/MM/yyyy').format(_selectedDate)}' == '${DateFormat('dd/MM/yyyy').format(DateTime.now())}' ||
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
