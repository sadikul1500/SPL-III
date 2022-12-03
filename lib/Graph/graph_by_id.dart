// import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter_chart_graph/data_model.dart';
import 'package:kids_learning_tool/Model/graph_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ShowGraphById extends StatefulWidget {
  final String id;
  final List<Person> persons;
  const ShowGraphById({Key? key, required this.id, required this.persons})
      : super(key: key);
  @override
  State<ShowGraphById> createState() => _ShowGraphByIdState();
}

class _ShowGraphByIdState extends State<ShowGraphById> {
  List<String> categories = [
    'matching',
    'drag & drop',
    'activity scheduling',
    'jigsaw puzzle'
  ];
  List<String> chartTypes = ['Line', 'Column', 'Area', 'Bar', 'Spline'];
  List dropDownValues = ['Line', 'Line', 'Line', 'Line'];
  List showTopics = [false, false, false, false];

  List<int> cumulativeTime = [0, 0, 0, 0], cumulativeAttempt = [0, 0, 0, 0];
  var groupByCategory = [
    {'title': 'matching', 'time': 0, 'attempt': 0},
    {'title': 'drag & drop', 'time': 0, 'attempt': 0},
    {'title': 'activity scheduling', 'time': 0, 'attempt': 0},
    {'title': 'jigsaw puzzle', 'time': 0, 'attempt': 0}
  ];
  List<Person> personId = [],
      persons = [],
      matching = [],
      dragDrop = [],
      activityScheduling = [],
      jigsawPuzzle = [];
  late String id; // = widget.id;
  bool showTopic = false;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    persons = widget.persons;

    matching = persons
        .where((p) => p.id == id && p.category == categories[0])
        .toList();
    dragDrop = persons
        .where((p) => p.id == id && p.category == categories[1])
        .toList();
    activityScheduling = persons
        .where((p) => p.id == id && p.category == categories[2])
        .toList();
    jigsawPuzzle = persons
        .where((p) => p.id == id && p.category == categories[3])
        .toList();
    personId = persons.where((p) => p.id == id).toList(); //.toList();
    _groupByCategory();
  }

  void _groupByCategory() {
    for (Person p in personId) {
      if (p.category == categories[0]) {
        cumulativeTime[0] += p.time;
        cumulativeAttempt[0] += p.numberOfAttempts + 1;
      }
      if (p.category == categories[1]) {
        cumulativeTime[1] += p.time;
        cumulativeAttempt[1] += p.numberOfAttempts + 1;
      }
      if (p.category == categories[2]) {
        cumulativeTime[2] += p.time;
        cumulativeAttempt[2] += p.numberOfAttempts + 1;
      } else {
        cumulativeTime[3] += p.time;
        cumulativeAttempt[3] += p.numberOfAttempts + 1;
      }
    }

    groupByCategory[0]['time'] = cumulativeTime[0];
    groupByCategory[0]['attempt'] = cumulativeAttempt[0];

    groupByCategory[1]['time'] = cumulativeTime[1];
    groupByCategory[1]['attempt'] = cumulativeAttempt[1];

    groupByCategory[2]['time'] = cumulativeTime[2];
    groupByCategory[2]['attempt'] = cumulativeAttempt[2];

    groupByCategory[3]['time'] = cumulativeTime[3];
    groupByCategory[3]['attempt'] = cumulativeAttempt[3];
  }

  //now build graph...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Page of $id'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Matching
            dropDown(0, true),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  height: 350,
                  child: SfCartesianChart(
                      plotAreaBackgroundColor:
                          const Color.fromARGB(255, 214, 211, 211),
                      primaryXAxis:
                          CategoryAxis(title: AxisTitle(text: 'Date')),
                      primaryYAxis:
                          NumericAxis(title: AxisTitle(text: 'Time (sec)')),
                      // Chart title
                      title: ChartTitle(
                          text: 'Time needed to solve Matching',
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      tooltipBehavior:
                          TooltipBehavior(enable: true, header: 'Matching'),
                      zoomPanBehavior: ZoomPanBehavior(
                          // Enables pinch zooming
                          zoomMode: ZoomMode.x,
                          enablePinching: true,
                          enableDoubleTapZooming: true,
                          enableMouseWheelZooming: true,
                          enableSelectionZooming: true),
                      series: dropDownValues[0] == 'Line'
                          ? getLineSeries(matching, 0, 0)
                          : dropDownValues[0] == 'Area'
                              ? getAreaSeries(matching, 0, 0)
                              : dropDownValues[0] == 'Column'
                                  ? getColumnSeries(matching, 0, 0)
                                  : dropDownValues[0] == 'Bar'
                                      ? getBarSeries(matching, 0, 0)
                                      : getSpLineSeries(matching, 0, 0)),
                ),
                SizedBox(
                  height: 350,
                  width: MediaQuery.of(context).size.width * .45,
                  child: SfCartesianChart(
                      plotAreaBackgroundColor:
                          const Color.fromARGB(255, 214, 211, 211),
                      primaryXAxis:
                          CategoryAxis(title: AxisTitle(text: 'Date')),
                      primaryYAxis: NumericAxis(
                          title: AxisTitle(text: 'Number of attempt')),
                      // Chart title
                      title: ChartTitle(
                          text: 'Attempts needed to solve Matching',
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      tooltipBehavior:
                          TooltipBehavior(enable: true, header: 'Matching'),
                      zoomPanBehavior: ZoomPanBehavior(
                          // Enables pinch zooming
                          zoomMode: ZoomMode.x,
                          enablePinching: true,
                          enableDoubleTapZooming: true,
                          enableMouseWheelZooming: true,
                          enableSelectionZooming: true),
                      series: dropDownValues[0] == 'Line'
                          ? getLineSeries(matching, 1, 0)
                          : dropDownValues[0] == 'Area'
                              ? getAreaSeries(matching, 1, 0)
                              : dropDownValues[0] == 'Column'
                                  ? getColumnSeries(matching, 1, 0)
                                  : dropDownValues[0] == 'Bar'
                                      ? getBarSeries(matching, 1, 0)
                                      : getSpLineSeries(matching, 1, 0)),
                ),
              ],
            ),
            //Drag & Drop
            dropDown(1, false),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  height: 350,
                  child: SfCartesianChart(
                      plotAreaBackgroundColor:
                          const Color.fromARGB(255, 214, 211, 211),
                      primaryXAxis:
                          CategoryAxis(title: AxisTitle(text: 'Date')),
                      primaryYAxis:
                          NumericAxis(title: AxisTitle(text: 'Time (sec)')),
                      // Chart title
                      title: ChartTitle(
                          text: 'Time needed to solve Drag & Drop',
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      tooltipBehavior:
                          TooltipBehavior(enable: true, header: 'Drag & Drop'),
                      zoomPanBehavior: ZoomPanBehavior(
                          // Enables pinch zooming
                          zoomMode: ZoomMode.x,
                          enablePinching: true,
                          enableDoubleTapZooming: true,
                          enableMouseWheelZooming: true,
                          enableSelectionZooming: true),
                      series: dropDownValues[1] == 'Line'
                          ? getLineSeries(dragDrop, 0, 1)
                          : dropDownValues[1] == 'Area'
                              ? getAreaSeries(dragDrop, 0, 1)
                              : dropDownValues[1] == 'Column'
                                  ? getColumnSeries(dragDrop, 0, 1)
                                  : dropDownValues[1] == 'Bar'
                                      ? getBarSeries(dragDrop, 0, 1)
                                      : getSpLineSeries(dragDrop, 0, 1)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  height: 350,
                  child: SfCartesianChart(
                      plotAreaBackgroundColor:
                          const Color.fromARGB(255, 214, 211, 211),
                      primaryXAxis:
                          CategoryAxis(title: AxisTitle(text: 'Date')),
                      primaryYAxis: NumericAxis(
                          title: AxisTitle(text: 'Number of attempt')),
                      // Chart title
                      title: ChartTitle(
                          text: 'Attempts needed to solve Drag & Drop',
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      tooltipBehavior:
                          TooltipBehavior(enable: true, header: 'Drag & Drop'),
                      zoomPanBehavior: ZoomPanBehavior(
                          // Enables pinch zooming
                          zoomMode: ZoomMode.x,
                          enablePinching: true,
                          enableDoubleTapZooming: true,
                          enableMouseWheelZooming: true,
                          enableSelectionZooming: true),
                      series: dropDownValues[1] == 'Line'
                          ? getLineSeries(dragDrop, 1, 1)
                          : dropDownValues[1] == 'Area'
                              ? getAreaSeries(dragDrop, 1, 1)
                              : dropDownValues[1] == 'Column'
                                  ? getColumnSeries(dragDrop, 1, 1)
                                  : dropDownValues[1] == 'Bar'
                                      ? getBarSeries(dragDrop, 1, 1)
                                      : getSpLineSeries(dragDrop, 1, 1)),
                ),
              ],
            ),
            //Activity Scheduling
            dropDown(2, true),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  height: 350,
                  child: SfCartesianChart(
                      plotAreaBackgroundColor:
                          const Color.fromARGB(255, 214, 211, 211),
                      primaryXAxis:
                          CategoryAxis(title: AxisTitle(text: 'Date')),
                      primaryYAxis:
                          NumericAxis(title: AxisTitle(text: 'Time (sec)')),
                      // Chart title
                      title: ChartTitle(
                          text: 'Time needed to solve Activity Scheduling',
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      tooltipBehavior: TooltipBehavior(
                          enable: true, header: 'Activity Scheduling'),
                      zoomPanBehavior: ZoomPanBehavior(
                          // Enables pinch zooming\
                          zoomMode: ZoomMode.x,
                          enablePinching: true,
                          enableDoubleTapZooming: true,
                          enableMouseWheelZooming: true,
                          enableSelectionZooming: true),
                      series: dropDownValues[2] == 'Line'
                          ? getLineSeries(activityScheduling, 0, 2)
                          : dropDownValues[2] == 'Area'
                              ? getAreaSeries(activityScheduling, 0, 2)
                              : dropDownValues[2] == 'Column'
                                  ? getColumnSeries(activityScheduling, 0, 2)
                                  : dropDownValues[2] == 'Bar'
                                      ? getBarSeries(activityScheduling, 0, 2)
                                      : getSpLineSeries(
                                          activityScheduling, 0, 2)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  height: 350,
                  child: SfCartesianChart(
                      plotAreaBackgroundColor:
                          const Color.fromARGB(255, 214, 211, 211),
                      primaryXAxis:
                          CategoryAxis(title: AxisTitle(text: 'Date')),
                      primaryYAxis: NumericAxis(
                          title: AxisTitle(text: 'Number of attempt')),
                      // Chart title
                      title: ChartTitle(
                          text: 'Attempts needed to solve Activity Scheduling',
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      tooltipBehavior: TooltipBehavior(
                          enable: true, header: 'Activity Scheduling'),
                      zoomPanBehavior: ZoomPanBehavior(
                          // Enables pinch zooming
                          zoomMode: ZoomMode.x,
                          enablePinching: true,
                          enableDoubleTapZooming: true,
                          enableMouseWheelZooming: true,
                          enableSelectionZooming: true),
                      series: dropDownValues[2] == 'Line'
                          ? getLineSeries(activityScheduling, 1, 2)
                          : dropDownValues[2] == 'Area'
                              ? getAreaSeries(activityScheduling, 1, 2)
                              : dropDownValues[2] == 'Column'
                                  ? getColumnSeries(activityScheduling, 1, 2)
                                  : dropDownValues[2] == 'Bar'
                                      ? getBarSeries(activityScheduling, 1, 2)
                                      : getSpLineSeries(
                                          activityScheduling, 1, 2)),
                ),
              ],
            ),
            //JIgsaw Puzzle
            dropDown(3, true),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  height: 350,
                  child: SfCartesianChart(
                      plotAreaBackgroundColor:
                          const Color.fromARGB(255, 214, 211, 211),
                      primaryXAxis:
                          CategoryAxis(title: AxisTitle(text: 'Date')),
                      primaryYAxis:
                          NumericAxis(title: AxisTitle(text: 'Time (sec)')),
                      // Chart title
                      title: ChartTitle(
                          text: 'Time needed to solve Jigsaw Puzzle',
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      tooltipBehavior: TooltipBehavior(
                          enable: true, header: 'Jigsaw Puzzle'),
                      zoomPanBehavior: ZoomPanBehavior(
                          // Enables pinch zooming
                          zoomMode: ZoomMode.x,
                          enablePinching: true,
                          enableDoubleTapZooming: true,
                          enableMouseWheelZooming: true,
                          enableSelectionZooming: true),
                      series: dropDownValues[3] == 'Line'
                          ? getLineSeries(jigsawPuzzle, 0, 3)
                          : dropDownValues[3] == 'Area'
                              ? getAreaSeries(jigsawPuzzle, 0, 3)
                              : dropDownValues[3] == 'Column'
                                  ? getColumnSeriesJigsaw(0)
                                  : dropDownValues[3] == 'Bar'
                                      ? getBarSeriesJigsaw(0)
                                      : getSpLineSeries(jigsawPuzzle, 0, 3)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  height: 350,
                  child: SfCartesianChart(
                      plotAreaBackgroundColor:
                          const Color.fromARGB(255, 214, 211, 211),
                      primaryXAxis:
                          CategoryAxis(title: AxisTitle(text: 'Date')),
                      primaryYAxis: NumericAxis(
                          title: AxisTitle(text: 'Number of attempt')),
                      // Chart title
                      title: ChartTitle(
                          text: 'Attempts needed to solve Jigsaw Puzzle',
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      tooltipBehavior: TooltipBehavior(
                          enable: true, header: 'Jigsaw Puzzle'),
                      zoomPanBehavior: ZoomPanBehavior(
                          // Enables pinch zooming
                          zoomMode: ZoomMode.x,
                          enablePinching: true,
                          enableDoubleTapZooming: true,
                          enableMouseWheelZooming: true,
                          enableSelectionZooming: true),
                      series: dropDownValues[3] == 'Line'
                          ? getLineSeries(jigsawPuzzle, 1, 3)
                          : dropDownValues[3] == 'Area'
                              ? getAreaSeries(jigsawPuzzle, 1, 3)
                              : dropDownValues[3] == 'Column'
                                  ? getColumnSeriesJigsaw(1)
                                  : dropDownValues[3] == 'Bar'
                                      ? getBarSeriesJigsaw(1)
                                      : getSpLineSeries(jigsawPuzzle, 1, 3)),
                ),
              ],
            ),
            //Pie chart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  height: 300,
                  child: SfCircularChart(
                    // Chart title
                    title: ChartTitle(
                        text: 'Time needed to solve problems',
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),

                    // Enable legend
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(
                        enable: true,
                        header: 'Overall Time',
                        activationMode: ActivationMode.singleTap),

                    series: getPieSeries(0),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  height: 300,
                  child: SfCircularChart(

                      // Chart title
                      title: ChartTitle(
                        text: 'Number of attempts to solve Problems',
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(
                          enable: true, header: 'Overall Attempts'),
                      series: getPieSeries(1)),
                ),
              ],
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  List<LineSeries<Person, String>> getLineSeries(
      List<Person> source, int label, int index) {
    return <LineSeries<Person, String>>[
      LineSeries<Person, String>(
          dataSource: source,
          enableTooltip: true,
          xValueMapper: (Person p, _) =>
              p.dateTime.toIso8601String().split('T').first,
          yValueMapper: (Person p, _) =>
              label == 0 ? p.time : p.numberOfAttempts + 1,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataLabelMapper: (Person p, _) => showTopics[index] == true
              ? p.topic
              : (label == 0 ? "${p.time}" : "${p.numberOfAttempts + 1}"))
    ];
  }

  List<SplineSeries<Person, String>> getSpLineSeries(
      List<Person> source, int label, int index) {
    return <SplineSeries<Person, String>>[
      SplineSeries<Person, String>(
          splineType: SplineType.cardinal,
          dataSource: source,
          enableTooltip: true,
          xValueMapper: (Person p, _) =>
              p.dateTime.toIso8601String().split('T').first,
          yValueMapper: (Person p, _) =>
              label == 0 ? p.time : p.numberOfAttempts + 1,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataLabelMapper: (Person p, _) => showTopics[index] == true
              ? p.topic
              : (label == 0 ? "${p.time}" : "${p.numberOfAttempts + 1}"))
    ];
  }

  List<ColumnSeries<Person, String>> getColumnSeries(
      List<Person> source, int label, int index) {
    return <ColumnSeries<Person, String>>[
      ColumnSeries<Person, String>(
          dataSource: source,
          enableTooltip: true,
          xValueMapper: (Person p, _) =>
              p.dateTime.toIso8601String().split('T').first,
          yValueMapper: (Person p, _) => label == 0
              ? p.time
              : label == 1
                  ? p.numberOfAttempts + 1
                  : p.level,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataLabelMapper: (Person p, _) => showTopics[index] == true
              ? p.topic
              : (label == 0 ? "${p.time}" : "${p.numberOfAttempts + 1}")),
    ];
  }

  List<ColumnSeries<Person, String>> getColumnSeriesJigsaw(int label) {
    return <ColumnSeries<Person, String>>[
      ColumnSeries<Person, String>(
          dataSource: jigsawPuzzle, //personId,
          enableTooltip: true,
          xValueMapper: (Person p, _) =>
              p.dateTime.toIso8601String().split('T').first, //
          yValueMapper: (Person p, _) =>
              label == 0 ? p.time : p.numberOfAttempts + 1,
          // Enable data label
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataLabelMapper: (Person p, _) => showTopics[3] == true
              ? p.topic
              : (label == 0 ? "${p.time}" : "${p.numberOfAttempts + 1}")),
      ColumnSeries<Person, String>(
        dataSource: jigsawPuzzle, //personId,
        enableTooltip: true,
        xValueMapper: (Person p, _) =>
            p.dateTime.toIso8601String().split('T').first, //
        yValueMapper: (Person p, _) => p.level,
        // Enable data label
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      )
    ];
  }

  List<AreaSeries<Person, String>> getAreaSeries(
      List<Person> source, int label, int index) {
    return <AreaSeries<Person, String>>[
      AreaSeries<Person, String>(
          dataSource: source,
          enableTooltip: true,
          xValueMapper: (Person p, _) =>
              p.dateTime.toIso8601String().split('T').first,
          yValueMapper: (Person p, _) =>
              label == 0 ? p.time : p.numberOfAttempts + 1,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataLabelMapper: (Person p, _) => showTopics[index] == true
              ? p.topic
              : (label == 0 ? "${p.time}" : "${p.numberOfAttempts + 1}"))
    ];
  }

  List<BarSeries<Person, String>> getBarSeries(
      List<Person> source, int label, int index) {
    return <BarSeries<Person, String>>[
      BarSeries<Person, String>(
          dataSource: source,
          enableTooltip: true,
          xValueMapper: (Person p, _) =>
              p.dateTime.toIso8601String().split('T').first,
          yValueMapper: (Person p, _) => label == 0
              ? p.time
              : label == 1
                  ? p.numberOfAttempts + 1
                  : p.level,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataLabelMapper: (Person p, _) => showTopics[index] == true
              ? p.topic
              : (label == 0 ? "${p.time}" : "${p.numberOfAttempts + 1}"))
    ];
  }

  List<BarSeries<Person, String>> getBarSeriesJigsaw(int label) {
    return <BarSeries<Person, String>>[
      BarSeries<Person, String>(
          dataSource: jigsawPuzzle, //personId,
          enableTooltip: true,
          xValueMapper: (Person p, _) =>
              p.dateTime.toIso8601String().split('T').first, //
          yValueMapper: (Person p, _) =>
              label == 0 ? p.time : p.numberOfAttempts + 1,
          // Enable data label
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataLabelMapper: (Person p, _) => showTopics[3] == true
              ? p.topic
              : (label == 0 ? "${p.time}" : "${p.numberOfAttempts + 1}")),
      BarSeries<Person, String>(
        dataSource: jigsawPuzzle, //personId,
        enableTooltip: true,
        xValueMapper: (Person p, _) =>
            p.dateTime.toIso8601String().split('T').first, //
        yValueMapper: (Person p, _) => p.level,
        // Enable data label
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      )
    ];
  }

  List<CircularSeries<Map<String, Object>, Object>> getPieSeries(int label) {
    return <CircularSeries<Map<String, Object>, Object>>[
      // Render pie chart
      PieSeries<Map<String, Object>, Object>(
          dataSource: groupByCategory,
          enableTooltip: true,
          // pointColorMapper:(Person data, _) => Colors.amber,
          xValueMapper: (Map<String, Object> p, _) => p['title'], //as String,
          yValueMapper: (Map<String, Object> p, _) =>
              label == 0 ? p['time'] as num : p['attempt'] as num,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          radius: '100%',
          explode: true,
          explodeGesture: ActivationMode.singleTap)
    ];
  }

  Widget dropDown(int label, bool topicOption) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Chart Type: ',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: dropDownValues[label],
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Color(0xFF673AB7), fontSize: 16),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropDownValues[label] = value!;
            });
          },
          items: chartTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(width: 10),
        topicOption
            ? Checkbox(
                value: showTopics[label],
                onChanged: (value) {
                  setState(() {
                    showTopics[label] = value;
                  });
                },
              )
            : const Text(''),
        const SizedBox(width: 10),
        topicOption
            ? const Text(
                'Show Topic',
                style: TextStyle(fontSize: 16),
              )
            : const Text(''),
      ],
    );
  }
}
