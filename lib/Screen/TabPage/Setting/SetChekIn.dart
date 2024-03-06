import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';

class SetCheckIn extends StatefulWidget {
  final String structure;
  final String checkIn;
  final String checkOut;
  const SetCheckIn({Key? key, required this.structure, required this.checkIn, required this.checkOut}) : super(key: key);

  @override
  State<SetCheckIn> createState() => _SetWifiPageState();
}

class _SetWifiPageState extends State<SetCheckIn> {
  DateTime _selectedTime = DateTime.now();
  DateTime _selectedTime2 = DateTime.now();
  String _checkInTime = '';
  String _checkOutTime = '';
  bool _open = false;
  bool _open2 = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Set initialDateTime with a minute value divisible by the minute interval
    final initialMinute = (now.minute ~/ 5) * 5;
    _selectedTime = DateTime(now.year, now.month, now.day, now.hour, initialMinute);
    _selectedTime2 = DateTime(now.year, now.month, now.day, now.hour, initialMinute);
    _checkInTime = widget.checkIn;
    _checkOutTime = widget.checkOut;

  }

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        foregroundColor: textColor,
        backgroundColor: background,
        elevation: 0,
        actions: [
          CupertinoButton(
              child: Text(
                "Salva",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                if (_checkInTime != '' && _checkOutTime != '') {
                  await FirebaseDatabase.instance
                      .ref()
                      .child('structure/${widget.structure}/checkInOut')
                      .update({'checkIn': _checkInTime, 'checkOut': _checkOutTime});
                  Navigator.pop(context);
                }
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _open = !_open;
                });
              },
              child: AnimatedSize(
                duration: Duration(milliseconds: 900),
                curve: Curves.linear,
                child: Container(
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: width,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity, // Espande il Text per coprire tutta la larghezza del Container
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                'Check-in time',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Text(
                                _checkInTime == '' ? DateFormat.Hm().format(_selectedTime).toString() : _checkInTime,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        firstChild: const SizedBox(),
                        secondChild: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Container(
                            height: height * .2,
                            width: width,
                            child: CupertinoTheme(
                              data: CupertinoThemeData(
                                textTheme: CupertinoTextThemeData(
                                  dateTimePickerTextStyle: TextStyle(
                                    color: Colors.blue, // Set your desired text color here
                                  ),
                                ),
                              ),
                              child: CupertinoDatePicker(
                                initialDateTime: _selectedTime,
                                minuteInterval: 5,
                                use24hFormat: true,
                                onDateTimeChanged: (DateTime newTime) {
                                  String formattedTime = DateFormat.Hm().format(newTime);
                                  setState(() {
                                    _checkInTime = formattedTime;
                                  });
                                },
                                mode: CupertinoDatePickerMode.time,
                              ),
                            ),
                          ),
                        ),
                        crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _open2 = !_open2;
                });
              },
              child: AnimatedSize(
                duration: Duration(milliseconds: 900),
                curve: Curves.linear,
                child: Container(
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: width,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity, // Espande il Text per coprire tutta la larghezza del Container
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                'Check-out time',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Text(
                                _checkOutTime == '' ? DateFormat.Hm().format(_selectedTime2).toString() : _checkOutTime,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        firstChild: const SizedBox(),
                        secondChild: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Container(
                            height: height * .2,
                            width: width,
                            child: CupertinoTheme(
                              data: CupertinoThemeData(
                                textTheme: CupertinoTextThemeData(
                                  dateTimePickerTextStyle: TextStyle(
                                    color: Colors.blue, // Set your desired text color here
                                  ),
                                ),
                              ),
                              child: CupertinoDatePicker(
                                initialDateTime:  _selectedTime2,
                                minuteInterval: 5,
                                use24hFormat: true,
                                onDateTimeChanged: (DateTime newTime) {
                                  String formattedTime = DateFormat.Hm().format(newTime);
                                  setState(() {
                                    _checkOutTime = formattedTime;
                                  });
                                },
                                mode: CupertinoDatePickerMode.time,
                              ),
                            ),
                          ),
                        ),
                        crossFadeState: _open2 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
