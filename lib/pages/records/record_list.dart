import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agro_buddy/components/my_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/components/my_button_small.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro_buddy/services/database_service.dart';
import 'package:agro_buddy/models/record.dart';
import "package:firebase_auth/firebase_auth.dart";

class RecordList extends StatefulWidget {
  const RecordList({super.key});

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  final DatabaseService databaseService = DatabaseService();
  final User user = FirebaseAuth.instance.currentUser!;

  double calculateIncome(List<DocumentSnapshot> docs) {
    double totalIncome = 0.0;
    for (var doc in docs) {
      final record = Records.fromSnapshot(doc);
      if (record.type == 'Income') {
        totalIncome += record.amount;
      }
    }
    return totalIncome;
  }

  double calculateExpense(List<DocumentSnapshot> docs) {
    double totalExpense = 0.0;
    for (var doc in docs) {
      final record = Records.fromSnapshot(doc);
      if (record.type == 'Expense') {
        totalExpense += record.amount;
      }
    }
    return totalExpense;
  }

  double calculateTotal(List<DocumentSnapshot> docs) {
    double total = 0.0;
    for (var doc in docs) {
      final record = Records.fromSnapshot(doc);
      if (record.type == 'Income') {
        total += record.amount;
      } else {
        total -= record.amount;
      }
    }
    return total;
  }

  String? selectedTimeRange;
  String? selectedTime;
  List<DropdownMenuItem<String>> dynamicItems = [];

  late Stream<QuerySnapshot<Object?>> filteredData;

  @override
  void initState() {
    super.initState();
    filteredData = databaseService.getFilteredRecordsStream(
        timeRange: selectedTimeRange,
        selectedTime: selectedTime,
        uid: user.uid);
  }

  void updateDynamicItems(String? timeRange, BuildContext context) {
    if (timeRange == 'month') {
      dynamicItems = [
        DropdownMenuItem<String>(
            value: '01', child: Text(AppLocalizations.of(context)!.january)),
        DropdownMenuItem<String>(
            value: '02', child: Text(AppLocalizations.of(context)!.february)),
        DropdownMenuItem<String>(
            value: '03', child: Text(AppLocalizations.of(context)!.march)),
        DropdownMenuItem<String>(
            value: '04', child: Text(AppLocalizations.of(context)!.april)),
        DropdownMenuItem<String>(
            value: '05', child: Text(AppLocalizations.of(context)!.may)),
        DropdownMenuItem<String>(
            value: '06', child: Text(AppLocalizations.of(context)!.june)),
        DropdownMenuItem<String>(
            value: '07', child: Text(AppLocalizations.of(context)!.july)),
        DropdownMenuItem<String>(
            value: '08', child: Text(AppLocalizations.of(context)!.august)),
        DropdownMenuItem<String>(
            value: '09', child: Text(AppLocalizations.of(context)!.september)),
        DropdownMenuItem<String>(
            value: '10', child: Text(AppLocalizations.of(context)!.october)),
        DropdownMenuItem<String>(
            value: '11', child: Text(AppLocalizations.of(context)!.november)),
        DropdownMenuItem<String>(
            value: '12', child: Text(AppLocalizations.of(context)!.december)),
      ];
    } else if (timeRange == 'year') {
      dynamicItems = List.generate(DateTime.now().year - 2020 + 1, (index) {
        return DropdownMenuItem<String>(
          value: '${2020 + index}',
          child: Text('${2020 + index}'),
        );
      });
    } else if (timeRange == 'sixm') {
      dynamicItems = [
        DropdownMenuItem<String>(
            value: 'Jan-Jun',
            child: Text(AppLocalizations.of(context)!.jan_jun)),
        DropdownMenuItem<String>(
            value: 'Jul-Dec',
            child: Text(AppLocalizations.of(context)!.jul_dec)),
      ];
    } else {
      dynamicItems = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 44, 99, 31),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: DropdownButtonFormField<String>(
                value: selectedTimeRange,
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.sel_trange,
                  border: const UnderlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: [
                  DropdownMenuItem<String>(
                      value: 'year',
                      child: Text(AppLocalizations.of(context)!.tr_year)),
                  DropdownMenuItem<String>(
                      value: 'sixm',
                      child: Text(AppLocalizations.of(context)!.tr_sixm)),
                  DropdownMenuItem<String>(
                      value: 'month',
                      child: Text(AppLocalizations.of(context)!.tr_month)),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTimeRange = newValue;
                    updateDynamicItems(newValue, context);
                    selectedTime = null;
                    filteredData = databaseService.getFilteredRecordsStream(
                        timeRange: selectedTimeRange,
                        selectedTime: selectedTime,
                        uid: user.uid);
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            if (selectedTimeRange != null)
              SizedBox(
                width: 350,
                child: DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.sel_trange,
                    border: const UnderlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: selectedTime,
                  items: dynamicItems,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTime = newValue;
                      filteredData = databaseService.getFilteredRecordsStream(
                          timeRange: selectedTimeRange,
                          selectedTime: selectedTime,
                          uid: user.uid);
                    });
                  },
                ),
              ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              width: 350,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: filteredData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 250, 230, 35)),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.income,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.rs}0.00',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 250, 230, 35),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                              child: VerticalDivider(
                                color: Colors.white,
                                thickness: 3,
                                width: 3,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.expense,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.rs}0.00',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 187, 9, 9),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 350,
                          child: Divider(
                            color: Colors.white,
                            thickness: 3,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.total_s,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.rs}0.00',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(AppLocalizations.of(context)!.error,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 250, 230, 35),
                            fontSize: 30));
                  } else {
                    final totalIncome = calculateIncome(snapshot.data!.docs);
                    final totalExpense = calculateExpense(snapshot.data!.docs);
                    final total = calculateTotal(snapshot.data!.docs);
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.income,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.rs}$totalIncome',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 250, 230, 35),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                              child: VerticalDivider(
                                color: Colors.white,
                                thickness: 3,
                                width: 3,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.expense,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.rs}$totalExpense',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 187, 9, 9),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 350,
                          child: Divider(
                            color: Colors.white,
                            thickness: 3,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.total_s,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.rs}$total',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyButton(
                    text: AppLocalizations.of(context)!.show_ill,
                    onTap: () async {
                      final snapshot = await databaseService.getFilteredRecordsStream(
                        timeRange: selectedTimeRange,
                        selectedTime: selectedTime,
                        uid: user.uid
                      ).first;
                      final docs = snapshot.docs;
                      final totalIncome = calculateIncome(docs);
                      final totalExpense = calculateExpense(docs);
                      final total = calculateTotal(docs);
                      
                      // Navigate to ShowCharts with the calculated data
                      Navigator.pushNamed(
                        context,
                        'show_charts',
                        arguments: {
                          'totalIncome': totalIncome,
                          'totalExpense': totalExpense,
                          'total': total,
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 3,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: filteredData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 250, 230, 35)),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text(AppLocalizations.of(context)!.no_data,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 250, 230, 35),
                            fontSize: 30));
                  } else if (snapshot.hasError) {
                    return Text(AppLocalizations.of(context)!.error,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 250, 230, 35),
                            fontSize: 30));
                  } else {
                    final records = snapshot.data!;
                    return ListView.builder(
                      itemCount: records.docs.length,
                      itemBuilder: (context, index) {
                        final record =
                            Records.fromSnapshot(records.docs[index]);
                        var id = records.docs[index].id;
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat('yyyy-MM-dd')
                                            .format(record.dateTime),
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        DateFormat('HH:mm')
                                            .format(record.dateTime),
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    record.type == 'Income'
                                        ? AppLocalizations.of(context)!.income
                                        : AppLocalizations.of(context)!.expense,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  Text(
                                    record.category,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  Text(
                                    '${AppLocalizations.of(context)!.rs}${record.amount}0',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 50),
                                  MyButtonSmall(
                                    text: AppLocalizations.of(context)!.view,
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, 'record_view',
                                          arguments: id);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyButton(
                    text: AppLocalizations.of(context)!.add,
                    onTap: () {
                      Navigator.pushNamed(context, 'record_add_income');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
