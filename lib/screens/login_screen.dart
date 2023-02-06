import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:strangify/helpers/methods.dart';
import 'package:strangify/services/user_services.dart';
import 'package:strangify/widgets/st_text.dart';

import '../constants.dart';
import '../providers/settings_provider.dart';
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
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    MediaQueryData mq = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true,
      body: Container(
        height: mq.size.height,
        width: mq.size.width,
        decoration: const BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage("assets/login-bg.png"), fit: BoxFit.contain),
            gradient: LinearGradient(begin: Alignment.bottomRight,
                //end: Alignment.bottomRight,
                colors: [
              gradient1,
              gradient2,
            ])),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                left: 75,
                top: 110,
                bottom: 20,
                right: 20,
                child: Image.asset(
                  "assets/login-bg.png",
                  height: mq.size.height - 10,
                  width: mq.size.width - 105,
                  fit: BoxFit.contain,
                )),
            Positioned(
                left: -30,
                top: -30,
                child: Image.asset("assets/login-1.png", height: 180)),
            Positioned(
                left: 40,
                top: 172,
                child: Image.asset("assets/login-2.png", height: 40)),
            Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                            tag: "logo",
                            child: Image.asset("assets/Logo1.png", height: 70)),
                        const SizedBox(height: 30),
                        const StText("LOGIN",
                            color: Colors.white,
                            size: 24,
                            weight: FontWeight.w600),
                        const SizedBox(height: 40),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: StText("Phone Number",
                              color: Colors.white, size: 15),
                        ),
                        const SizedBox(height: 5),
                        IntlPhoneField(
                          showDropdownIcon: false,
                          cursorColor: primaryColor,
                          decoration: const InputDecoration(
                              filled: true,
                              counterStyle: TextStyle(color: Colors.white),
                              errorStyle: TextStyle(
                                  height: 1,
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 242, 217, 217)),
                              border: InputBorder.none,
                              fillColor: Colors.white),
                          flagsButtonPadding: const EdgeInsets.only(left: 10),
                          onCountryChanged: (value) {
                            initialCountryCode = "+${value.dialCode}";
                            setState(() {});
                          },
                          initialCountryCode: "IN",
                          controller: phoneController,
                          enabled: verificationID == null ? true : false,
                        ),
                        SizedBox(height: verificationID == null ? 0 : 20),
                        verificationID == null
                            ? const SizedBox()
                            : const Align(
                                alignment: Alignment.centerLeft,
                                child: StText("OTP",
                                    color: Colors.white, size: 15),
                              ),
                        SizedBox(height: verificationID == null ? 0 : 5),
                        verificationID == null
                            ? const SizedBox()
                            : TextField(
                                onChanged: (value) {
                                  if (value.length == 6) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                controller: otpController,
                                maxLength: 6,
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      CupertinoIcons.lock,
                                      size: 24,
                                    ),
                                    filled: true,
                                    errorStyle: TextStyle(
                                        height: 1,
                                        fontSize: 12,
                                        color:
                                            Color.fromARGB(255, 242, 217, 217)),
                                    border: InputBorder.none,
                                    fillColor: Colors.white),
                              ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                            // isLoading: isLoading,
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              child: StText(
                                  verificationID == null
                                      ? "Send OTP"
                                      : "Submit",
                                  size: 14,
                                  weight: FontWeight.w600,
                                  color: primaryColor),
                            ),
                            onPressed: () async {
                              if (loginFormKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  if (verificationID == null) {
                                    await verifyPhone();
                                  } else {
                                    await UserService().signInWithPhoneNumber(
                                        initialCountryCode +
                                            phoneController.text.trim(),
                                        otpController.text.trim(),
                                        verificationID!,
                                        context,
                                        userProvider,
                                        settingsProvider);
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
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
