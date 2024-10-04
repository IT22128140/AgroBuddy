import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro_buddy/models/animal.dart';

class DatabaseService {
  //create a animal profile
  final CollectionReference animalCollection =
      FirebaseFirestore.instance.collection('animals');

  //ADD animal profile
  Future<void> addAnimal(Animal animal) {
    return animalCollection.add(animal.toMap());
  }

  //get all animal profiles stream
  Stream<QuerySnapshot> getanimalsStream() {
    return animalCollection.snapshots();
  }

  //get animal profile data
  Future<Animal> getAnimalData(String id) async {
    DocumentSnapshot snapshot = await animalCollection.doc(id).get();
    return Animal.fromSnapshot(snapshot);
  }

  //update animal profile
  Future<void> updateAnimal(String id, Animal animal) {
    return animalCollection.doc(id).update(animal.toMap());
  }

  //delete animal profile
  Future<void> deleteAnimal(String id) {
    return animalCollection.doc(id).delete();
  }

  //add harvest to animal profile
  Future<void> addHarvest(String id, Harvest harvest) {
    return animalCollection.doc(id).collection('harvest').add(harvest.toMap());
  }

  //get all harvests from animal profile
  Stream<QuerySnapshot> getHarvests(String id) {
    return FirebaseFirestore.instance
        .collection('animals')
        .doc(id)
        .collection('harvest')
        .snapshots();
  }

  //get harvest data
  Future<QuerySnapshot<Map<String, dynamic>>> getHarvestData(String id) {
    return animalCollection.doc(id).collection('harvest').get();
  }

  //update harvest data
  Future<void> updateHarvest(String id, String harvestid, Harvest harvest) {
    return animalCollection
        .doc(id)
        .collection('harvest')
        .doc(harvestid)
        .update(harvest.toMap());
  }

  //delete harvest data
  Future<void> deleteHarvest(String id, String harvestid) {
    return animalCollection
        .doc(id)
        .collection('harvest')
        .doc(harvestid)
        .delete();
  }
}
