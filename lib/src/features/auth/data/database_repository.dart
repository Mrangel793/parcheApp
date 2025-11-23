import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/auth/domain/app_user.dart';

class DatabaseRepository {
  final FirebaseFirestore _firestore;

  DatabaseRepository(this._firestore);

  Future<void> createUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Stream<AppUser?> userStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return AppUser.fromDocument(snapshot);
      }
      return null;
    });
  }
}

final databaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
  return DatabaseRepository(FirebaseFirestore.instance);
});

final userProvider = StreamProvider.autoDispose.family<AppUser?, String>((ref, uid) {
  final databaseRepository = ref.watch(databaseRepositoryProvider);
  return databaseRepository.userStream(uid);
});
