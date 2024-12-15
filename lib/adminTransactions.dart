import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Product.dart';
import 'package:flutter_app/order.dart';
import 'package:flutter_app/CartItem.dart';

class AdminTransactions extends StatefulWidget {
  AdminTransactions({super.key});

  @override
  _AdminTransactionsState createState() => _AdminTransactionsState();
}

class _AdminTransactionsState extends State<AdminTransactions> {
  List<Order> orders = [];

  //Fetch all orders from the database
  final DatabaseReference ref = FirebaseDatabase.instance.ref('Orders');

  void fetchOrders() async {
    final snapshot = await ref.get();
    if (snapshot.exists) {
      print("you are here bro");

      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      print('map: $data');
      setState(() {
        orders = data.entries
            .where((entry) => entry.value is Map)
            .map((entry) =>
                Order.fromMap(Map<String, dynamic>.from(entry.value)))
            .toList();
        print("Herrrrrrrrrrrrre");
      });
      print(orders);
      // setState(() {
      //   orders = (snapshot.value as List<dynamic>)
      //       .map((item) => Order.fromMap(Map<String, dynamic>.from(item)))
      //       .toList();
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
    // print(orders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders & feedback")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orders.length ?? 0,
              itemBuilder: (context, index1) {
                if (orders.isNotEmpty && orders != null) {
                  final order = orders[index1];
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "#${index1 + 1}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ...order.items.map((item) {
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  item.imgURL,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(item.productName),
                              subtitle: Text('x ${item.quantity}'),
                              trailing:
                                  Text('\$${item.price.toStringAsFixed(2)}'),
                            );
                          }).toList(),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                              child: Text(
                            "Total: \$${order.totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Text("Feedback : ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(order.feedback)
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Text("Rating : ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(order.rating.toString())
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text("No Orders found"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
