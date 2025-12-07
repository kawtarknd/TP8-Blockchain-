// lib/helloUI.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';

class HelloUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractLinking>(context);
    final TextEditingController yourNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Hello World DApp"), centerTitle: true),
      body: Center(
        child: contractLink.isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hello ${contractLink.deployedName}",
                      style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: yourNameController,
                      decoration: InputDecoration(
                        labelText: "Your Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text("Set Name"),
                    onPressed: () {
                      if (yourNameController.text.trim().isNotEmpty) {
                        contractLink.setName(yourNameController.text.trim());
                      }
                    },
                  )
                ],
              ),
      ),
    );
  }
}
