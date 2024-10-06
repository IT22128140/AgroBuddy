import 'package:cloud_firestore/cloud_firestore.dart';

class Stock {
  final String? uid; // Make it nullable since it will be assigned by Firebase
  final String? stockID; // Make it nullable since it will be assigned by Firebase
  final String stockName;
  final DateTime purchasedDate;
  final DateTime expDate;
  final String quantity;
  final String purchasedPrice;
  final String supplier;
  final String additionalNotes;
  final String stockType;

  Stock({
    this.uid,
    this.stockID, // Allow null values for stockID initially
    required this.stockName,
    required this.purchasedDate,
    required this.expDate,
    required this.quantity,
    required this.purchasedPrice,
    required this.supplier,
    required this.additionalNotes,
    required this.stockType,
  });

  // Convert a Stock object into a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'stockName': stockName,
      'purchasedDate': Timestamp.fromDate(purchasedDate),
      'expDate': Timestamp.fromDate(expDate),
      'quantity': quantity,
      'purchasedPrice': purchasedPrice,
      'supplier': supplier,
      'additionalNotes': additionalNotes,
      'stockType': stockType,
    };
  }

  // Create a Stock object from a Firestore document snapshot and document ID
  factory Stock.fromMap(Map<String, dynamic> map, String docID) {
    return Stock(
      uid: map['uid'] ?? '',
      stockID: docID, // Assign the Firestore document ID here
      additionalNotes: map['additionalNotes'] ?? '',
      expDate: (map['expDate'] as Timestamp).toDate(),
      purchasedDate: (map['purchasedDate'] as Timestamp).toDate(),
      purchasedPrice: map['purchasedPrice'] ?? '',
      quantity: map['quantity'] ?? '',
      stockName: map['stockName'] ?? '',
      stockType: map['stockType'] ?? '',
      supplier: map['supplier'] ?? '',
    );
  }
}

