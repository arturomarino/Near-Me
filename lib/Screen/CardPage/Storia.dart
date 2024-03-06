import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Storia extends StatefulWidget {
  const Storia({Key? key}) : super(key: key);

  @override
  _StoriaState createState() => _StoriaState();
}

class _StoriaState extends State<Storia> {
  @override //assets/image1.jpg
  Widget build(BuildContext context) {
    return Scaffold(
            
            extendBodyBehindAppBar: true,
            appBar:AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.cancel,size: 45)),
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
                        
                        Hero(tag: "Storia", child: Center(child: Image.asset("assets/imageStoria.jpg",fit: BoxFit.cover,height: double.infinity,width: double.infinity,)),transitionOnUserGestures: true,),
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
                                  children:  [
                                    Text(AppLocalizations.of(context)!.storia,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35 )),
                                    SizedBox(height: 15),
                                    Text(AppLocalizations.of(context)!.la_storia_text,style: TextStyle(fontWeight: FontWeight.w500),),
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
