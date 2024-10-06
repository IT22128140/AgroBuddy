// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agro_buddy/components/my_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:agro_buddy/models/stock_model.dart';
import 'package:agro_buddy/services/stock_services.dart';

class EditStock extends StatefulWidget {
  final Stock stock; // Accept the stock instance for editing
  const EditStock({super.key, required this.stock});
  

  @override
  State<EditStock> createState() => _EditStockState();
}

class _EditStockState extends State<EditStock> {
  // Controllers for TextFields
  final TextEditingController stockIDController = TextEditingController();
  final TextEditingController stockTypeController = TextEditingController();
  final TextEditingController stockNameController = TextEditingController();
  final TextEditingController purchasedDateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController expDateController = TextEditingController();
  final TextEditingController purchasedPriceController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController additionalNotesController = TextEditingController();

  final StockServices _stockServices = StockServices();
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    // Pre-fill the TextField controllers with stock data
    stockIDController.text = widget.stock.stockID ?? '';
    stockTypeController.text = widget.stock.stockType; 
    stockNameController.text = widget.stock.stockName;// Assuming stockType is the stock name
    purchasedDateController.text = DateFormat('yyyy-MM-dd').format(widget.stock.purchasedDate);
    quantityController.text = widget.stock.quantity.toString();
    expDateController.text = DateFormat('yyyy-MM-dd').format(widget.stock.expDate);
    purchasedPriceController.text = widget.stock.purchasedPrice.toString();
    supplierController.text = widget.stock.supplier;
    additionalNotesController.text = widget.stock.additionalNotes;
  }

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

  void _saveStock() {
    // Create a new Stock object with the updated values
    Stock updatedStock = Stock(
      uid: user.uid,
      stockID: stockIDController.text,
      stockName: stockNameController.text,
      stockType: stockNameController.text,
      purchasedDate: DateTime.parse(purchasedDateController.text),
      quantity: quantityController.text,
      expDate: DateTime.parse(expDateController.text),
      purchasedPrice: purchasedPriceController.text,
      supplier: supplierController.text,
      additionalNotes: additionalNotesController.text,
    );

    // Call the update method
    _stockServices.updateStock(widget.stock.stockID ?? 'N/A', updatedStock).then((_) {
      // Navigate back to the stock view page after successful update
      Navigator.of(context).pushNamed('stock_view', arguments: updatedStock.stockID);
    }).catchError((error) {
      print("Failed to update stock: $error");
    });
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(stockIDController.text,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ],
                          ),
                          SizedBox(height: 5),
                          _buildTextField(stockTypeController, AppLocalizations.of(context)!.type),
                          _buildTextField(stockNameController, AppLocalizations.of(context)!.stockName),
                          _buildTextField(purchasedDateController, AppLocalizations.of(context)!.purchasedDate, true),
                          _buildTextField(quantityController, AppLocalizations.of(context)!.quantity),
                          _buildTextField(expDateController, AppLocalizations.of(context)!.expDate, true),
                          _buildTextField(purchasedPriceController, AppLocalizations.of(context)!.purchasedPrice),
                          _buildTextField(supplierController, AppLocalizations.of(context)!.supplier),
                          _buildTextField(additionalNotesController, AppLocalizations.of(context)!.additionalNotes),
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
              onTap: _saveStock, // Call the save function
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [bool isDate = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: 400, // Set the desired width here
        child: TextField(
          controller: controller,
          readOnly: isDate,
          decoration: InputDecoration(
            labelText: label,
            border: const UnderlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          onTap: isDate ? () => _selectDate(context, controller) : null,
        ),
      ),
    );
  }
}
