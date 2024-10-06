import 'package:agro_buddy/models/animal.dart';
import 'package:agro_buddy/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HarvestAdd extends StatefulWidget {
  final dynamic id;
  const HarvestAdd({super.key, required this.id});

  @override
  _HarvestAddState createState() => _HarvestAddState();
}

class _HarvestAddState extends State<HarvestAdd> {
  final DatabaseService databaseService = DatabaseService();

  TextEditingController dateController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool _isUploading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff28631f),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 120),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.date,
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
                              lastDate: DateTime.now(),
                              builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: const Color(0xff28631f), // header background color
                                  onPrimary: Colors.white, // header text color
                                  onSurface: Colors.black, // body text color
                                ),
                                dialogBackgroundColor: Colors.white, // background color
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
                              return AppLocalizations.of(context)!.err_date;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.quantity,
                            border: const UnderlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.err_quantity;
                            }
                            if (double.tryParse(value) == null) {
                              return AppLocalizations.of(context)!.err_quantity;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: descriptionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.notes,
                            border: const UnderlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      )
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
                              await databaseService.addHarvest(
                                widget.id,
                                Harvest(
                                  date: DateTime.parse(dateController.text),
                                  quantity:
                                      double.parse(quantityController.text),
                                  note: descriptionController.text,
                                ),
                              );
                            } catch (e) {
                              print('Error adding harvest: $e');
                            } finally {
                              setState(() {
                                _isUploading = false;
                              });
                            }
                            await Navigator.pushNamed(context, 'harvest_list',
                                arguments: widget.id);
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
                            AppLocalizations.of(context)!.add,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(15),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Add the data to the database

              //       Navigator.pushNamed(context, 'animal_list');
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color.fromRGBO(250, 230, 35, 1),
              //       padding:
              //           const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //     ),
              //     child: Text(
              //       AppLocalizations.of(context)!.add,
              //       style: const TextStyle(
              //           color: Colors.black,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
