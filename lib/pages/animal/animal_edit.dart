import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/services/database.dart';
import 'package:agro_buddy/models/animal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class AnimalEdit extends StatefulWidget {
  final Animal animal;
  final String id;

  const AnimalEdit({super.key, required this.animal, required this.id});

  @override
  State<AnimalEdit> createState() => _AnimalAddState();
}

class _AnimalAddState extends State<AnimalEdit> {
  //database service
  final DatabaseService databaseService = DatabaseService();

  //text field controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birtdayController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.animal.name;
    birtdayController.text =
        DateFormat('yyyy-MM-dd').format(widget.animal.birthday).toString();
    typeController.text = widget.animal.type;
    imageController.text = widget.animal.animalimage;
    _selectedAnimalType =
        widget.animal.type; // Initialize the selected animal type
  }

  XFile? image;
  bool _isUploading = false;
  bool _isImageSelected = false;
  String? _selectedAnimalType; // Variable to hold the selected animal type

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
                        child: DropdownButtonFormField<String>(
                          value: _selectedAnimalType, // Set the initial value
                          validator: (String? value) {
                            if (value == null) {
                              return AppLocalizations.of(context)!.err_type;
                            }
                            return null;
                          },
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.animals,
                            border: const UnderlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: const TextStyle(
                                color: Color.fromARGB(255, 250, 230, 35)),
                          ),
                          items: <String>[
                            AppLocalizations.of(context)!.cow,
                            AppLocalizations.of(context)!.goat,
                            AppLocalizations.of(context)!.chiken,
                            AppLocalizations.of(context)!.pigs,
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newvalue) {
                            setState(() {
                              typeController.text = newvalue!;
                              _selectedAnimalType = newvalue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.name,
                            border: const UnderlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: const TextStyle(
                                color: Color.fromARGB(255, 250, 230, 35)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.err_name;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: birtdayController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.birthday,
                            border: const UnderlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: const TextStyle(
                                color: Color.fromARGB(255, 250, 230, 35)),
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
                                      primary: const Color(
                                          0xff28631f), // header background color
                                      onPrimary:
                                          Colors.white, // header text color
                                      onSurface:
                                          Colors.black, // body text color
                                    ),
                                    dialogBackgroundColor:
                                        Colors.white, // background color
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              setState(() {
                                birtdayController.text =
                                    "${pickedDate.toLocal()}".split(' ')[0];
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.err_birthday;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      //image picker
                      ElevatedButton(
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          image = await imagePicker.pickImage(
                            source: ImageSource.camera,
                            preferredCameraDevice: CameraDevice.rear,
                          );
                          if (image != null) {
                            setState(() {
                              _isImageSelected = true;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 250, 230, 35),
                          padding: const EdgeInsets.only(
                              left: 130, right: 130, top: 10, bottom: 10),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 40,
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
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isUploading = true;
                            });
                            if (_isImageSelected) {
                              String uniqueName = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();

                              Reference refImages =
                                  FirebaseStorage.instance.ref();
                              Reference refImagesDir =
                                  refImages.child('animal_images');

                              Reference referenceImageToUpload =
                                  refImagesDir.child(uniqueName);

                              try {
                                await referenceImageToUpload
                                    .putFile(File(image!.path));
                                await referenceImageToUpload
                                    .getDownloadURL()
                                    .then((onValue) {
                                  imageController.text = onValue;
                                });
                              } catch (e) {
                                print(e);
                              }
                            }
                            await databaseService.updateAnimal(
                                widget.id,
                                Animal(
                                    uid: '1234',
                                    name: nameController.text,
                                    type: typeController.text,
                                    birthday:
                                        DateTime.parse(birtdayController.text),
                                    animalimage: imageController.text));

                            setState(() {
                              _isUploading = false;
                            });

                            await Navigator.pushNamed(context, 'animal_profile',
                                arguments: {
                                  'animal': Animal(
                                      uid: '1234',
                                      name: nameController.text,
                                      type: typeController.text,
                                      birthday: DateTime.parse(
                                          birtdayController.text),
                                      animalimage: imageController.text),
                                  'id': widget.id
                                });
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
                            AppLocalizations.of(context)!.edit,
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
    );
  }
}
