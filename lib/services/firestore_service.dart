import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mon_app/models/tournament.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Créer un nouveau tournoi
  Future<void> createTournament(String userId, Tournament tournament) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('tournaments')
        .doc(tournament.id)
        .set(tournament.toJson());
  }

  // Mettre à jour un tournoi
  Future<void> updateTournament(String userId, Tournament tournament) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('tournaments')
        .doc(tournament.id)
        .set(tournament.toJson(), SetOptions(merge: true));
  }

  // Récupérer tous les tournois d'un utilisateur
  Stream<List<Tournament>> getTournaments(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('tournaments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Tournament.fromJson(doc.data()))
                  .toList(),
        );
  }

  // Récupérer un tournoi spécifique
  Future<Tournament?> getTournament(String userId, String tournamentId) async {
    final doc =
        await _db
            .collection('users')
            .doc(userId)
            .collection('tournaments')
            .doc(tournamentId)
            .get();

    if (doc.exists) {
      return Tournament.fromJson(doc.data()!);
    }
    return null;
  }

  // Supprimer un tournoi
  Future<void> deleteTournament(String userId, String tournamentId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('tournaments')
        .doc(tournamentId)
        .delete();
  }
}
