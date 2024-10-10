// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:agro_buddy/components/button_group.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/models/record.dart';
import 'package:agro_buddy/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class RecordAddExpense extends StatefulWidget {
  const RecordAddExpense({super.key});

  @override
  State<RecordAddExpense> createState() => _RecordAddExpenseState();
}

class _RecordAddExpenseState extends State<RecordAddExpense> {
  final DatabaseService databaseService = DatabaseService();
  final User user = FirebaseAuth.instance.currentUser!;

  TextEditingController accountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
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
      backgroundColor: const Color.fromARGB(255, 44, 99, 31),
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
                      ButtonGroup(isIncomeSelected: false),
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
                              items: [
                                DropdownMenuItem(
                                  value: 'cash',
                                  child: Text(
                                      AppLocalizations.of(context)!.acc_t_cash),
                                ),
                                DropdownMenuItem(
                                  value: 'bank',
                                  child: Text(
                                      AppLocalizations.of(context)!.acc_t_bank),
                                ),
                                DropdownMenuItem(
                                  value: 'loan',
                                  child: Text(
                                      AppLocalizations.of(context)!.acc_t_loan),
                                ),
                              ],
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
                              items: [
                                DropdownMenuItem(
                                  value: 'seeds',
                                  child: Text(
                                      AppLocalizations.of(context)!.cate_seeds),
                                ),
                                DropdownMenuItem(
                                  value: 'fertilizer',
                                  child: Text(AppLocalizations.of(context)!
                                      .cate_fertilizer),
                                ),
                                DropdownMenuItem(
                                  value: 'pesticide',
                                  child: Text(AppLocalizations.of(context)!
                                      .cate_pesticide),
                                ),
                                DropdownMenuItem(
                                  value: 'animalfeed',
                                  child: Text(AppLocalizations.of(context)!
                                      .cate_animalfeed),
                                ),
                                DropdownMenuItem(
                                  value: 'vetdrugs',
                                  child: Text(AppLocalizations.of(context)!
                                      .cate_vetdrugs),
                                ),
                                DropdownMenuItem(
                                  value: 'labor',
                                  child: Text(
                                      AppLocalizations.of(context)!.cate_labor),
                                ),
                                DropdownMenuItem(
                                  value: 'machine',
                                  child: Text(AppLocalizations.of(context)!
                                      .cate_machine),
                                ),
                                DropdownMenuItem(
                                  value: 'rent',
                                  child: Text(
                                      AppLocalizations.of(context)!.cate_rent),
                                ),
                              ],
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
                                // Convert the pickedTime to 24-hour format
                                final now = DateTime.now();
                                final dt = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    pickedTime.hour,
                                    pickedTime.minute);
                                final formattedTime = DateFormat.Hm()
                                    .format(dt); // 24-hour format

                                setState(() {
                                  timeController.text = formattedTime;
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
                                    type: 'Expense',
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
