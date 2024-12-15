import 'package:flutter/material.dart';

class AddNewAddressPage extends StatefulWidget {
  final String initialPhone;
  final String initialAddress;

  const AddNewAddressPage({super.key, required this.initialPhone, required this.initialAddress});

  @override
  _AddNewAddressPageState createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final _formKey = GlobalKey<FormState>();

  late String phoneController = '';
  late String addressController = '';

  @override
  void initState() {
    super.initState();
    // phoneController.text = widget.initialPhone;
    // addressController.text = widget.initialAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add your Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(  
          key: _formKey,  
          child: Column(
            children: [
              TextFormField(
                //controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone),
                ),
                onSaved: (value) =>
                      phoneController = value!.trim(),
                validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid Phone number';
                      }
                      return null;
                    },
              ),
              const SizedBox(height: 8),
              TextFormField(
                //controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  prefixIcon: Icon(Icons.location_on),
                ),
                onSaved: (value) =>
                      addressController = value!.trim(),
                validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid Address';
                      }
                      return null;
                    },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(context, {
                        'phone': phoneController,
                        'address': addressController,
                      });
                } else {
                    // Show an error message if the form is invalid
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill out all fields')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text("Save"),
              ),
            ],
          ),
      )
      ),
    );
  }
}
