// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:agro_buddy/components/my_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class Restock extends StatefulWidget {
  const Restock({super.key});

  @override
  State<Restock> createState() => _RestockState();
}

class _RestockState extends State<Restock> {
  // Controllers for TextFields
  final TextEditingController purchasedDateController = TextEditingController();
  final TextEditingController expDateController = TextEditingController();

  // Function to open DatePicker and update the controller
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
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
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Align items to start
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.stockID,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('F003',
                                  style: TextStyle(
                                      fontSize: 28, color: Colors.white)),
                            ],
                          ),
                          SizedBox(height: 5), // Add spacing between rows
                          SizedBox(
                            width: 400, // Set the desired width here
                            child: TextField(
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.stockName,
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
                                labelText:
                                    AppLocalizations.of(context)!.purchasedDate,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              onTap: () =>
                                  _selectDate(context, purchasedDateController),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 400, // Set the desired width here
                            child: TextField(
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.quantity,
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
                              controller: expDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.expDate,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              onTap: () =>
                                  _selectDate(context, expDateController),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 400, // Set the desired width here
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .purchasedPrice,
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
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.supplier,
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
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .additionalNotes,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
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
            bottom: 10,
            right: 8,
            child: MyButton(
              text: AppLocalizations.of(context)!.save,
              onTap: () {
                Navigator.of(context).pushNamed('stock_view');
              },
            ),
          ),
        ],
      ),
    );
  }
}
