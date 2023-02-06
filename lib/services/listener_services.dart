import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:strangify/models/user_model.dart' as u;

class ListenerService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<u.User>> fetchListeners() async {
    List<u.User> listeners = [];
    QuerySnapshot docs = await _db
        .collection("users")
        .where("role", isEqualTo: "listener")
        .get();
    for (var element in docs.docs) {
      listeners.add(u.User.fromSnap(element.data() as Map<String, dynamic>));
    }
    return listeners;
  }

  Future<List<u.User>> fetchCounsellors() async {
    List<u.User> counsellors = [];
    QuerySnapshot docs = await _db
        .collection("users")
        .where("role", isEqualTo: "counsellor")
        .get();
    for (var element in docs.docs) {
      counsellors.add(u.User.fromSnap(element.data() as Map<String, dynamic>));
    }
    return counsellors;
  }
}
