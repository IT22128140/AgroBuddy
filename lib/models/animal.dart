import 'package:cloud_firestore/cloud_firestore.dart';

class Animal {
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'type': type,
      'birthday': birthday,
      'animalimage': animalimage,
    };
  }

  final String uid;
  final String name;
  final String type;
  final DateTime birthday;
  final String animalimage;

  Animal(
      {required this.uid,
      required this.name,
      required this.type,
      required this.birthday,
      required this.animalimage});

  factory Animal.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Animal(
      type: data['type'] ?? 'Unknown',
      name: data['name'] ?? 'Unknown',
      uid: data['uid'] ?? 0,
      birthday: (data['birthday'] != null)
          ? (data['birthday'] as Timestamp).toDate()
          : DateTime.now(),
      animalimage: data['animalimage'] ?? 'Unknown',
    );
  }
}

class Harvest {
    Map<String, dynamic> toMap() {
    return {
      'date': date,
      'quantity': quantity,
      'note': note,
    };
  }
  
  final DateTime date;
  final double quantity;
  final String note;

  Harvest({required this.date, required this.quantity, required this.note});

  factory Harvest.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Harvest(
      date: (data['date'] as Timestamp).toDate(),
      quantity: data['quantity'] ?? 0.0,
      note: data['note'] ?? 'Unknown',
    );
  }

}
