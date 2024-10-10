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
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseService databaseService = DatabaseService();
  List<DropdownMenuItem<String>> _categories = [];

  final TextEditingController typeController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

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
    _updateCategories(widget.record.type);
  }

  List<DropdownMenuItem<String>> _updateCategories(String type) {
    List<DropdownMenuItem<String>> incomeCategories = [
      DropdownMenuItem<String>(
        value: 'capital',
        child: Text(AppLocalizations.of(context)!.cate_capital),
      ),
      DropdownMenuItem<String>(
        value: 'harvest',
        child: Text(AppLocalizations.of(context)!.cate_harvest),
      ),
      DropdownMenuItem<String>(
        value: 'eggs',
        child: Text(AppLocalizations.of(context)!.cate_eggs),
      ),
      DropdownMenuItem(
        value: 'milk',
        child: Text(AppLocalizations.of(context)!.cate_milk),
      ),
      DropdownMenuItem(
        value: 'meat',
        child: Text(AppLocalizations.of(context)!.cate_meat),
      ),
      DropdownMenuItem(
        value: 'honey',
        child: Text(AppLocalizations.of(context)!.cate_honey),
      )
    ];

    List<DropdownMenuItem<String>> expenseCategories = [
      DropdownMenuItem<String>(
        value: 'seeds',
        child: Text(AppLocalizations.of(context)!.cate_seeds),
      ),
      DropdownMenuItem<String>(
        value: 'fertilizer',
        child: Text(AppLocalizations.of(context)!.cate_fertilizer),
      ),
      DropdownMenuItem<String>(
        value: 'pesticide',
        child: Text(AppLocalizations.of(context)!.cate_pesticide),
      ),
      DropdownMenuItem(
        value: 'animalfeed',
        child: Text(AppLocalizations.of(context)!.cate_animalfeed),
      ),
      DropdownMenuItem(
        value: 'vetdrugs',
        child: Text(AppLocalizations.of(context)!.cate_vetdrugs),
      ),
      DropdownMenuItem(
        value: 'labor',
        child: Text(AppLocalizations.of(context)!.cate_labor),
      ),
      DropdownMenuItem(
        value: 'machine',
        child: Text(AppLocalizations.of(context)!.cate_machine),
      ),
      DropdownMenuItem(
        value: 'rent',
        child: Text(AppLocalizations.of(context)!.cate_rent),
      )
    ];

    setState(() {
      if (type == 'Income') {
        _categories = incomeCategories;
      } else if (type == 'Expense') {
        _categories = expenseCategories;
      }
    });

    return _categories;
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
                              labelText: AppLocalizations.of(context)!.sel_type,
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
                            onChanged: (String? newvalue) async {
                              setState(() {
                                typeController.text = newvalue!;
                                _updateCategories(newvalue);
                              });
                            },
                          ),
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
                                accountController.text = newvalue!;
                              }),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          child: DropdownButtonFormField<String>(
                            value: (_categories.any((item) =>
                                    item.value == categoryController.text))
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
                            items: _categories,
                            onChanged: (String? newvalue) {
                              setState(() {
                                categoryController.text = newvalue ?? '';
                              });
                            },
                          ),
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
                                labelText:
                                    AppLocalizations.of(context)!.sel_time,
                                suffixIcon: Icon(Icons.access_time),
                                border: const UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              readOnly: true,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(
                                    hour: int.parse(
                                        timeController.text.split(":")[0]),
                                    minute: int.parse(
                                        timeController.text.split(":")[1]),
                                  ),
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: const Color(0xff28631f),
                                            onPrimary: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                          dialogBackgroundColor: Colors.white,
                                        ),
                                        child: child!,
                                      ),
                                    );
                                  },
                                );
                                if (pickedTime != null) {
                                  final now = DateTime.now();
                                  final dt = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      pickedTime.hour,
                                      pickedTime.minute);
                                  final formattedTime =
                                      DateFormat.Hm().format(dt);

                                  setState(() {
                                    timeController.text = formattedTime;
                                  });
                                }
                              }),
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
