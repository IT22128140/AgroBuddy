// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agro_buddy/components/my_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:agro_buddy/models/stock_model.dart';
import 'package:agro_buddy/services/stock_services.dart';

class AddStock extends StatefulWidget {
  const AddStock({super.key});

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  final StockServices _firestoreService = StockServices();
  final User user = FirebaseAuth.instance.currentUser!;
  // Controllers for TextFields
  final TextEditingController stockNameController = TextEditingController();
  final TextEditingController purchasedDateController = TextEditingController();
  final TextEditingController expDateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController purchasedPriceController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController additionalNotesController = TextEditingController();

  // Variable to hold the selected stock type
  String selectedStockType = 'Seeds';

  // Function to add stock details to Firestore
  Future<void> createStock() async {
    Stock newStock = Stock(
      uid: user.uid,
      stockName: stockNameController.text,
      purchasedDate: DateTime.parse(purchasedDateController.text), // Convert String to DateTime
      expDate: DateTime.parse(expDateController.text),             // Convert String to DateTime
      quantity: quantityController.text,
      purchasedPrice: purchasedPriceController.text,
      supplier: supplierController.text,
      additionalNotes: additionalNotesController.text,
      stockType: selectedStockType,
    );

    await _firestoreService.addStock(newStock); // Firebase auto-generates the stockID
  }

  // Function to open DatePicker and update the controller
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      controller.text = formattedDate; // Set the selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 40, 99, 31),
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    // Use Stack to position the button
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start, // Align items to start
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  activeColor: const Color.fromARGB(255, 250, 230, 35),
                                  title: Text('Seeds', style: TextStyle(color: Colors.white)),
                                  value: 'Seeds',
                                  groupValue: selectedStockType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedStockType = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  activeColor: const Color.fromARGB(255, 250, 230, 35),
                                  title: Text('Fertilizer', style: TextStyle(color: Colors.white)),
                                  value: 'Fertilizer',
                                  groupValue: selectedStockType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedStockType = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5), // Add spacing between rows
                          SizedBox(
                            width: 400, // Set the desired width here
                            child: TextField(
                              controller: stockNameController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.stockName,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 400, // Set the desired width here
                            child: TextField(
                              controller: purchasedDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.purchasedDate,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              onTap: () => _selectDate(context, purchasedDateController),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 400, // Set the desired width here
                            child: TextField(
                              controller: quantityController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.quantity,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 400, // Set the desired width here
                            child: TextField(
                              controller: expDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.expDate,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              onTap: () => _selectDate(context, expDateController),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 400, // Set the desired width here
                            child: TextField(
                              controller: purchasedPriceController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.purchasedPrice,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 400, // Set the desired width here
                            child: TextField(
                              controller: supplierController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.supplier,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 400, // Set the desired width here
                            child: TextField(
                              controller: additionalNotesController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.additionalNotes,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 20,
            child: MyButton(
              text: AppLocalizations.of(context)!.save,
              onTap: () async {
                await createStock();
                Navigator.of(context).pushNamed('stock_list');
              },
            ),
          ),
        ],
      ),
    );
  }
}
