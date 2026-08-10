import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch a stream of categories.
  /// If [limit] is provided, it will restrict the number of documents returned.
  Stream<QuerySnapshot> getCategoriesStream({int? limit}) {
    Query query = _firestore.collection('categories');
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots();
  }

  /// Fetch a stream of tips.
  /// If [limit] is provided, it will restrict the number of documents returned.
  Stream<QuerySnapshot> getTipsStream({int? limit}) {
    Query query = _firestore.collection('tips');
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots();
  }
}
