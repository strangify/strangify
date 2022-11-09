import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:strangify/helpers/methods.dart';
import 'package:strangify/services/user_services.dart';
import 'package:strangify/widgets/st_text.dart';
import 'package:strangify/widgets/st_tf.dart';

import '../constants.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String actualOtp = "";
  String? verificationID;
  bool isLoading = false;
  GlobalKey<FormState> loginFormKey = GlobalKey();
  String initialCountryCode = "+91";
  @override
  void initState() {
    super.initState();
  }

  Future verifyPhone() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91${phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          showSnack(
              context: context,
              message: "PLease enter a valid phone number",
              color: Colors.red);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          verificationID = verificationId;
        });
        // UserService().signInWithPhoneNumber(phoneController.text,
        //     otpController.text, verificationId, context, userProvider!);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    MediaQueryData mq = MediaQuery.of(context);

    return Scaffold(
      //  backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true,
      body: Container(
        height: mq.size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomRight,
                //end: Alignment.bottomRight,
                colors: [
              const Color.fromARGB(255, 148, 166, 247).withOpacity(.8),
              Colors.white
            ])),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  padding: const EdgeInsets.only(bottom: 30, top: 30),
                  child: Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            children: [
                              Hero(
                                  tag: "logo",
                                  child: Image.asset("assets/login_phone.jpg",
                                      width: double.infinity, height: 340)),
                              // const SizedBox(height: 5),
                              const StText(
                                "LOGIN/SIGN UP",
                                color: Colors.black,
                                size: 24,
                                weight: FontWeight.w300,
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              // ListView(
              //   shrinkWrap: true,
              //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              //   children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Form(
                  key: loginFormKey,
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.only(top: 12),
                      //   child: StText(
                      //       verificationID == null
                      //           ? "Please provide your Phone Number to receive OTP for verification."
                      //           : "Enter the OTP sent to your Phone Number.",
                      //       weight: FontWeight.w300,
                      //       size: 16),
                      // ),
                      const SizedBox(height: 20),
                      // StTF(
                      //   controller: emailController,
                      //   hintText: "Email *",
                      //   type: TextInputType.emailAddress,
                      // ),
                      IntlPhoneField(
                        showDropdownIcon: false,
                        decoration: InputDecoration(
                            hintText: "  Phone Number",
                            hintStyle: TextStyle(
                              letterSpacing: 1.2,
                              height: .4,
                              fontSize: 16,
                            )),
                        onCountryChanged: (value) {
                          initialCountryCode = "+${value.dialCode}";
                          setState(() {});
                        },
                        initialCountryCode: "IN",
                        controller: phoneController,
                        enabled: verificationID == null ? true : false,
                      ),
                      SizedBox(height: verificationID == null ? 0 : 10),
                      verificationID == null
                          ? SizedBox()
                          : TextField(
                              onChanged: (value) {
                                if (value.length == 6) {
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              controller: otpController,
                              maxLength: 6,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    CupertinoIcons.lock,
                                    size: 24,
                                  ),
                                  hintText: "OTP",
                                  hintStyle: TextStyle(
                                    letterSpacing: 1.1,
                                    height: .4,
                                    fontSize: 15,
                                  )),
                            ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                          // isLoading: isLoading,
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16)),
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor)),
                          icon: Icon(verificationID == null
                              ? CupertinoIcons.paperplane
                              : CupertinoIcons.checkmark_alt),
                          label: StText(
                              verificationID == null ? "Send OTP" : "Submit",
                              color: Colors.white),
                          onPressed: () async {
                            if (loginFormKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                if (verificationID == null) {
                                  await verifyPhone();
                                } else {
                                  print(verificationID);
                                  print(otpController.text);
                                  print(initialCountryCode);
                                  print(phoneController.text);
                                  await UserService().signInWithPhoneNumber(
                                      initialCountryCode +
                                          phoneController.text.trim(),
                                      otpController.text.trim(),
                                      verificationID!,
                                      context,
                                      userProvider);
                                }
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          }),
                    ],
                  ),
                ),
              )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
