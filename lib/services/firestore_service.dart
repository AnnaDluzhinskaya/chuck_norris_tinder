import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  late final CollectionReference<Map<String, dynamic>> _collection;

  FirestoreService() {
    _collection = db.collection("favorite_jokes");
  }

  Future saveInfo({required Future<User> user}) async {
    User temp = await user;
    await _collection.doc().set(temp.toJson());
  }

  Stream<List<User>> getJokes() {
    return _collection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
  }
}
