import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BlackoutPage extends StatefulWidget {
  const BlackoutPage({Key? key}) : super(key: key);

  @override
  _BlackoutState createState() => _BlackoutState();
}

class _BlackoutState extends State<BlackoutPage> {
  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
        final Shader linearGradient = LinearGradient(
      colors: <Color>[Color.fromARGB(255, 255, 71, 38),Color.fromARGB(255, 222, 57, 49), ],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    
    final textColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: textColor,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
        body: Stack(
      children: [
        Center(
            child: Lottie.asset('assets/maintenance.json',
              
                height: MediaQuery.of(context).size.height * 0.25)),
        PageView(
          controller: _pageController,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    Text("1. "+AppLocalizations.of(context)!.verifica_1,style: TextStyle(color: textColor,fontWeight: FontWeight.w500,fontSize: 15),textAlign: TextAlign.center,),
                    SizedBox(height: 170)

                  ],
                ),
              ),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                )),
             Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    Text("2. "+AppLocalizations.of(context)!.verifica_2,style: TextStyle(color: textColor,fontWeight: FontWeight.w500,fontSize: 15),textAlign: TextAlign.center,),
                    SizedBox(height: 170)

                  ],
                ),
              ),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                )),
          ],
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: 120),
               Row(
                        children: [
                          Text(AppLocalizations.of(context)!.esegui_2_ver,style: TextStyle(foreground: Paint()..shader = linearGradient,fontWeight: FontWeight.bold,fontSize: 30),),
                          Expanded(child: Container())
                        ],
                      ),
              Expanded(child: Container()),
              SmoothPageIndicator(
                controller: _pageController,
                count: 2,
                effect: ScrollingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    dotColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.4),
                    activeDotColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
              SizedBox(height: 90)
            ],
          ),
        )
      ],
    ));
  }
}
