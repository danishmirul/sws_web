import 'dart:math';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sws_web/constants/size.dart';
import 'package:date_util/date_util.dart';
import 'package:sws_web/models/wheelchair.dart';

class MainStatistic extends StatefulWidget {
  MainStatistic({@required this.wheelchairs, key}) : super(key: key);
  final List<Wheelchair> wheelchairs;

  @override
  _MainStatisticState createState() => _MainStatisticState();
}

class _MainStatisticState extends State<MainStatistic> {
  bool received = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    var dateParse = DateFormat('MMMM').format(now);
    String currentMonth = dateParse.toString();

    return Padding(
      padding: const EdgeInsets.all(cDefaultPadding),
      child: Container(
        height: size.height * 0.5,
        width: size.width - cNavbarWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: cDefaultPadding),
                  child: const Text(
                    'Daily Available Wheelchair',
                    style: TextStyle(
                      color: Color(0xff827daa),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    currentMonth,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: cDefaultPadding),
                    child: LineChart(
                      wheelchairData(widget.wheelchairs),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white.withOpacity(received ? 1.0 : 0.5),
              ),
              onPressed: () {
                setState(() {
                  received = !received;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

int getNumberDayMonth() {
  var date = new DateTime.now().toString();
  var dateParse = DateTime.parse(date);

  var dateUtility = DateUtil();
  var numDays = dateUtility.daysInMonth(dateParse.month, dateParse.year);

  return numDays;
}

LineChartData wheelchairData(List<Wheelchair> wheelchairs) {
  return LineChartData(
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
      ),
      touchCallback: (LineTouchResponse touchResponse) {},
      handleBuiltInTouches: true,
    ),
    gridData: FlGridData(
      show: true,
    ),
    titlesData: FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        margin: 10,
        getTitles: (value) => (value + 1).toString(),
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        margin: 10,
        reservedSize: 100,
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: const Border(
        bottom: BorderSide(
          color: Color(0xff4e4965),
          width: 4,
        ),
        left: BorderSide(
          color: Colors.transparent,
        ),
        right: BorderSide(
          color: Colors.transparent,
        ),
        top: BorderSide(
          color: Colors.transparent,
        ),
      ),
    ),
    minX: 0,
    maxX: (getNumberDayMonth() - 1).toDouble(),
    maxY: (wheelchairs.length + 1).toDouble(),
    minY: 0,
    lineBarsData: wheelchairsData(wheelchairs),
  );
}

List<LineChartBarData> wheelchairsData(List<Wheelchair> wheelchairs) {
  var date = new DateTime.now().toString();
  var dateParse = DateTime.parse(date);

  var rng = new Random();

  List<FlSpot> batteryReadings = [];
  for (int i = 0; i < dateParse.day; i++) {
    batteryReadings.add(FlSpot(
        i.toDouble(),
        i == (dateParse.day - 1)
            ? wheelchairs.where((e) => e.status == 'A').length
            : rng.nextInt(wheelchairs.length).toDouble()));
  }

  List<LineChartBarData> data = [
    LineChartBarData(
      spots: batteryReadings,
      isCurved: false,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    )
  ];
  return data;
}
