import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Collection reference
  final CollectionReference _historyCollection =
      FirebaseFirestore.instance.collection('analysis_history');

  /// CREATE: Save a new recommendation analysis
  Future<void> saveAnalysis({
    required String skinType,
    required String budget,
    required List<String> products,
  }) async {
    try {
      await _historyCollection.add({
        'skinType': skinType,
        'budget': budget,
        'products': products,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving recommendation: $e");
      rethrow;
    }
  }

  /// READ: Stream all saved analyses sorted by latest first
  Stream<QuerySnapshot> getAnalysisHistory() {
    return _historyCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// DELETE: Remove a saved analysis using its document ID
  Future<void> deleteAnalysis(String docId) async {
    try {
      await _historyCollection.doc(docId).delete();
    } catch (e) {
      print("Error deleting analysis: $e");
      rethrow;
    }
  }
}