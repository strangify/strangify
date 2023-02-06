import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List> fetchSessions() async {
    List sessions = [];
    QuerySnapshot docs = await _db.collection("session").get();
    for (var element in docs.docs) {
      sessions.add(element.data());
    }
    return sessions;
  }

  Future updateSession(Map<String, dynamic> data) async {
    _db.collection("session").doc(data["id"]).update(data);
  }
}
