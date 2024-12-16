import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_sales_graph/flutter_sales_graph.dart';

class AdminChart extends StatefulWidget {
  const AdminChart({super.key});

  // const AdminChart({super.key});
  @override
  _AdminChartState createState() => _AdminChartState();
}

class _AdminChartState extends State<AdminChart> {
  // List<SalesData> salesData = [];
  List<double> salesData = [];
  List<String> labels = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Future<void> fetchData() async {
  //   DatabaseReference databaseReference =
  //       FirebaseDatabase.instance.ref("totalSell");
  //   DatabaseEvent dataSnapShot = await databaseReference.once();
  //   Map<dynamic, dynamic> values =
  //       dataSnapShot.snapshot.value as Map<dynamic, dynamic>;
  //   setState(() {
  //     salesData = values.values
  //         .map((e) => double.parse(e['totalSell'].toString()))
  //         .toList();
  //     labels = values.values.map((e) => e['productName'].toString()).toList();
  //   });
  // }

  Future<void> fetchData() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref("totalSell");
    DatabaseEvent dataSnapShot = await databaseReference.once();

    Map<dynamic, dynamic> values =
        dataSnapShot.snapshot.value as Map<dynamic, dynamic>;

    // Combine sales data and labels into a list of MapEntries for sorting
    List<MapEntry<double, String>> combined = values.values
        .map((e) => MapEntry(
              double.parse(e['totalSell'].toString()),
              e['productName'].toString(),
            ))
        .toList();

    // Sort by sales data in descending order
    combined.sort((a, b) => b.key.compareTo(a.key));

    // Take the top 5 entries
    combined = combined.take(5).toList();

    // Separate back into salesData and labels
    setState(() {
      salesData = combined.map((e) => e.key).toList();
      labels = combined.map((e) => e.value).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Top 5 BestSeller Products"),
        ),
        body: SizedBox.expand(
            child: Center(
                child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FlutterSalesGraph(
            salesData: salesData,
            labels: labels,
            maxBarHeight: 300.0,
            barWidth: 50.0,
            colors: const [Colors.blue, Colors.green, Colors.red],
            dateLineHeight: 25,
          ),
        ))));
  }
}
