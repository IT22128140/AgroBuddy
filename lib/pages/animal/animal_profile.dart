import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:agro_buddy/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/components/my_button.dart';
import 'package:agro_buddy/components/my_delete_button.dart';
import 'package:agro_buddy/models/animal.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';

class AnimalProfile extends StatefulWidget {
  final Animal animal;
  final dynamic id;
  const AnimalProfile({super.key, required this.animal, required this.id});

  @override
  State<AnimalProfile> createState() => _AnimalProfileState();
}

class _AnimalProfileState extends State<AnimalProfile> {
  final DatabaseService databaseService = DatabaseService();

  ScreenshotController screenshotController = ScreenshotController();

  // screenShot() {
  //   return Screenshot(
  //     controller: screenshotController,
  //     child: PrettyQrView(
  //       qrImage: QrImage(
  //         QrCode.fromData(
  //             data: widget.id.toString(),
  //             errorCorrectLevel: QrErrorCorrectLevel.Q),
  //       ),
  //       decoration: const PrettyQrDecoration(
  //         shape: PrettyQrSmoothSymbol(),
  //       ),
  //     ),
  //   );
  // }

  Future<void> downloadQrCode() async {
    if (await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted) {
      final path = '/storage/emulated/0/Download/${widget.id}.jpg';
      Uint8List? image = await screenshotController.captureFromWidget(
        RepaintBoundary(
          child: Container(
            color: Colors.white, // Set the background color to white
            padding: const EdgeInsets.all(
                20), // Optional: Add padding around the QR code
            child: PrettyQrView(
              qrImage: QrImage(
                QrCode.fromData(
                    data: widget.id.toString(),
                    errorCorrectLevel: QrErrorCorrectLevel.Q),
              ),
              decoration: const PrettyQrDecoration(
                shape: PrettyQrSmoothSymbol(),
              ),
            ),
          ),
        ),
      );
      File(path).writeAsBytes(image).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR Code saved to $path')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getHarvestData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await databaseService.getHarvestData(widget.id);
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  getAnimalbyLocalisation(type) {
    if (type == "cattle") {
      return AppLocalizations.of(context)!.cattle;
    } else if (type == "chicken") {
      return AppLocalizations.of(context)!.chicken;
    } else if (type == "pigs") {
      return AppLocalizations.of(context)!.pigs;
    } else if (type == "goat") {
      return AppLocalizations.of(context)!.goat;
    } else if (type == "buffalo") {
      return AppLocalizations.of(context)!.buffalo;
    } else if (type == "ducks") {
      return AppLocalizations.of(context)!.ducks;
    } else if (type == 'bees') {
      return AppLocalizations.of(context)!.bees;
    } else {
      return AppLocalizations.of(context)!.other;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff28631f),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //edit
                MyButton(
                  text: AppLocalizations.of(context)!.edit,
                  onTap: () {
                    Navigator.pushNamed(context, 'animal_edit',
                        arguments: {'id': widget.id, 'animal': widget.animal});
                  },
                ),
                //delete
                MyDeleteButton(
                  text: AppLocalizations.of(context)!.delete,
                  onTap: () async {
                    bool? confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
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
                      // Delete the image from Firebase Storage
                      FirebaseStorage storage = FirebaseStorage.instance;
                      Reference imageRef =
                          storage.refFromURL(widget.animal.animalimage);
                      await imageRef.delete();
                      // Delete the animal from Firestore
                      await databaseService.deleteAnimal(widget.id);
                      if (mounted) {
                        Navigator.pushNamed(context, 'animal_list');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                widget.animal.animalimage,
                width: 300,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              height: 150,
              width: 400,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getAnimalbyLocalisation(widget.animal.type),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      //ID
                      Row(children: [
                        const Text(
                          "ID: ",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        Text(widget.id,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14)),
                      ])
                    ],
                  ),
                  //Name
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.name_s,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Text(
                        widget.animal.name,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  ),
                  //Age
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.age_s,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                          Text(
                            " ${AppLocalizations.of(context)!.years}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                          //age calculation
                          Text(
                            " ${DateTime.now().year - widget.animal.birthday.year}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),

                          Text(
                            " ${AppLocalizations.of(context)!.and}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                          Text(
                            " ${AppLocalizations.of(context)!.months}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                          Text(
                            " ${DateTime(1).month + DateTime.now().month - widget.animal.birthday.month - 1}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              height: 130,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.harvest_m,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  Center(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: getHarvestData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 250, 230, 35)),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            AppLocalizations.of(context)!.error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 20),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text(
                            AppLocalizations.of(context)!.no_data,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          );
                        } else {
                          DateTime now = DateTime.now();
                          double totalQuantity = snapshot.data!
                              .where((data) {
                                DateTime date =
                                    (data['date'] as Timestamp).toDate();
                                return date.year == now.year &&
                                    date.month == now.month;
                              })
                              .map((data) => data['quantity'] as double)
                              .reduce((a, b) => a + b);
                          return Text(
                            totalQuantity.toString(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 40),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //QR scan
                MyButton(
                    text: AppLocalizations.of(context)!.harvest,
                    onTap: () {
                      Navigator.pushNamed(context, 'harvest_list',
                          arguments: widget.id);
                    }),
                //add
                MyButton(
                    text: AppLocalizations.of(context)!.qr_download,
                    onTap: () {
                      downloadQrCode();
                    }),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
