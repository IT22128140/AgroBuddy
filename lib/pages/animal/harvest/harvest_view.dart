import 'package:agro_buddy/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/components/my_button.dart';
import 'package:agro_buddy/components/my_delete_button.dart';
import 'package:intl/intl.dart';

class HarvestView extends StatelessWidget {
  final Map<String, dynamic> data;
  final String harvestid;
  final String id;

  HarvestView(
      {super.key,
      required this.data,
      required this.harvestid,
      required this.id});

  final DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xff28631f),
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Container(
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.date_s,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('yyyy-MM-dd')
                                .format((data['date'] as Timestamp).toDate()),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Quantity
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.quantity_s,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            data['quantity']?.toString() ?? 'N/A',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.notes_s,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data['note'] ?? 'N/A',
                        style: const TextStyle(color: Colors.black),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Delete
                  MyDeleteButton(
                    text: AppLocalizations.of(context)!.delete,
                    onTap: () async {
                      bool? confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor:
                                Colors.white, // Change the background color
                            title: Text(
                                AppLocalizations.of(context)!.confirm_delete),
                            content: Text(AppLocalizations.of(context)!
                                .delete_confirmation),
                            actions: <Widget>[
                              Row(
                                children: [
                                  MyDeleteButton(
                                    text: AppLocalizations.of(context)!.delete,
                                    onTap: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  MyButton(
                                    text: AppLocalizations.of(context)!.cancel,
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
                        await databaseService.deleteHarvest(id, harvestid);
                        await Navigator.pushNamed(context, 'harvest_list',
                            arguments: id);
                      }
                    },
                  ),
                  //Edit
                  MyButton(
                    text: AppLocalizations.of(context)!.edit,
                    onTap: () {
                      Navigator.pushNamed(context, 'harvest_edit', arguments: {
                        'data': data,
                        'harvestid': harvestid,
                        'id': id
                      });
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
