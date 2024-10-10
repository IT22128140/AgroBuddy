// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro_buddy/models/stock_model.dart'; // Ensure the correct import

class StockServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new stock document to Firestore
  Future<void> addStock(Stock stock) async {
    try {
      await _db.collection('Stock').add(stock.toMap());
      print("Stock added successfully");
    } catch (e) {
      print("Error adding stock: $e");
    }
  }

  // Get all stock documents from Firestore, including document ID as stockID
  Future<List<Stock>> getStocks(String? uid) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('Stock')
          .where('uid', isEqualTo: uid)
          .get();
      return querySnapshot.docs.map((doc) {
        return Stock.fromMap(doc.data() as Map<String, dynamic>, doc.id); // Pass document ID
      }).toList();
    } catch (e) {
      print("Error getting stocks: $e");
      return [];
    }
  }

  // Get a stock document by document ID (stockID)
  Future<Stock?> getStockById(String stockID) async {
    try {
      DocumentSnapshot docSnapshot =
          await _db.collection('Stock').doc(stockID).get(); // Use doc(stockID)
      if (docSnapshot.exists) {
        print("Document exists: ${docSnapshot.data()}");
        return Stock.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id); // Pass document ID
      } else {
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error getting stock by ID: $e");
      return null;
    }
  }

  // Update a stock document by document ID (stockID)
  Future<void> updateStock(String stockID, Stock stock) async {
    try {
      await _db.collection('Stock').doc(stockID).update(stock.toMap()); // Use doc(stockID)
      print("Stock updated successfully");
    } catch (e) {
      print("Error updating stock: $e");
    }
  }

  // Delete a stock document by document ID (stockID)
  Future<void> deleteStock(String stockID) async {
    try {
      await _db.collection('Stock').doc(stockID).delete(); // Use doc(stockID)
      print("Stock deleted successfully");
    } catch (e) {
      print("Error deleting stock: $e");
    }
  }

 DateTime startOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day, 0, 0, 0);
}

DateTime endOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23, 59, 59);
}

Future<List<Stock>> getStocksExpiringThisWeek(String uid) async {
  try {
    final now = DateTime.now();
    final startOfToday = startOfDay(now); // Start of today
    final endOfSevenDays = endOfDay(now.add(Duration(days: 6))); // 7 days from today

    QuerySnapshot querySnapshot = await _db
        .collection('Stock')
        .where('uid', isEqualTo: uid)
        .where('expDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday))
        .where('expDate', isLessThanOrEqualTo: Timestamp.fromDate(endOfSevenDays))
        .get();

    return querySnapshot.docs.map((doc) {
      return Stock.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  } catch (e) {
    print("Error getting stocks expiring in 7 days: $e");
    return [];
  }
}


// Get stocks with expiration dates next month
Future<List<Stock>> getStocksExpiringNextMonth(String uid) async {
  try {
    final now = DateTime.now();
    // If it's December, handle year increment
    final firstDayNextMonth = startOfDay(DateTime(
      now.year + (now.month == 12 ? 1 : 0), 
      now.month == 12 ? 1 : now.month + 1, 
      1
    ));

    final lastDayNextMonth = endOfDay(DateTime(
      now.year + (now.month == 12 ? 1 : 0), 
      now.month == 12 ? 1 : now.month + 2, 
      0 // The last day of the next month
    ));

    QuerySnapshot querySnapshot = await _db
        .collection('Stock')
        .where('uid', isEqualTo: uid) // Fixed this to be 'uid' instead of passing the value of `uid` directly as a field
        .where('expDate', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayNextMonth))
        .where('expDate', isLessThanOrEqualTo: Timestamp.fromDate(lastDayNextMonth))
        .get();

    return querySnapshot.docs.map((doc) {
      return Stock.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  } catch (e) {
    print("Error getting stocks expiring next month: $e");
    return [];
  }
}


}
