import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Villa extends StatefulWidget {
  const Villa({Key? key}) : super(key: key);

  @override
  _VillaState createState() => _VillaState();
}

class _VillaState extends State<Villa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.cancel,size: 35)),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
          
          children: [
            Expanded(
              
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Hero(tag: "Villa",  child: Center(child: Image.asset("assets/imageVilla.jpg",fit: BoxFit.cover,height: double.infinity,width: double.infinity,)),transitionOnUserGestures: true,),                  
                  Padding(
                    padding: const EdgeInsets.only(top: 110,left: 25,right: 25),
                    child: Container(
                      decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(15)
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                     
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.villa,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
                              SizedBox(height: 15),
                              Text(AppLocalizations.of(context)!.la_villa_text,style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ))
          ],
        ),
      
    
         
    );
  }
}
