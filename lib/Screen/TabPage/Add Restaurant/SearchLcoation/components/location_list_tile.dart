import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    Key? key,
    required this.location,
    required this.press,
  }) : super(key: key);

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
     final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final divider = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white12 : Colors.black12;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Column(
      children: [
        ListTile(
          //onTap: press,
          horizontalTitleGap: 0,
          leading: Icon(CupertinoIcons.placemark,color: Colors.blue,size: 20,),
          trailing:CupertinoButton(child: Icon( CupertinoIcons.add),onPressed: press,),
          title: Text(
            location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textColor,fontWeight: FontWeight.w500,fontSize: 15),
          ),
        ),
         Divider(
          height: 2,
          thickness: 1,
          color: divider,

        ),
      ],
    );
  }
}
