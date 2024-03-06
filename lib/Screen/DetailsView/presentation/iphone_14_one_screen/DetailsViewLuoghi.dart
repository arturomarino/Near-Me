import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';

class DetailScreenLuoghi extends StatefulWidget {
  final String nome;
  final List weekDay;
  final List photos;
  final String categories;
  final String url;
  final String phone;
  final String indirizzo;

  // final String indicazioni;
  final String distanza;
  final String descrizione;

  DetailScreenLuoghi(
      {Key? key,
      required this.photos,
      required this.categories,
      required this.url,
      required this.phone,
      //required this.indicazioni,
      required this.nome,
      required this.distanza,
      required this.descrizione,
      required this.weekDay, required this.indirizzo})
      : super(key: key);
  @override
  State<DetailScreenLuoghi> createState() => _DetailScreenLuoghiState();
}

class _DetailScreenLuoghiState extends State<DetailScreenLuoghi> {
  var _controller = ScrollController();
  ScrollPhysics _physics = ClampingScrollPhysics();
  String categories = '';
  String textForLink = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels <= 56)
        setState(() => _physics = ClampingScrollPhysics());
      else
        setState(() => _physics = BouncingScrollPhysics());
    });
  }

  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    double dHeight = MediaQuery.of(context).size.height;
     final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    final background2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 35, 35, 35) : Colors.white;
    final PageController pageController = PageController(initialPage: 0);

    return Scrollbar(
      child: Scaffold(
        
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: background,
          foregroundColor: textColor,
        ),
        backgroundColor: background,
        body: SingleChildScrollView(
          controller: _controller,
          physics: _physics,
          child: Container(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: getPadding(
                    left: 25,
                    top: 9,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: getPadding(left: 0, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.categories.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ColorConstant.gray700,
                                fontSize: getFontSize(
                                  11,
                                ),
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                           
                                 
                                   Container(
                                    width: width * 0.7,
                                    padding: new EdgeInsets.only(right: 13.0),
                                    child: Text(
                                      widget.nome,
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: getFontSize(
                                          27,
                                        ),
                                        fontFamily: 'SF Pro Display',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                
                          ],
                        ),
                      ),
                      /*Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          '${widget.distanza} Km',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: ColorConstant.lightGreenA700,
                          ),
                        ),
                      )*/
                    ],
                  ),
                ),
                 Visibility(
                  visible:widget.indirizzo != 'null' ? true : false,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                    },
                    child: Padding(
                      padding: getPadding(
                        left: 27,
                        top: 10,
                      ),
                      child: Text(
                        widget.indirizzo,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: getFontSize(
                            12,
                          ),
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.url != 'null' ? true : false,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      launch(widget.url);
                    },
                    child: Padding(
                      padding: getPadding(
                        left: 27,
                        top: 10,
                      ),
                      child: Text(
                        widget.url,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.blueA200,
                          fontSize: getFontSize(
                            12,
                          ),
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(
                    left: 23,
                    top: 11,
                  ),
                  child: Row(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          launch("tel://+39${widget.phone}");
                        },
                        child: Container(
                          padding: getPadding(
                            left: 11,
                            top: 4,
                            right: 11,
                            bottom: 4,
                          ),
                          decoration: BoxDecoration(
                            color: background2,
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                10.00,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: Center(
                                    child: Icon(
                                  Icons.phone,
                                  size: 21.5,
                                  color: ColorConstant.blueA200,
                                )),
                                height: getVerticalSize(
                                  14.00,
                                ),
                              ),
                              Padding(
                                padding: getPadding(
                                  top: 10,
                                ),
                                child: Text(
                                  "Chiama",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: ColorConstant.blueA200,
                                    fontSize: getFontSize(
                                      11,
                                    ),
                                    fontFamily: 'SF Pro Display',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            textForLink = widget.nome.replaceAll(' ', '+');
                          });
                          launch('https://www.google.com/search?q=$textForLink');
                        },
                        child: Container(
                          margin: getMargin(
                            left: 12,
                          ),
                          padding: getPadding(
                            left: 16,
                            top: 3,
                            right: 16,
                            bottom: 3,
                          ),
                          decoration: BoxDecoration(
                            color: background2,
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                10.00,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: Center(
                                    child: Icon(
                                  Icons.search,
                                  size: 21.5,
                                  color: ColorConstant.blueA200,
                                )),
                                height: getSize(
                                  23.00,
                                ),
                                width: getSize(
                                  23.00,
                                ),
                              ),
                              Padding(
                                padding: getPadding(
                                  top: 2,
                                  bottom: 1,
                                ),
                                child: Text(
                                  "Cerca",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: ColorConstant.blueA200,
                                    fontSize: getFontSize(
                                      11,
                                    ),
                                    fontFamily: 'SF Pro Display',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: width,
                    height: height * 0.4,
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.photos.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                widget.photos[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Visibility(
                  visible: widget.weekDay.isEmpty?false:true,
                  child: ExpansionTile(
                    title: Text("Orari di apertura",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0, left: 25),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.weekDay.length,
                            itemBuilder: (context, index) {
                              return Text(widget.weekDay[index]);
                            }),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: getHorizontalSize(
                      326.00,
                    ),
                    margin: getMargin(
                      top: 20,
                      bottom: 5,
                    ),
                    child: Text(
                      widget.descrizione,
                      maxLines: null,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: textColor,
                        fontSize: getFontSize(
                          13,
                        ),
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: dHeight * 0.03),
                CupertinoButton(
                    child: Container(
                      width: dWidth,
                      height: 45,
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(
                          Icons.navigation,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Indicazioni',
                          style: TextStyle(color: Colors.white),
                        )
                      ]),
                    ),
                    onPressed: () async {
                      String textForLink = '';

                      setState(() {
                        textForLink = widget.nome.replaceAll(' ', '+');
                      });
                      bool mappeLaunch = false;
                      bool googleMapsLaunch = false;

                      if (await canLaunch('https://maps.apple.com/?q=$textForLink')) {
                        setState(() {
                          mappeLaunch = true;
                        });
                      }
                      if (await canLaunch('comgooglemaps://?q=$textForLink')) {
                        setState(() {
                          googleMapsLaunch = true;
                        });
                      }

                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => CupertinoActionSheet(
                          cancelButton: CupertinoActionSheetAction(
                            /// This parameter indicates the action would be a default
                            /// defualt behavior, turns the action's text to bold text.
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          actions: [
                            Visibility(
                              visible: mappeLaunch,
                              child: Container(
                                color: Colors.white,
                                child: CupertinoActionSheetAction(
                                  onPressed: () {
                                    launch('https://maps.apple.com/?q=$textForLink');
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Open with Mappe',
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: googleMapsLaunch,
                              child: Container(
                                color: Colors.white,
                                child: CupertinoActionSheetAction(
                                  onPressed: () {
                                    launch('comgooglemaps://?q=$textForLink');
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Open with Google Maps',
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                SizedBox(height: dHeight * 0.07)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
