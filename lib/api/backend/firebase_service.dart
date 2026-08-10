import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Register with email and password
  Future<UserCredential> register(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

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

  /// Fetch a stream of sliders (promotional ads).
  Stream<QuerySnapshot> getSlidersStream() {
    return _firestore
        .collection('sliders')
        .where('status', isEqualTo: 'Active')
        // Ordering by createdAt requires an index in Firestore, 
        // so we'll just fetch Active ones. You can sort client-side if needed.
        .snapshots();
  }

  /// Fetch a stream of articles for a specific category.
  Stream<QuerySnapshot> getArticlesByCategoryId(String categoryId) {
    return _firestore
        .collection('articles')
        .where('categoryId', isEqualTo: categoryId)
        .snapshots();
  }

  /// Get stream of comments for an article
  Stream<QuerySnapshot> getCommentsForArticle(String articleId) {
    return _firestore
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Add a comment to an article
  Future<void> addComment(String articleId, String text, String userName) async {
    await _firestore
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .add({
      'text': text,
      'userName': userName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Toggle like (Since there's no auth, we'll just increment or decrement based on local state)
  Future<void> toggleLike(String articleId, bool isCurrentlyLiked) async {
    final docRef = _firestore.collection('articles').doc(articleId);
    
    // Use transaction to ensure safe increment/decrement
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;
      
      int currentLikes = 0;
      if (snapshot.data()!.containsKey('likes')) {
        currentLikes = snapshot.data()!['likes'] as int;
      }

      int newLikes = isCurrentlyLiked ? (currentLikes - 1) : (currentLikes + 1);
      if (newLikes < 0) newLikes = 0; // Prevent negative likes

      transaction.update(docRef, {'likes': newLikes});
    });
  }
}
