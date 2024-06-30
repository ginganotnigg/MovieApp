import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/model/movie.dart';

class WatchlistRepository {
  final firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  Future<List<Movie>> getWatchlist() async {
    if (userId == null) return [];
    final reference = firestore.collection('users').doc(userId);
    final snapshot = await reference.get();
    final data = snapshot.data()!['watchlist'] as List;
    final watchlist = data.map((m) => Movie.fromJson(m)).toList();
    return watchlist;
  }

  Future<void> removeFromWL(Movie movie) async {
    final watchlist = await getWatchlist();
    if (watchlist.isEmpty || userId == null) return;
    final reference = firestore.collection('users').doc(userId);
    final snapshot = await reference.get();
    if (!snapshot.exists) return;
    final data = snapshot.data()!['watchlist'] as List;
    if (data.any((m) => m['id'] == movie.id) == false) return;
    await reference.update({
      'watchlist': FieldValue.arrayRemove([movie.toFirestore()])
    });
  }

  Future<void> addToWL(Movie movie) async {
    if (userId == null) return;
    final reference = firestore.collection('users').doc(userId);
    final snapshot = await reference.get();
    if (!snapshot.exists) return;
    final data = snapshot.data()!['watchlist'] as List;
    if (data.any((m) => m['id'] == movie.id)) return;
    await reference.update({
      'watchlist': FieldValue.arrayUnion([movie.toFirestore()])
    });
  }
}
