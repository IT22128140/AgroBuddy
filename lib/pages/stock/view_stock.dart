// ignore_for_file: use_build_context_synchronously

import 'package:agro_buddy/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:agro_buddy/services/stock_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/models/stock_model.dart';
import 'package:agro_buddy/components/my_button_small.dart';
import 'package:agro_buddy/components/my_delete_button.dart';

class ViewStock extends StatefulWidget {
  final String stockID; // Accept the Firebase stockID as an argument
  const ViewStock({super.key, required this.stockID});

  @override
  _ViewStockState createState() => _ViewStockState();
}

class _ViewStockState extends State<ViewStock> {
  final StockServices _stockServices = StockServices();
  late Future<Stock?>
      _stockFuture; // Allow Stock to be nullable since it can be null

  @override
  void initState() {
    super.initState();
    print("Fetching stock with ID: ${widget.stockID}"); // Debug print
    _stockFuture = _stockServices
        .getStockById(widget.stockID); // Fetch stock details by ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 99, 31),
      body: FutureBuilder<Stock?>(
        future: _stockFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No stock data found'));
          }

          Stock stock = snapshot.data!; // Data exists

          return Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 58, 12.0, 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(12.0, 8, 12.0, 12.0),
                  height: 600,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildRow(
                            AppLocalizations.of(context)!.stockID,
                            stock.stockID ?? 'N/A', // Handle nullable field
                          ),
                          SizedBox(height: 10),
                          buildRow(
                            AppLocalizations.of(context)!.type,
                            stock.stockType, // Handle nullable field
                          ),
                          SizedBox(height: 10),
                          buildRow(
                            AppLocalizations.of(context)!.stockName,
                            stock.stockName, // Handle nullable field
                          ),
                          SizedBox(height: 10),
                          buildRow(
                            AppLocalizations.of(context)!.purchasedDate,
                            '${stock.purchasedDate.day}/${stock.purchasedDate.month}/${stock.purchasedDate.year}', // Handle nullable field
                          ),
                          SizedBox(height: 10),
                          buildRow(
                            AppLocalizations.of(context)!.quantity,
                            stock.quantity.toString(), // Handle nullable field
                          ),
                          SizedBox(height: 10),
                          buildRow(
                            AppLocalizations.of(context)!.expDate,
                            '${stock.expDate.day}/${stock.expDate.month}/${stock.expDate.year}', // Handle nullable field
                          ),
                          SizedBox(height: 10),
                          buildRow(
                            AppLocalizations.of(context)!.purchasedPrice,
                            stock.purchasedPrice
                                .toString(), // Handle nullable field
                          ),
                          SizedBox(height: 10),
                          buildRow(
                            AppLocalizations.of(context)!.supplier,
                            stock.supplier, // Handle nullable field
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.additionalNotes,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 200,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      stock
                                          .additionalNotes, // Handle nullable field
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: MyDeleteButton(
                          text: AppLocalizations.of(context)!.delete,
                          onTap: () async {
                            bool? confirmDelete = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors
                                      .white, // Change the background color
                                  title: Text(AppLocalizations.of(context)!
                                      .confirm_delete),
                                  content: Text(AppLocalizations.of(context)!
                                      .delete_confirmation),
                                  actions: <Widget>[
                                    Row(
                                      children: [
                                        MyDeleteButton(
                                          text: AppLocalizations.of(context)!
                                              .delete,
                                          onTap: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        MyButton(
                                          text: AppLocalizations.of(context)!
                                              .cancel,
                                          onTap: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            );

                            if (confirmDelete == true) {
                              await _stockServices
                                  .deleteStock(stock.stockID ?? 'N/A');
                              await Navigator.pushNamed(context, 'harvest_list',
                                  arguments: stock.stockID);
                            }
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: MyButtonSmall(
                          text: AppLocalizations.of(context)!.edit,
                          onTap: () {
                            // Edit functionality can be handled here
                            Navigator.of(context)
                                .pushNamed('stock_edit', arguments: stock);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to build a row for stock details
  Widget buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  // // Show delete confirmation dialog
  // void _showDeleteConfirmationDialog(Stock stock) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(AppLocalizations.of(context)!.confirmDelete),
  //         content: Text(AppLocalizations.of(context)!.deleteConfirmationMessage),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               // Cancel action
  //               Navigator.of(context).pop();
  //             },
  //             child: Text(AppLocalizations.of(context)!.cancel),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               // Delete stock item and pop back to previous screen
  //               await _stockServices.deleteStock(stock.stockID ?? 'N/A');
  //               Navigator.of(context).pop(); // Close the dialog
  //               Navigator.of(context).popUntil((route) => route.isFirst); // Go back to previous screen (if you want to return to the stock list)
  //             },
  //             child: Text(AppLocalizations.of(context)!.delete),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
