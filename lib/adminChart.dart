import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_sales_graph/flutter_sales_graph.dart';

class AdminChart extends StatefulWidget {
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

  Future<void> fetchData() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref("totalSell");
    DatabaseEvent dataSnapShot = await databaseReference.once();
    Map<dynamic, dynamic> values =
        dataSnapShot.snapshot.value as Map<dynamic, dynamic>;

    setState(() {
      salesData = values.values
          .map((e) => double.parse(e['totalSell'].toString()))
          .toList();
      labels = values.values.map((e) => e['productName'].toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Best Sold Products"),
        ),
        body: SizedBox.expand(
            child: Center(
                child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FlutterSalesGraph(
            salesData: salesData,
            labels: labels,
            maxBarHeight: 250.0,
            barWidth: 50.0,
            colors: const [Colors.blue, Colors.green, Colors.red],
            dateLineHeight: 25,
          ),
        ))));
  }
}
