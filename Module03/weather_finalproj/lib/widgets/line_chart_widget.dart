import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:weather_proj/models/weather/metrics/temperature.dart';

class LineChartWidget extends StatelessWidget {
  final List<List<Temperature>> temperaturesList;
  final List<String> timeList;
  final bool isListOfList;
  final String chartTitle;

  const LineChartWidget(
      {super.key,
      required this.temperaturesList,
      required this.timeList,
      this.isListOfList = false,
      required this.chartTitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.98,
      decoration: BoxDecoration(
          color: Colors.white.withAlpha(10),
          border: Border.all(color: Colors.white.withAlpha(100)),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Text(
            chartTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          _LineChart(
            isListOfList: isListOfList,
            temperaturesList: temperaturesList,
            timeList: timeList,
          ),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<List<Temperature>> temperaturesList;
  final List<String> timeList;
  final bool isListOfList;
  final double maxTemperature;
  final double minTemperature;

  _LineChart(
      {required this.temperaturesList,
      required this.timeList,
      required this.isListOfList})
      : maxTemperature = temperaturesList
            .expand((sublist) => sublist)
            .reduce((a, b) => a.getValue() > b.getValue() ? a : b)
            .getValue(),
        minTemperature = temperaturesList
            .expand((sublist) => sublist)
            .reduce((a, b) => a.getValue() < b.getValue() ? a : b)
            .getValue();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: isListOfList ? 250 : 284,
            child: LineChart(lineChartData),
          ),
        ),
        if (isListOfList)
          Column(
            children: [
              Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.deepOrangeAccent,
                    size: 15,
                  ),
                  Text('Max temperature', style: TextStyle(color: Colors.white, fontSize: 12),)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.lightBlueAccent,
                    size: 15,
                  ),
                  Text('Min temperature', style: TextStyle(color: Colors.white, fontSize: 12),)
                ],
              ),
            ],
          )
      ],
    );
  }

  LineChartData get lineChartData => LineChartData(
        lineTouchData: LineTouchData(),
        gridData: gridData(),
        titlesData: titlesData(),
        borderData: borderData(),
        lineBarsData: lineBarsData(),
        minX: isListOfList ? -0.5 : 0,
        maxX: isListOfList
            ? timeList.length.toDouble() - 0.5
            : timeList.length.toDouble() - 1,
        minY: minTemperature - 2,
        maxY: maxTemperature + 2,
      );

  LineTouchData lineTouchData() =>
      const LineTouchData(handleBuiltInTouches: true);

  FlGridData gridData() => FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        horizontalInterval: 2,
        verticalInterval: isListOfList ? 1 : 3,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.white.withAlpha(150), strokeWidth: 1),
        getDrawingVerticalLine: (value) =>
            FlLine(color: Colors.white.withAlpha(50), strokeWidth: 1),
      );

  FlTitlesData titlesData() => FlTitlesData(
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value != meta.min && value != meta.max) {
                  return Text(
                    '${value.toInt()}˚C',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  );
                } else {
                  return Container();
                }
              })),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          minIncluded: !isListOfList,
          interval: isListOfList ? 1 : 3,
          maxIncluded: false,
          getTitlesWidget: (value, meta) {
            return Text(
              timeList[value.toInt()],
              style: TextStyle(color: Colors.white, fontSize: 10),
            );
          },
        ),
      ));

  FlBorderData borderData() => FlBorderData(
        show: true,
        border: Border(
          top: BorderSide(color: Colors.white.withAlpha(100)),
          bottom: BorderSide(color: Colors.white.withAlpha(100)),
          left: BorderSide(color: Colors.white.withAlpha(100)),
          right: BorderSide(color: Colors.white.withAlpha(100)),
        ),
      );

  final List<Color> colors = [Colors.deepOrangeAccent, Colors.blue];
  List<LineChartBarData> lineBarsData() => [
        for (var i = 0; i < temperaturesList.length; i++)
          LineChartBarData(
            spots: [
              for (var j = 0; j < temperaturesList[i].length; j++)
                FlSpot(j.toDouble(), temperaturesList[i][j].getValue())
            ],
            isCurved: true,
            color: isListOfList ? colors[i] : Colors.orange,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Colors.black,
                );
              },
            ),
            belowBarData: BarAreaData(),
          )
      ];
}
