import 'package:cloud_firestore/cloud_firestore.dart';

class Records {
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'type': type,
      'accountType': accountType,
      'category': category,
      'amount': amount,
      'dateTime': dateTime,
      'note': note,
    };
  }

  final String uid;
  final String type;
  final String accountType;
  final String category;
  final double amount;
  final DateTime dateTime;
  final String note;

  Records({
    required this.uid,
    required this.type,
    required this.accountType,
    required this.category,
    required this.amount,
    required this.dateTime,
    required this.note,
  });

  factory Records.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Records(
      uid: data['uid'],
      type: data['type'] ?? 'Unknown',
      accountType: data['accountType'] ?? 'Unknown',
      category: data['category'] ?? 'Unknown',
      amount: data['amount'] ?? 'Unknown',
      dateTime: (data['dateTime'] != null)
          ? (data['dateTime'] as Timestamp).toDate()
          : DateTime.now(),
      note: data['note'],
    );
  }
}
