import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strangify/helpers/methods.dart';

import '../widgets/st_text.dart';

class UnderReviewScreen extends StatefulWidget {
  static const routeName = "/UnderReviewScreen";
  const UnderReviewScreen({super.key});

  @override
  State<UnderReviewScreen> createState() => _UnderReviewScreenState();
}

class _UnderReviewScreenState extends State<UnderReviewScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const StText(
                "Profile is sent to the Admin, He will verify your profile and then approve it.",
                align: TextAlign.center,
                size: 18,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : StText("Refresh Status"),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  DocumentSnapshot snap = await FirebaseFirestore.instance
                      .collection("drivers")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get();
                  if ((snap.data() as Map)["isActive"]) {
                    setState(() {
                      isLoading = false;
                      showSnack(
                          context: context,
                          message: "Your profile is now Approved.");
                      Navigator.of(context).pop();
                    });
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
