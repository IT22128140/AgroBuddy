// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:agro_buddy/components/button_group.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/models/record.dart';
import 'package:agro_buddy/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecordAddIncome extends StatefulWidget {
  const RecordAddIncome({super.key});

  @override
  State<RecordAddIncome> createState() => _RecordAddIncomeState();
}

class _RecordAddIncomeState extends State<RecordAddIncome> {
  final DatabaseService databaseService = DatabaseService();
  final User user = FirebaseAuth.instance.currentUser!;

  final TextEditingController accountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool _isUploading = false;

  DateTime get toUTC => DateTime(
      dateController.text.isNotEmpty
          ? DateTime.parse(dateController.text).year
          : DateTime.now().year,
      dateController.text.isNotEmpty
          ? DateTime.parse(dateController.text).month
          : DateTime.now().month,
      dateController.text.isNotEmpty
          ? DateTime.parse(dateController.text).day
          : DateTime.now().day,
      timeController.text.isNotEmpty
          ? TimeOfDay(
                  hour: int.parse(timeController.text.split(":")[0]),
                  minute: int.parse(timeController.text.split(":")[1]))
              .hour
          : TimeOfDay.now().hour,
      timeController.text.isNotEmpty
          ? TimeOfDay(
                  hour: int.parse(timeController.text.split(":")[0]),
                  minute: int.parse(timeController.text.split(":")[1]))
              .minute
          : TimeOfDay.now().minute);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(44, 99, 31, 1),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      ButtonGroup(isIncomeSelected: true),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          child: DropdownButtonFormField(
                              validator: (String? value) {
                                if (value == null) {
                                  return AppLocalizations.of(context)!
                                      .acc_t_err;
                                }
                                return null;
                              },
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.acc_t,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                errorStyle: const TextStyle(
                                  color: Color.fromARGB(255, 250, 230, 35),
                                ),
                              ),
                              items: <String>[
                                AppLocalizations.of(context)!.acc_t_cash,
                                AppLocalizations.of(context)!.acc_t_bank,
                                AppLocalizations.of(context)!.acc_t_loan,
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newvalue) {
                                setState(() {
                                  accountController.text = newvalue!;
                                });
                              }),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          child: DropdownButtonFormField(
                              validator: (String? value) {
                                if (value == null) {
                                  return AppLocalizations.of(context)!.cate_err;
                                }
                                return null;
                              },
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.cate,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                errorStyle: const TextStyle(
                                  color: Color.fromARGB(255, 250, 230, 35),
                                ),
                              ),
                              items: <String>[
                                AppLocalizations.of(context)!.cate_capital,
                                AppLocalizations.of(context)!.cate_harvest,
                                AppLocalizations.of(context)!.cate_eggs,
                                AppLocalizations.of(context)!.cate_milk,
                                AppLocalizations.of(context)!.cate_meat,
                                AppLocalizations.of(context)!.cate_honey,
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newvalue) {
                                setState(() {
                                  categoryController.text = newvalue!;
                                });
                              }),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.amount,
                              border: const UnderlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              errorStyle: const TextStyle(
                                color: Color.fromARGB(255, 250, 230, 35),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.amount_err;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            controller: dateController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.sel_date,
                              suffixIcon: Icon(Icons.calendar_today),
                              border: const UnderlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              errorStyle: const TextStyle(
                                color: Color.fromARGB(255, 250, 230, 35),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: const Color(0xff28631f),
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      dialogBackgroundColor: Colors.white,
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  dateController.text =
                                      "${pickedDate.toLocal()}".split(' ')[0];
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .sel_date_err;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            controller: timeController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.sel_time,
                              suffixIcon: Icon(Icons.access_time),
                              border: const UnderlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              errorStyle: const TextStyle(
                                color: Color.fromARGB(255, 250, 230, 35),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: const Color(0xff28631f),
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      dialogBackgroundColor: Colors.white,
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  timeController.text =
                                      pickedTime.format(context);
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            controller: notesController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.add_notes,
                              border: const UnderlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: _isUploading
                        ? null
                        : () async {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              setState(() {
                                _isUploading = true;
                              });
                              try {
                                // Add the data to the database
                                await databaseService.addRecord(
                                  Records(
                                    uid: user.uid,
                                    type: 'Income',
                                    accountType: accountController.text,
                                    category: categoryController.text,
                                    amount: double.parse(amountController.text),
                                    dateTime: toUTC,
                                    note: notesController.text,
                                  ),
                                );
                              } catch (e) {
                                print('Error adding harvest: $e');
                              } finally {
                                setState(() {
                                  _isUploading = false;
                                });
                              }
                              await Navigator.pushNamed(context, 'record_list');
                            }
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 230, 35),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: _isUploading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            )
                          : Text(
                              AppLocalizations.of(context)!.save,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
