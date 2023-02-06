import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:strangify/models/settings_model.dart';

class SettingService {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<SettingsModel?> getSettings() async {
    DocumentSnapshot docSnap =
        await _db.collection("settings").doc("YVObavOjsUSjbqus8SpK").get();
    return SettingsModel.fromSnap(docSnap.data() as Map<String, dynamic>);
  }
}
