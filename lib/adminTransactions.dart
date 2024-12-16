import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/order.dart';

class AdminTransactions extends StatefulWidget {
  const AdminTransactions({super.key});

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
      //print("you are here bro");

      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
     // print('map: $data');
      setState(() {
        orders = data.entries
            .where((entry) => entry.value is Map)
            .map((entry) =>
                Order.fromMap(Map<String, dynamic>.from(entry.value)))
            .toList();
        //print("Herrrrrrrrrrrrre");
      });
      //print(orders);
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
      body: 
        //  orders.isEmpty
        //   ? const Center(
        //       child: Text(
        //       "No Orders Found",
        //       style: TextStyle(fontSize: 18),
        //     ))
        Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orders.length ?? 0,
              itemBuilder: (context, index1) {
                 if (orders.isNotEmpty) {
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                          children: [
                            const Text(
                              "Order Date: ",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 15),
                            Text(order.orderDate), 
                          ],
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
                                  errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image, size: 80);
                              },
                                ),
                              ),
                              title: Text(item.productName),
                              subtitle: Text('x ${item.quantity}'),
                              trailing:
                                  Text('EGP${item.price.toStringAsFixed(2)}'),
                            );
                          }),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                              child: Text(
                            "Total: EGP${order.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
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
                 }
                else {
                  return const Center(child: Text("No Orders found"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
