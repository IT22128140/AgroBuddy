import 'package:agro_buddy/components/my_button_small.dart';
import 'package:agro_buddy/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/components/my_button.dart';
import 'package:intl/intl.dart';

class HarvestList extends StatefulWidget {
  final dynamic id;
  const HarvestList({super.key, this.id});

  @override
  State<HarvestList> createState() => _HarvestListState();
}

class _HarvestListState extends State<HarvestList> {
  final DatabaseService databaseService = DatabaseService();

  // Future<List<Map<String, dynamic>>> getHarvestData() async {
  //   final snapshot = await databaseService.getHarvestData(widget.id);
  //   return snapshot.docs.map((doc) => doc.data()).toList().cast<Map<String, dynamic>>();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xff28631f),
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: databaseService.getHarvests(widget.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                                AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 250, 230, 35)),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(AppLocalizations.of(context)!.error,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 250, 230, 35),
                            fontSize: 30));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text(AppLocalizations.of(context)!.no_data,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 250, 230, 35),
                            fontSize: 30));
                  } else {
                    final harvestlist = snapshot.data!;
                    return ListView.builder(
                      itemCount: harvestlist.docs.length,
                      itemBuilder: (context, index) {
                        final data = harvestlist.docs[index].data()
                            as Map<String, dynamic>;
                        final harvestid = harvestlist.docs[index].id;
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.date_s,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Text(
                                        DateFormat('yyyy-MM-dd').format(
                                            (data['date'] as Timestamp)
                                                .toDate()),
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  MyButtonSmall(
                                    text: AppLocalizations.of(context)!.view,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        'harvest_view',
                                        arguments: {
                                          'data': data,
                                          'harvestid': harvestid,
                                          'id': widget.id,
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                              // Quantity
                              Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.quantity_s,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  Text(
                                    data['quantity'].toString(),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              // Notes
                              Text(
                                AppLocalizations.of(context)!.notes_s,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              Text(
                                data['note'] ?? 'N/A',
                                style: const TextStyle(color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
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
              padding: const EdgeInsets.all(20.0),
              child:
                  // Add button
                  MyButton(
                text: AppLocalizations.of(context)!.add,
                onTap: () {
                  Navigator.pushNamed(context, 'harvest_add',
                      arguments: widget.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
