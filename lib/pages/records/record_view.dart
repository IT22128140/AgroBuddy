// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/components/my_button.dart';
import 'package:agro_buddy/components/my_delete_button.dart';
import 'package:agro_buddy/models/record.dart';
import 'package:agro_buddy/services/database_service.dart';
import 'package:intl/intl.dart';

class RecordView extends StatelessWidget {
  // final Records record;
  final dynamic id;
  RecordView({super.key, required this.id});

  final DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Records>(
      future: databaseService.getRecordById(id),
      builder: (BuildContext context, AsyncSnapshot<Records> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 44, 99, 31),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 44, 99, 31),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 44, 99, 31),
            body: Center(
              child: Text('Record not found'),
            ),
          );
        } else {
          Records record = snapshot.data!;
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 44, 99, 31),
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 30),
                      width: 400,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.date_rv}: ',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(record.dateTime),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.time_rv}: ',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('HH:mm')
                                          .format(record.dateTime),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.type_rv}: ',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      record.type == 'Income'
                                          ? AppLocalizations.of(context)!.income
                                          : AppLocalizations.of(context)!
                                              .expense,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.account_rv}: ',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      record.accountType,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.category_rv}: ',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      record.category,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.amount_rv}: ',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.rs}${record.amount}0',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.note_rv}: ',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      record.note,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Edit
                        MyButton(
                          text: AppLocalizations.of(context)!.edit,
                          onTap: () {
                            Navigator.pushNamed(context, 'record_edit',
                                arguments: {'record': record, 'id': id});
                          },
                        ),
                        //Delete
                        MyDeleteButton(
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
                              await databaseService.deleteRecord(id);
                              await Navigator.pushNamed(context, 'record_list',
                                  arguments: id);
                            }
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
      },
    );
  }
}
