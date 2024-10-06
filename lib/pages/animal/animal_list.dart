import 'package:agro_buddy/models/animal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/components/my_button.dart';
import 'package:agro_buddy/services/database.dart';
import 'package:agro_buddy/components/my_button_small.dart';
import "package:firebase_auth/firebase_auth.dart";

class AnimalList extends StatefulWidget {
  const AnimalList({super.key});

  @override
  State<AnimalList> createState() => _AnimalListState();
}

class _AnimalListState extends State<AnimalList> {
  final DatabaseService databaseService = DatabaseService();
  final User user = FirebaseAuth.instance.currentUser!;

  Future<void> scanQRcodeNormal() async {
    try {
      String qrcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', AppLocalizations.of(context)!.cancel, true, ScanMode.QR);
      Animal animal =
          await databaseService.getAnimalData(qrcodeScanRes, user.uid);

      Navigator.pushNamed(context, 'animal_profile',
          arguments: {'animal': animal, 'id': qrcodeScanRes});
    } catch (e) {
      debugPrint(e.toString());
    }
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
      body: Container(
        color: const Color(0xff28631f),
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: databaseService.getanimalsStream(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 250, 230, 35)),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text(AppLocalizations.of(context)!.no_data,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 250, 230, 35),
                            fontSize: 30));
                  } else if (snapshot.hasError) {
                    return Text(AppLocalizations.of(context)!.error,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 250, 230, 35),
                            fontSize: 30));
                  } else {
                    final animals = snapshot.data!;
                    return ListView.builder(
                      itemCount: animals.docs.length,
                      itemBuilder: (context, index) {
                        final animal = Animal.fromSnapshot(animals.docs[index]);
                        var id = animals.docs[index].id;
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: 150,
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
                                    Text(
                                      getAnimalbyLocalisation(animal.type),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "ID: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          id.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.name_s,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                    Text(
                                      animal.name,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.age_s,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          " ${AppLocalizations.of(context)!.years}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        //age calculation
                                        Text(
                                          " ${DateTime.now().year - animal.birthday.year}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),

                                        Text(
                                          " ${AppLocalizations.of(context)!.and}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          " ${AppLocalizations.of(context)!.months}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          " ${DateTime(1).month + DateTime.now().month - animal.birthday.month - 1}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    MyButtonSmall(
                                      text: AppLocalizations.of(context)!.view,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, 'animal_profile',
                                            arguments: {
                                              'animal': animal,
                                              'id': id
                                            });
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    text: AppLocalizations.of(context)!.scan,
                    onTap: scanQRcodeNormal,
                  ),
                  MyButton(
                      text: AppLocalizations.of(context)!.add,
                      onTap: () {
                        Navigator.pushNamed(context, 'animal_add');
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
