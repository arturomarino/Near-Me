import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/retry.dart';
import 'package:lottie/lottie.dart';
import 'package:near_me/Screen/TabPage/Become%20Host/CreaStruttura.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../LoginSystem/RegisterEmail.dart';

class BecomeAHost1 extends StatefulWidget {
  final bool host;
  final bool fromLoginPage;
  const BecomeAHost1({Key? key, required this.fromLoginPage, required this.host}) : super(key: key);

  @override
  State<BecomeAHost1> createState() => _BecomeAHost1State();
}

class _BecomeAHost1State extends State<BecomeAHost1> {
  String textButton = '';
  List<bool> checked = [true, false, false];
  String _idProducts = '';
  bool _isSubscribed = false;
  String typeSub = '';
  bool _loading = false;

  /*void _loading(){
    setState(() {
      _loading =false;
    });
  }*/

  @override
  void initState() {
    Purchases.addCustomerInfoUpdateListener((customerInfo) => _updateCustumerStatus());
    _updateCustumerStatus();
    _checkedSystemButton();
    super.initState();
  }

  Future _updateCustumerStatus() async {
    final customerInfo = await Purchases.getCustomerInfo();
    Future.delayed(Duration(seconds: 2), () {
      if (customerInfo.activeSubscriptions[0] == 'nm23_2999_1y') {
        setState(() {
          typeSub = 'Annual';
        });
      } else if (customerInfo.activeSubscriptions[0] == 'nm23_1899_6mt') {
        setState(() {
          typeSub = 'Semiannual';
        });
      } else if (customerInfo.activeSubscriptions[0] == 'nm23_499_1m') {
        setState(() {
          typeSub = 'Monthly';
        });
      }
      print(typeSub);
      print(customerInfo.activeSubscriptions[0]);
    });

    if (customerInfo.entitlements.active.isNotEmpty) {
      setState(() {
        _isSubscribed = true;
      });
    }
    print('L\'utente è abbonato: $_isSubscribed');
  }

  void _checkedSystemButton() {
    if (checked[0] == true) {
      setState(() {
        textButton = '29,99 €/anno';
        _idProducts = 'nm23_2999_1y';
      });
    }
    if (checked[1] == true) {
      setState(() {
        textButton = '18,99 €/semestre';
        _idProducts = 'nm23_1899_6mt';
      });
    }
    if (checked[2] == true) {
      setState(() {
        textButton = '4,99 €/mese';
        _idProducts = 'nm23_499_1m';
      });
    }
  }

  List<String> titles = [
    'Ricevi documenti d\'Indentità',
    'Indirizza i tuoi ospiti',
    'Connettività Wi-Fi',
    'Problem Solving',
    'I tuoi servizi',
    'Mai più problemi di lingua'
  ];
  List<String> subTitles = [
    'Ottieni i documenti d\'identità dei tuoi ospiti in modo smart',
    'Aiuta i tuoi ospiti ad esplorare luoghi e ristoranti vicino alla tua struttura',
    'Utenti connessi al tuo Wi-Fi in meno di 1 minuto',
    'Aiuta i tuoi ospiti a risolvere i problemi in autonomia',
    'Proponi, guadagna e fai vivere un\'esperienza indimenticabile con i tuoi servizi',
    'Guida i tuoi ospiti anche se non sai bene la loro lingua'
  ];
  List<String> asset = [
    'assets/Frame 2.png',
    'assets/Frame3.png',
    'assets/Frame 4_1.png',
    'assets/Frame 5.png',
    'assets/Frame 6.png',
    'assets/Frame 7.png'
  ];
  List<bool> visibles = [true, true, false, true, true, true];
  List<int> initialPages = [0, 1, 2, 3, 4, 5];
  List<double> heights = [height * 0.4185, height * 0.4185, height * 0.4, height * 0.4185, height * 0.4185, height * 0.424];

  void _showLoading() {
    if (_loading == true) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                height:60,
                width: 150,
                
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),
                        child: Text("Just wait...."),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: 15,
                        height: 15,
                        
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                          strokeWidth: 3,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
    if (_loading == false) {
      Navigator.pop(context);
    }
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
        elevation: 0,
        backgroundColor: background,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Diventa un host', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 29, 134, 219), fontSize: 42)),
                  ],
                ),
                Text('Registra la tua struttura', style: TextStyle(fontWeight: FontWeight.w700, color: textColor, fontSize: 25)),
                SizedBox(height: 40),
                SizedBox(
                    child: Image.asset(
                  'assets/Frame 1.png',
                  fit: BoxFit.fitWidth,
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Container(
                    decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Buttons(
                          title: titles[0],
                          color: Colors.orange,
                          subtitle: subTitles[0],
                          icon: Icons.credit_card,
                          function: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: false,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              context: context,
                              builder: (BuildContext context) {
                                return BottomSheet(
                                  textButton: textButton,
                                  subTitles: subTitles,
                                  titles: titles,
                                  asset: asset,
                                  height: heights,
                                  visibles: visibles,
                                  initialPage: 0,
                                );
                              },
                            );
                          },
                        ),
                        MyDivider(),
                        Buttons(
                          title: titles[1],
                          color: Colors.blue,
                          subtitle: subTitles[1],
                          icon: CupertinoIcons.map,
                          function: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: false,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              context: context,
                              builder: (BuildContext context) {
                                return BottomSheet(
                                  textButton: textButton,
                                  subTitles: subTitles,
                                  titles: titles,
                                  asset: asset,
                                  height: heights,
                                  visibles: visibles,
                                  initialPage: 1,
                                );
                              },
                            );
                          },
                        ),
                        MyDivider(),
                        Buttons(
                          title: titles[2],
                          color: Colors.blue,
                          subtitle: subTitles[2],
                          icon: CupertinoIcons.wifi,
                          function: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: false,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              context: context,
                              builder: (BuildContext context) {
                                return BottomSheet(
                                  textButton: textButton,
                                  subTitles: subTitles,
                                  titles: titles,
                                  asset: asset,
                                  height: heights,
                                  visibles: visibles,
                                  initialPage: 2,
                                );
                              },
                            );
                          },
                        ),
                        MyDivider(),
                        Buttons(
                          title: titles[3],
                          color: Colors.red,
                          subtitle: subTitles[3],
                          icon: CupertinoIcons.question_circle,
                          function: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: false,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              context: context,
                              builder: (BuildContext context) {
                                return BottomSheet(
                                  textButton: textButton,
                                  subTitles: subTitles,
                                  titles: titles,
                                  asset: asset,
                                  height: heights,
                                  visibles: visibles,
                                  initialPage: 3,
                                );
                              },
                            );
                          },
                        ),
                        MyDivider(),
                        Buttons(
                          title: titles[4],
                          color: Colors.red,
                          subtitle: subTitles[4],
                          icon: Icons.beach_access,
                          function: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: false,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              context: context,
                              builder: (BuildContext context) {
                                return BottomSheet(
                                  textButton: textButton,
                                  subTitles: subTitles,
                                  titles: titles,
                                  asset: asset,
                                  height: heights,
                                  visibles: visibles,
                                  initialPage: 4,
                                );
                              },
                            );
                          },
                        ),
                        MyDivider(),
                        Buttons(
                          title: titles[5],
                          color: Colors.green,
                          subtitle: subTitles[5],
                          icon: Icons.language,
                          function: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: false,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              context: context,
                              builder: (BuildContext context) {
                                return BottomSheet(
                                  textButton: textButton,
                                  subTitles: subTitles,
                                  titles: titles,
                                  asset: asset,
                                  height: heights,
                                  visibles: visibles,
                                  initialPage: 5,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  //height: height * 0.6,
                  width: width,
                  child: Stack(children: [
                    Center(
                      child: SizedBox(
                        child: LottieBuilder.asset(
                          'assets/stars.json',
                          fit: BoxFit.fill,
                        ),
                        width: width,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.15),
                        child: Text(
                          "Scopri\ni piani",
                          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.purple, fontSize: 55),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.35, left: 25, right: 25),
                      child: Container(
                          decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                          child: ListView(padding: EdgeInsets.zero, physics: NeverScrollableScrollPhysics(), shrinkWrap: true, children: [
                            CheckAbbonamento(
                              index: checked[0],
                              function: (value) {
                                HapticFeedback.lightImpact();
                                if (checked[0] != true) {
                                  setState(() {
                                    checked[0] = value!;
                                    checked[1] = !value;
                                    checked[2] = !value;
                                  });
                                }
                                _checkedSystemButton();
                              },
                              priceMonth: '2,49 €/mese',
                              percent: true,
                              subtitle: true,
                              type: 'Annuale',
                              function1: () {
                                HapticFeedback.lightImpact();
                                if (checked[0] == false) {
                                  setState(() {
                                    checked[0] = true;
                                    checked[1] = false;
                                    checked[2] = false;
                                  });
                                  _checkedSystemButton();
                                }
                              },
                              semestral: false,
                            ),
                            MyDivider(),
                            CheckAbbonamento(
                              index: checked[1],
                              function: (value) {
                                HapticFeedback.lightImpact();

                                if (checked[1] != true) {
                                  setState(() {
                                    checked[1] = value!;
                                    checked[0] = !value;
                                    checked[2] = !value;
                                  });
                                }
                                _checkedSystemButton();
                              },
                              priceMonth: '2,99 €/mese',
                              percent: true,
                              subtitle: true,
                              type: 'Semestrale',
                              function1: () {
                                HapticFeedback.lightImpact();
                                if (checked[1] == false) {
                                  setState(() {
                                    checked[0] = false;
                                    checked[1] = true;
                                    checked[2] = false;
                                  });
                                  _checkedSystemButton();
                                }
                              },
                              semestral: true,
                            ),
                            MyDivider(),
                            CheckAbbonamento(
                              index: checked[2],
                              function: (value) {
                                HapticFeedback.lightImpact();
                                if (checked[2] != true) {
                                  setState(() {
                                    checked[0] = !value!;
                                    checked[1] = !value;
                                    checked[2] = value;
                                  });
                                }
                                _checkedSystemButton();
                              },
                              priceMonth: '4,99 €/mese',
                              percent: false,
                              subtitle: false,
                              type: 'Mensile',
                              function1: () {
                                HapticFeedback.lightImpact();
                                if (checked[2] == false) {
                                  setState(() {
                                    checked[0] = false;
                                    checked[1] = false;
                                    checked[2] = true;
                                  });
                                  _checkedSystemButton();
                                }
                              },
                              semestral: false,
                            )
                          ])),
                    ),
                  ]),
                ),
                SizedBox(
                  height: height * 0.4,
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: width,
                decoration: BoxDecoration(
                  color: background,
                  border: Border(
                    top: BorderSide(
                      color: Colors.black12,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                      child: Stack(
                        children: [
                          Shimmer.fromColors(
                            period: Duration(seconds: 5),
                            baseColor: Color.fromARGB(255, 82, 158, 220),
                            highlightColor: Color.fromARGB(255, 130, 76, 175),
                            child: Container(
                              decoration: BoxDecoration(
                                //color: Color.fromARGB(255, 216, 10, 137),
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [Color.fromARGB(255, 82, 158, 220), Color.fromARGB(255, 130, 76, 175)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              height: 50,
                              child: Center(
                                  child: Text(
                                'Diventa un host per $textButton',
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                              )),
                            ),
                          ),
                          Container(
                            height: 50,
                            child: Center(
                                child: Text(
                              'Diventa un host per $textButton',
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                            )),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });
                        _showLoading();
                        Future.delayed(Duration(seconds: 8), () {
                          Navigator.pop(context);
                        });

                        if (widget.fromLoginPage == false) {
                          await Purchases.purchaseProduct(_idProducts).then((value) {
                            if (value != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreaStruttura(
                                          becomeHost: true,
                                        ),
                                    fullscreenDialog: true),
                              );
                            }
                          });
                        } else {
                          await Purchases.purchaseProduct(_idProducts).then((value) {
                            if (value != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterEmailPage(
                                          becomeHost: widget.host,
                                        ),
                                    fullscreenDialog: true),
                              );
                            }
                          });
                        }
                      },
                    ),
                    CupertinoButton(
                        child: Text(
                          "Terms of Use (EULA)",
                          style: TextStyle(fontSize: 13),
                        ),
                        onPressed: () {
                          launch('https://sites.google.com/view/nearmeeula/home-page');
                        },
                        padding: EdgeInsets.zero),
                    CupertinoButton(
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(fontSize: 13),
                        ),
                        onPressed: () {
                          launch('https://sites.google.com/view/nearme-policy/home-page');
                        },
                        padding: EdgeInsets.only(bottom: height * 0.04))
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  final String textButton;
  final List<String> titles;
  final List<String> subTitles;
  final List<String> asset;
  final List<double> height;
  final List<bool> visibles;
  final int initialPage;
  const BottomSheet({
    Key? key,
    required this.textButton,
    required this.titles,
    required this.subTitles,
    required this.asset,
    required this.height,
    required this.visibles,
    required this.initialPage,
  }) : super(key: key);

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initialPage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: width,
        height: height * 0.73,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  child: Container(
                    height: height * 0.52,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: LottieBuilder.asset(
                      'assets/background.json',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: widget.titles.length,
                    effect: WormEffect(dotHeight: 8, dotWidth: 8),
                  ),
                ),
                CupertinoButton(
                    padding: EdgeInsets.only(bottom: 35, left: 25, right: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        //color: Color.fromARGB(255, 216, 10, 137),
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Color.fromARGB(255, 82, 158, 220), Color.fromARGB(255, 130, 76, 175)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      height: 50,
                      child: Center(
                          child: Text(
                        'Diventa un host per ${widget.textButton}',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                      )),
                    ),
                    onPressed: () {})
              ],
            ),
            Column(
              children: [
                Container(
                  height: height * 0.6,
                  width: width,
                  //color: Colors.red,
                  child: PageView.builder(
                    itemCount: widget.titles.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Visibility(visible: widget.visibles[index], child: SizedBox(height: height * 0.0685)),
                          SizedBox(
                            child: Image.asset(widget.asset[index]),
                            height: widget.height[index],
                          ),
                          SizedBox(
                            height: height * .04,
                          ),
                          Visibility(
                              visible: !widget.visibles[index],
                              child: SizedBox(
                                height: height * 0.09,
                              )),
                          Text(
                            widget.titles[index],
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.subTitles[index],
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ],
                      );
                    },
                    controller: _pageController,
                  ),
                )
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                        child: Icon(
                          CupertinoIcons.xmark_circle_fill,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
              ],
            )
          ],
        ));
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: Divider(
        height: 1,
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Function() function;
  const Buttons({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: function,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(children: [
            Container(
              height: 30,
              width: 30,
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(7)),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    subtitle,
                    overflow: TextOverflow.visible,
                    style: TextStyle(color: textColor2, fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80),
              child: Icon(
                CupertinoIcons.chevron_right,
                color: Colors.grey,
                size: 20,
              ),
            )
          ]),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CheckAbbonamento extends StatefulWidget {
  final bool index;
  final String type;
  final String priceMonth;
  final bool percent;
  final bool subtitle;
  final Function(bool?) function;
  final Function() function1;
  final bool semestral;
  CheckAbbonamento({
    Key? key,
    required this.type,
    required this.index,
    required this.function,
    required this.percent,
    required this.subtitle,
    required this.priceMonth,
    required this.function1,
    required this.semestral,
  }) : super(key: key);

  @override
  State<CheckAbbonamento> createState() => _CheckAbbonamentoState();
}

class _CheckAbbonamentoState extends State<CheckAbbonamento> {
  @override
  Widget build(BuildContext context) {
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black45;
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
            width: width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Checkbox(
                      shape: CircleBorder(), activeColor: Colors.purple, checkColor: Colors.white, value: widget.index, onChanged: widget.function),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.type,
                            style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
                          ),
                          SizedBox(width: 5),
                          Visibility(
                            visible: widget.percent,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                child: Text(
                                  widget.semestral == false ? '-25%' : '-10%',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
                                ),
                              ),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color.fromARGB(255, 203, 50, 231)),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Visibility(
                          visible: widget.subtitle,
                          child: Row(
                            children: [
                              Text(
                                widget.semestral == false ? '41,88 €' : '20,99',
                                style: TextStyle(color: textColor2, fontSize: 13, decoration: TextDecoration.lineThrough),
                              ),
                              Text(
                                widget.semestral == false ? ' 29,99 €/anno' : ' 18,99 €/semestre',
                                style: TextStyle(color: textColor2, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Text(
                          widget.priceMonth,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        onPressed: widget.function1);
  }
}
