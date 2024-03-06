import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Premi extends StatefulWidget {
  const Premi({Key? key}) : super(key: key);

  @override
  _PremiState createState() => _PremiState();
}

class _PremiState extends State<Premi> {
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
                  Hero(tag: "Premi", child: Center(child: Image.asset("assets/imagePremi.jpg",fit: BoxFit.cover,height: double.infinity,width: double.infinity,)),transitionOnUserGestures: true,),                  
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
                              Text(AppLocalizations.of(context)!.premi,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
                              SizedBox(height: 15),
                              Text(AppLocalizations.of(context)!.i_premi_text),
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
