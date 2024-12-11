import 'package:flutter/material.dart';

class AddNewAddressPage extends StatefulWidget {
  final String initialPhone;
  final String initialAddress;

  AddNewAddressPage({required this.initialPhone, required this.initialAddress});

  @override
  _AddNewAddressPageState createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.initialPhone;
    addressController.text = widget.initialAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Address"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: "Address",
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'phone': phoneController.text,
                  'address': addressController.text,
                });
              },
              child: Text("Save"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
