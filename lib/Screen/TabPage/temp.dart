import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Temp extends StatelessWidget {
  const Temp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoButton(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Center(
                    child: Text(
                  'Press',
                  style: TextStyle(color: Colors.white),
                )),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.green),
                height: 35,
                width: 100,
              ),
            ),
            onPressed: () {
              print('Pressed!');
            }),
      ),
    );
  }
}
