import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/Screen/DetailsView/widgets/custom_image_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/utils/color_constant.dart';
import 'core/utils/size_utils.dart';

class DetailScreenHome extends StatefulWidget {
  final String titolo;
  final String testo;
  final String image;
  final String url;

  DetailScreenHome({
    Key? key,
    required this.image,
    required this.titolo,
    required this.testo,
    required this.url,
  }) : super(key: key);
  @override
  State<DetailScreenHome> createState() => _DetailScreenHomeState();
}

class _DetailScreenHomeState extends State<DetailScreenHome> {
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

    final background =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.black
            : Color.fromRGBO(239, 238, 243, 1);
    final textColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    final background2 =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(255, 35, 35, 35)
            : Colors.white;

    return Scrollbar(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
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
                CustomImageView(
                  url: widget.image,
                  height: getVerticalSize(
                    314.00,
                  ),
                  width: getHorizontalSize(
                    390.00,
                  ),
                ),
                Padding(
                  padding: getPadding(
                    left: 27,
                    top: 0,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: getPadding(left: 9, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              categories,
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
                            Padding(
                              padding: getPadding(
                                top: 2,
                              ),
                              child: Text(
                                widget.titolo,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: getFontSize(
                                    30,
                                  ),
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    launch('${widget.url}');
                  },
                  child: Padding(
                    padding: getPadding(left: 34, top: 0),
                    child: Text(
                      widget.url,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromARGB(255, 87, 143, 240),
                        fontSize: getFontSize(
                          12,
                        ),
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
                      widget.testo,
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
                SizedBox(height: dHeight * 0.07)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
