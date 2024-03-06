import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';

import 'indicator.dart';

class ChartPage extends StatefulWidget {
  final String structure;
  const ChartPage({Key? key, required this.structure}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final ref = FirebaseDatabase.instance.ref();

  List<Color> gradientColors = [
    Color.fromARGB(255, 243, 33, 191),
    Colors.purple,
  ];

  @override
  void initState() {
    _getData();
    _getRestaurantAnalytics();
    super.initState();
  }

  var currentUser = FirebaseAuth.instance.currentUser!.uid;

  List<String> dayList = [];
  List<String> esploraList = [];
  List<String> serviziList = [];
  List<String> autoList = [];
  List<String> faqList = [];

  List<Map<String, Map<String, int>>> weekData = [
    {
      'MON': {'faq_pressed': 0, 'esplora_pressed': 0, 'servizi_pressed': 0, 'auto_pressed': 0}
    },
    {
      'TUE': {'faq_pressed': 0, 'esplora_pressed': 0, 'servizi_pressed': 0, 'auto_pressed': 0}
    },
    {
      'WED': {'faq_pressed': 0, 'esplora_pressed': 0, 'servizi_pressed': 0, 'auto_pressed': 0}
    },
    {
      'THU': {'faq_pressed': 0, 'esplora_pressed': 0, 'servizi_pressed': 0, 'auto_pressed': 0}
    },
    {
      'FRI': {'faq_pressed': 0, 'esplora_pressed': 0, 'servizi_pressed': 0, 'auto_pressed': 0}
    },
    {
      'SAT': {'faq_pressed': 0, 'esplora_pressed': 0, 'servizi_pressed': 0, 'auto_pressed': 0}
    },
    {
      'SUN': {'faq_pressed': 0, 'esplora_pressed': 0, 'servizi_pressed': 0, 'auto_pressed': 0}
    },
  ];
  _getData() async {
    sums.clear();
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure/${widget.structure}/analytics");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String day = values["day"];
        String esplora_pressed = values["esplora_pressed"] != null ? values["esplora_pressed"].toString() : '0';
        String servizi_pressed = values["servizi_pressed"] != null ? values["servizi_pressed"].toString() : '0';
        String auto_pressed = values["auto_pressed"] != null ? values["auto_pressed"].toString() : '0';
        String faq_pressed = values["faq_pressed"] != null ? values["faq_pressed"].toString() : '0';

        int index = weekData.indexWhere((element) => element.keys.first == day);
        // Update the value of the 'faq_pressed' key for that day
        //weekData[index]['${day}'] = int.parse(faq_pressed);
        weekData[index][day]!['faq_pressed'] = int.parse(faq_pressed);
        weekData[index][day]!['esplora_pressed'] = int.parse(esplora_pressed);
        weekData[index][day]!['servizi_pressed'] = int.parse(servizi_pressed);
        weekData[index][day]!['auto_pressed'] = int.parse(auto_pressed);

        dayList.add(day.toString());
        esploraList.add(esplora_pressed.toString());
        serviziList.add(servizi_pressed.toString());
        autoList.add(auto_pressed.toString());
        faqList.add(faq_pressed.toString());
      });
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
      _sum();
      _sumDayList();
      _sumOfAction();
      // print(weekData);
    });
  }

  int maxSum = 0;
  int maxSumIndex = 0;

  void _sum() {
    String maxDay = '';
    int maxSum2 = 0;

    for (Map<String, Map<String, int>> dayData in weekData) {
      int daySum = 0;
      for (Map<String, int> values in dayData.values.toList()) {
        for (int value in values.values) {
          daySum += value;
        }
      }
      if (daySum > maxSum2) {
        maxSum2 = daySum;
        maxDay = dayData.keys.first;
      }
    }
    setState(() {
      maxSum = maxSum2;
    });

    //print('Giorno con la somma maggiore: $maxDay');
    //print('Somma: $maxSum2');
  }

  List<int> sums = [];
  int maxSumOfList = 0;
  int minSumOfList = 0;

  void _sumDayList() {
    for (Map<String, Map<String, int>> dayData in weekData) {
      int daySum = 0;
      for (Map<String, int> values in dayData.values.toList()) {
        for (int value in values.values) {
          daySum += value;
        }
      }
      sums.add(daySum);
    }

    int maxSumOfList2 = sums.reduce((value, element) => value > element ? value : element);
    setState(() {
      maxSumOfList = maxSumOfList2;
    });
    int minSumOfList2 = sums.reduce((value, element) => value < element ? value : element);
    setState(() {
      minSumOfList = minSumOfList2;
    });
  }

  int esploraPressedSum = 0;
  int autoPressedSum = 0;
  int serviziPressedSum = 0;
  int faqPressedSum = 0;

  void _sumOfAction() {
    int esploraPressedSum2 = 0;
    int autoPressedSum2 = 0;
    int serviziPressedSum2 = 0;
    int faqPressedSum2 = 0;
    for (Map<String, Map<String, int>> dayData in weekData) {
      faqPressedSum2 += dayData.values.first['faq_pressed']!;
      esploraPressedSum2 += dayData.values.first['esplora_pressed']!;
      autoPressedSum2 += dayData.values.first['auto_pressed']!;
      serviziPressedSum2 += dayData.values.first['servizi_pressed']!;
    }
    setState(() {
      esploraPressedSum = esploraPressedSum2;
      autoPressedSum = autoPressedSum2;
      serviziPressedSum = serviziPressedSum2;
      faqPressedSum = faqPressedSum2;
    });
    /* print('La somma di tutti i valori sotto il campo "faq_pressed" è $faqPressedSum');
    print('La somma di tutti i valori sotto il campo "faq_pressed" è $autoPressedSum');
    print('La somma di tutti i valori sotto il campo "faq_pressed" è $serviziPressedSum');
    print('La somma di tutti i valori sotto il campo "faq_pressed" è $esploraPressedSum');*/
  }

  final betweenSpace = 0.2;

  BarChartGroupData generateGroupData(
    int x,
    double esplora,
    double servizi,
    double faq,
    double auto,
  ) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: esplora,
          color: Colors.red,
          width: 5,
        ),
        BarChartRodData(
          fromY: esplora + betweenSpace,
          toY: esplora + betweenSpace + servizi,
          color: Colors.green,
          width: 5,
        ),
        BarChartRodData(
          fromY: esplora + betweenSpace + servizi + betweenSpace,
          toY: esplora + betweenSpace + servizi + betweenSpace + faq,
          color: Colors.amber,
          width: 5,
        ),
        BarChartRodData(
          fromY: esplora + betweenSpace + servizi + betweenSpace + faq + betweenSpace,
          toY: esplora + betweenSpace + servizi + betweenSpace + faq + betweenSpace + auto,
          color: Colors.purple,
          width: 5,
        ),
      ],
    );
  }

  int touchedIndex = -1;
  bool showAvg = false;

  List<String> _namePlaceList = [];
  List<int> _tap_countPriceList = [];

  _getRestaurantAnalytics() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure/${widget.structure}/placeAnalytics");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String namePlace = values["nameOfPlace"] == null ? '' : values["nameOfPlace"];
        int tap_count = values["count"] == null ? '' : values["count"];
        _namePlaceList.add(namePlace);
        _tap_countPriceList.add(tap_count);
      });
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {});
      print(_namePlaceList);
      print(_tap_countPriceList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;

    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: background,
          foregroundColor: textColor,
          actions: [
            CupertinoButton(
                child: Icon(Icons.refresh),
                onPressed: () {
                  _getData();
                  //print(maxSum);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.14,
                ),
                Text(
                  'Activity',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Influences on different days',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceBetween,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(),
                          rightTitles: AxisTitles(),
                          topTitles: AxisTitles(),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitles,
                              reservedSize: 20,
                            ),
                          ),
                        ),
                        /*barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Colors.blueGrey,
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  return BarTooltipItem(
                                    'csac',
                                    TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              )),*/
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                        barGroups: [
                          generateGroupData(
                              0,
                              double.parse(weekData[0]['MON']!['esplora_pressed'].toString()),
                              double.parse(weekData[0]['MON']!['servizi_pressed'].toString()),
                              double.parse(weekData[0]['MON']!['faq_pressed'].toString()),
                              double.parse(weekData[0]['MON']!['auto_pressed'].toString())),
                          generateGroupData(
                              1,
                              double.parse(weekData[1]['TUE']!['esplora_pressed'].toString()),
                              double.parse(weekData[1]['TUE']!['servizi_pressed'].toString()),
                              double.parse(weekData[1]['TUE']!['faq_pressed'].toString()),
                              double.parse(weekData[1]['TUE']!['auto_pressed'].toString())),
                          generateGroupData(
                              2,
                              double.parse(weekData[2]['WED']!['esplora_pressed'].toString()),
                              double.parse(weekData[2]['WED']!['servizi_pressed'].toString()),
                              double.parse(weekData[2]['WED']!['faq_pressed'].toString()),
                              double.parse(weekData[2]['WED']!['auto_pressed'].toString())),
                          generateGroupData(
                              3,
                              double.parse(weekData[3]['THU']!['esplora_pressed'].toString()),
                              double.parse(weekData[3]['THU']!['servizi_pressed'].toString()),
                              double.parse(weekData[3]['THU']!['faq_pressed'].toString()),
                              double.parse(weekData[3]['THU']!['auto_pressed'].toString())),
                          generateGroupData(
                              4,
                              double.parse(weekData[4]['FRI']!['esplora_pressed'].toString()),
                              double.parse(weekData[4]['FRI']!['servizi_pressed'].toString()),
                              double.parse(weekData[4]['FRI']!['faq_pressed'].toString()),
                              double.parse(weekData[4]['FRI']!['auto_pressed'].toString())),
                          generateGroupData(
                              5,
                              double.parse(weekData[5]['SAT']!['esplora_pressed'].toString()),
                              double.parse(weekData[5]['SAT']!['servizi_pressed'].toString()),
                              double.parse(weekData[5]['SAT']!['faq_pressed'].toString()),
                              double.parse(weekData[5]['SAT']!['auto_pressed'].toString())),
                          generateGroupData(
                              6,
                              double.parse(weekData[6]['SUN']!['esplora_pressed'].toString()),
                              double.parse(weekData[6]['SUN']!['servizi_pressed'].toString()),
                              double.parse(weekData[6]['SUN']!['faq_pressed'].toString()),
                              double.parse(weekData[6]['SUN']!['auto_pressed'].toString())),
                        ],
                        maxY: maxSum + (betweenSpace * 3),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Indicator(
                        textColor: textColor,
                        size: 13,
                        color: Colors.red,
                        text: 'Esplora',
                        isSquare: false,
                        number: esploraPressedSum.toString(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Indicator(
                        textColor: textColor,
                        size: 13,
                        color: Colors.green,
                        text: 'Servizi',
                        isSquare: false,
                        number: serviziPressedSum.toString(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Indicator(
                        textColor: textColor,
                        size: 13,
                        color: Colors.amber,
                        text: 'Faq',
                        isSquare: false,
                        number: faqPressedSum.toString(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Indicator(
                        textColor: textColor,
                        size: 13,
                        color: Colors.purple,
                        text: 'Auto',
                        isSquare: false,
                        number: autoPressedSum.toString(),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: buttonColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        child: Text(
                          showAvg == false ? 'Linear' : 'Curve',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      showAvg = !showAvg;
                      setState(() {});
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AspectRatio(
                    aspectRatio: 1.70,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 18,
                        left: 12,
                        top: 24,
                        bottom: 12,
                      ),
                      child: LineChart(
                        showAvg
                            ? LineChartData(
                                lineTouchData: LineTouchData(enabled: false),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 3,
                                  verticalInterval: 1,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Colors.grey,
                                      strokeWidth: 1,
                                    );
                                  },
                                  getDrawingVerticalLine: (value) {
                                    return FlLine(
                                      color: Colors.grey,
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      interval: 1,
                                      getTitlesWidget: bottomTitleWidgets,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                      interval: 15,
                                      reservedSize: 42,
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                  border: Border.all(color: const Color(0xff37434d)),
                                ),
                                minX: 0,
                                maxX: 6,
                                minY: minSumOfList.toDouble() - 3,
                                maxY: maxSumOfList.toDouble() + 3,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: [
                                      FlSpot(0, sums.isEmpty ? 0 : sums[0].toDouble()),
                                      FlSpot(1, sums.isEmpty ? 0 : sums[1].toDouble()),
                                      FlSpot(2, sums.isEmpty ? 0 : sums[2].toDouble()),
                                      FlSpot(3, sums.isEmpty ? 0 : sums[3].toDouble()),
                                      FlSpot(4, sums.isEmpty ? 0 : sums[4].toDouble()),
                                      FlSpot(5, sums.isEmpty ? 0 : sums[5].toDouble()),
                                      FlSpot(6, sums.isEmpty ? 0 : sums[6].toDouble()),
                                    ],
                                    isCurved: false,
                                    gradient: LinearGradient(
                                      colors: gradientColors,
                                    ),
                                    barWidth: 5,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: false,
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: true,
                                  horizontalInterval: 3,
                                  verticalInterval: 1,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Colors.grey,
                                      strokeWidth: 1,
                                    );
                                  },
                                  getDrawingVerticalLine: (value) {
                                    return FlLine(
                                      color: Colors.grey,
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      interval: 1,
                                      getTitlesWidget: bottomTitleWidgets,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                      interval: 15,
                                      reservedSize: 42,
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                  border: Border.all(color: const Color(0xff37434d)),
                                ),
                                minX: 0,
                                maxX: 6,
                                minY: minSumOfList.toDouble() - 3,
                                maxY: maxSumOfList.toDouble() + 3,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: [
                                      FlSpot(0, sums.isEmpty ? 0 : sums[0].toDouble()),
                                      FlSpot(1, sums.isEmpty ? 0 : sums[1].toDouble()),
                                      FlSpot(2, sums.isEmpty ? 0 : sums[2].toDouble()),
                                      FlSpot(3, sums.isEmpty ? 0 : sums[3].toDouble()),
                                      FlSpot(4, sums.isEmpty ? 0 : sums[4].toDouble()),
                                      FlSpot(5, sums.isEmpty ? 0 : sums[5].toDouble()),
                                      FlSpot(6, sums.isEmpty ? 0 : sums[6].toDouble()),
                                    ],
                                    isCurved: true,
                                    gradient: LinearGradient(
                                      colors: gradientColors,
                                    ),
                                    barWidth: 5,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: false,
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Impressions of your added places',style: TextStyle(color: textColor, fontWeight: FontWeight.bold,fontSize: 19),),
                ),
                Container(
                      decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _namePlaceList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _namePlaceList[index],
                                    style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Impression: '+_tap_countPriceList[index].toString(),
                                    style: TextStyle(color: textColor2, fontWeight: FontWeight.w500,fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    
                  ),
                SizedBox(
                  height: height * 0.2,
                )
              ],
            ),
          ),
        )

        /*Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: height * 0.3,
                width: width,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 90,
                    sections: [
                      PieChartSectionData(title: 'Esplora', showTitle: true, value: double.parse(_esploraCount) * 10,titleStyle: TextStyle(fontWeight: FontWeight.w500)),
                      PieChartSectionData(title: 'Servizi', color: Colors.amber, value: double.parse(_serviziCount) * 10),
                      PieChartSectionData(title: 'Auto', color: Colors.red, value: _autoCount == '' ? 0.0 : double.parse(_autoCount) * 10),
                      PieChartSectionData(title: 'Faq', color: Colors.green, value: double.parse(_faqCount) * 10)
                    ],
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                  ),
                  swapAnimationCurve: Curves.linear,
                  swapAnimationDuration: Duration(seconds: 1),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 25,top: 40),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color:Colors.blue,
                  text: 'First',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.amber,
                  text: 'Second',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.red,
                  text: 'Third',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.green,
                  text: 'Fourth',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
                      ),
            ),
          ],
        )*/
        );
  }
}

Widget bottomTitles(double value, TitleMeta meta) {
  TextStyle style = TextStyle(fontSize: 10, color: Colors.grey);
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'MON';
      break;
    case 1:
      text = 'TUE';
      break;
    case 2:
      text = 'WED';
      break;
    case 3:
      text = 'THU';
      break;
    case 4:
      text = 'FRI';
      break;
    case 5:
      text = 'SAT';
      break;
    case 6:
      text = 'SUN';
      break;
    default:
      text = '';
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(text, style: style),
  );
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text(
        'MON',
        style: style,
      );
      break;
    case 1:
      text = Text(
        'TUE',
        style: style,
      );
      break;
    case 2:
      text = Text(
        'WED',
        style: style,
      );
      break;
    case 3:
      text = Text(
        'THU',
        style: style,
      );
      break;
    case 4:
      text = Text(
        'FRI',
        style: style,
      );
      break;
    case 5:
      text = Text(
        'SAT',
        style: style,
      );
      break;
    case 6:
      text = Text(
        'SUN',
        style: style,
      );
      break;
    default:
      text = Text('');
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  String text;
  switch (value.toInt()) {
    case 1:
      text = '0';
      break;
    case 3:
      text = '50';
      break;
    case 5:
      text = '100';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}
