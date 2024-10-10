// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agro_buddy/components/my_button.dart';
import 'package:agro_buddy/components/my_button_small.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/models/stock_model.dart';
import 'package:agro_buddy/services/stock_services.dart'; // Import StockServices

class StockList extends StatefulWidget {
  const StockList({super.key});

  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  final StockServices _stockServices = StockServices();
  final User user = FirebaseAuth.instance.currentUser!;
  late Future<List<Stock>> _stockListFuture;

  @override
  void initState() {
    super.initState();
    _stockListFuture = _stockServices.getStocks(user.uid); // Fetch all stocks
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 99, 31),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Stock>>(
              future: _stockListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 250, 230, 35)),
                  ));
                } else if (snapshot.hasError) {
                  return Text(AppLocalizations.of(context)!.error,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 250, 230, 35),
                          fontSize: 30));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(AppLocalizations.of(context)!.no_data,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 250, 230, 35),
                          fontSize: 30));
                }
                // If data is available, display it
                List<Stock> stockList = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: stockList.map((stock) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 2, 12.0, 12.0),
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)!.stockID,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          stock.stockID ??
                                              '', // Handle null case
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)!
                                              .stockName,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(stock.stockName,
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)!
                                              .purchasedDate,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          '${stock.purchasedDate.day}/${stock.purchasedDate.month}/${stock.purchasedDate.year}',
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)!
                                              .quantity,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(stock.quantity,
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)!.expDate,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          '${stock.expDate.day}/${stock.expDate.month}/${stock.expDate.year}',
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: MyButtonSmall(
                                  text: AppLocalizations.of(context)!.view,
                                  onTap: () {
                                    // Print stock ID for debugging
                                    print(
                                        "Navigating to view stock with ID: ${stock.stockID}");

                                    // Navigate to the view page
                                    Navigator.of(context).pushNamed(
                                      'stock_view',
                                      arguments: stock.stockID ??
                                          '', // Handle null case
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 20, top: 20, left: 110, right: 110),
            child: MyButton(
              text: AppLocalizations.of(context)!.add,
              onTap: () {
                Navigator.of(context).pushNamed('stock_add');
              },
            ),
          ),
        ],
      ),
    );
  }
}
