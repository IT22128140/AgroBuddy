import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro_buddy/models/record.dart';

class DatabaseService {
  //create a record collection reference
  final CollectionReference recordCollection =
      FirebaseFirestore.instance.collection('records');

  // add a record
  Future<void> addRecord(Records record) {
    return recordCollection.add(record.toMap());
  }

  // get all records stream
  Stream<QuerySnapshot> getRecordsStream() {
    return recordCollection.snapshots();
  }

  // update a record
  Future<void> updateRecord(String id, Records record) {
    return recordCollection.doc(id).update(record.toMap());
  }

  // delete a record
  Future<void> deleteRecord(String id) {
    return recordCollection.doc(id).delete();
  }

  // get a record by id
  Future<Records> getRecordById(String id) async {
    final DocumentSnapshot snapshot = await recordCollection.doc(id).get();
    return Records.fromSnapshot(snapshot);
  }

  // Modify this method to take in time range and selected time
  Stream<QuerySnapshot<Object?>> getFilteredRecordsStream({
    required String? timeRange,
    required String? selectedTime,
    required String? uid,
  }) {
    Query query = recordCollection;

    if (uid != null && uid.isNotEmpty) {
      query = query.where('uid', isEqualTo: uid);
      print('Filtering by uid: $uid');
    }

    if (timeRange == 'year' && selectedTime != null) {
      query = query
          .where('dateTime',
              isGreaterThanOrEqualTo: DateTime(int.parse(selectedTime)))
          .where('dateTime', isLessThan: DateTime(int.parse(selectedTime) + 1));
      print('Filtering by year: $selectedTime');
    } else if (timeRange == 'sixm' && selectedTime != null) {
      if (selectedTime == 'Jan-Jun') {
        query = query
            .where('dateTime',
                isGreaterThanOrEqualTo: DateTime(DateTime.now().year, 1))
            .where('dateTime', isLessThan: DateTime(DateTime.now().year, 7));
        print('Filtering by first six months of the year');
      } else if (selectedTime == 'Jul-Dec') {
        query = query
            .where('dateTime',
                isGreaterThanOrEqualTo: DateTime(DateTime.now().year, 7))
            .where('dateTime',
                isLessThan: DateTime(DateTime.now().year + 1, 1));
        print('Filtering by last six months of the year');
      }
    } else if (timeRange == 'month' && selectedTime != null) {
      int selectedMonth = int.parse(selectedTime);
      query = query
          .where('dateTime',
              isGreaterThanOrEqualTo:
                  DateTime(DateTime.now().year, selectedMonth))
          .where('dateTime',
              isLessThan: DateTime(DateTime.now().year, selectedMonth + 1));
      print('Filtering by month: $selectedMonth');
    }

    return query.snapshots();
  }
}
