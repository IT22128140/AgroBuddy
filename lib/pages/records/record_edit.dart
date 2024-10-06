// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/models/record.dart';
import 'package:agro_buddy/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecordEdit extends StatefulWidget {
  final Records record;
  final String id;
  const RecordEdit({super.key, required this.record, required this.id});

  @override
  State<RecordEdit> createState() => _RecordEditState();
}

class _RecordEditState extends State<RecordEdit> {
  final DatabaseService databaseService = DatabaseService();
  final User user = FirebaseAuth.instance.currentUser!;

  TextEditingController typeController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  List<String> _categories = [];
  List<String> _incomeCategories = [];
  List<String> _expenseCategories = [];

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

  @override
  void initState() {
    super.initState();
    typeController.text = widget.record.type;
    accountController.text = widget.record.accountType;
    categoryController.text = widget.record.category;
    amountController.text = widget.record.amount.toString();
    dateController.text =
        DateFormat('yyyy-MM-dd').format(widget.record.dateTime);
    timeController.text = DateFormat('HH:mm').format(widget.record.dateTime);
    notesController.text = widget.record.note;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _incomeCategories = [
      AppLocalizations.of(context)!.cate_capital,
      AppLocalizations.of(context)!.cate_harvest,
      AppLocalizations.of(context)!.cate_eggs,
      AppLocalizations.of(context)!.cate_milk,
      AppLocalizations.of(context)!.cate_meat,
      AppLocalizations.of(context)!.cate_honey,
    ];

    _expenseCategories = [
      AppLocalizations.of(context)!.cate_seeds,
      AppLocalizations.of(context)!.cate_fertilizer,
      AppLocalizations.of(context)!.cate_pesticide,
      AppLocalizations.of(context)!.cate_animalfeed,
      AppLocalizations.of(context)!.cate_vetdrugs,
      AppLocalizations.of(context)!.cate_labor,
      AppLocalizations.of(context)!.cate_machine,
      AppLocalizations.of(context)!.cate_rent,
    ];

    _updateCategories(typeController.text);
  }

  void _updateCategories(String type) {
    setState(() {
      if (type == 'Income') {
        _categories = _incomeCategories;
      } else if (type == 'Expense') {
        _categories = _expenseCategories;
      } else {
        _categories = [];
      }
    });
  }

  bool _isUploading = false;

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
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 350,
                          child: DropdownButtonFormField<String>(
                              value: typeController.text.isNotEmpty
                                  ? typeController.text
                                  : null,
                              validator: (String? value) {
                                if (value == null) {
                                  return AppLocalizations.of(context)!
                                      .sel_type_err;
                                }
                                return null;
                              },
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.sel_type,
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              items: [
                                DropdownMenuItem<String>(
                                    value: 'Income',
                                    child: Text(
                                        AppLocalizations.of(context)!.income)),
                                DropdownMenuItem<String>(
                                    value: 'Expense',
                                    child: Text(
                                        AppLocalizations.of(context)!.expense)),
                              ],
                              onChanged: (String? newvalue) {
                                typeController.text = newvalue!;
                                _updateCategories(newvalue);
                              }),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          child: DropdownButtonFormField<String>(
                              value: accountController.text,
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
                                accountController.text = newvalue!;
                              }),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          child: DropdownButtonFormField<String>(
                              value:
                                  _categories.contains(categoryController.text)
                                      ? categoryController.text
                                      : null,
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
                              ),
                              items: _categories.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newvalue) {
                                categoryController.text = newvalue ?? '';
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
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                              controller: dateController,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.sel_date,
                                suffixIcon: Icon(Icons.calendar_today),
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                  builder:
                                      (BuildContext context, Widget? child) {
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
                              }),
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
                                await databaseService.updateRecord(
                                  widget.id,
                                  Records(
                                    uid: user.uid,
                                    type: typeController.text,
                                    accountType: accountController.text,
                                    category: categoryController.text,
                                    amount: double.parse(amountController.text),
                                    dateTime: toUTC,
                                    note: notesController.text,
                                  ),
                                );
                              } catch (e) {
                                debugPrint('Error updating record: $e');
                              } finally {
                                setState(() {
                                  _isUploading = false;
                                });
                              }
                              // if (mounted) {
                              await Navigator.pushNamed(context, 'record_view',
                                  arguments: widget.id);
                              // }
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
