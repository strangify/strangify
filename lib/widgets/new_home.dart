import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class NewHome extends StatefulWidget {
  const NewHome({super.key});

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentReference? chatRef;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PaginateFirestore(
        //item builder type is compulsory.
        itemBuilder: (context, documentSnapshots, index) {
          final data = documentSnapshots[index].data() as Map?;
          if (data != null && data['id'] != user!.uid) {
            return ListTile(
              onTap: () {
                chatRef =
                    FirebaseFirestore.instance.collection('messages').doc();
                chatRef!.set({
                  "speakerId": user!.uid,
                  "listenerId": documentSnapshots[index].id,
                  "time": DateTime.now(),
                  "messageList": [],
                  "status": "waiting"
                }).then((value) => null);
              },
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(data['name']),
              subtitle: Text(documentSnapshots[index].id),
            );
          }
          return const SizedBox();
        },
        // orderBy is compulsory to enable pagination
        query: FirebaseFirestore.instance.collection('users').orderBy('name'),
        //Change types accordingly
        itemsPerPage: 20,

        itemBuilderType: PaginateBuilderType.listView,
        // to fetch real-time data
        isLive: true,
      ),
    );
  }
}
