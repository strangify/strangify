// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:strangify/widgets/st_text.dart';
// import 'package:strangify/widgets/st_tf.dart';

// import '../constants.dart';
// import '../providers/user_provider.dart';

// class SignupScreen extends StatefulWidget {
//   static const routeName = "/SignupScreen";
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _auth = FirebaseAuth.instance;
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   String selectedGender = "Male";
//   bool isLoading = false;
//   GlobalKey<FormState> signupFormKey = GlobalKey();

//   Widget customUserModeContainer(String title, IconData icon, bool isSelected) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       margin: const EdgeInsets.symmetric(vertical: 2),
//       child: Container(
//           height: 40,
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width / 5,
//           padding: const EdgeInsets.all(5),
//           decoration: BoxDecoration(
//               color: isSelected ? primaryColor : Colors.white38,
//               borderRadius: BorderRadius.circular(8)),
//           child: Text(title,
//               style: TextStyle(
//                   color: isSelected ? Colors.white : greyColor,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600))),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserProvider userProvider = Provider.of<UserProvider>(context);
//     MediaQueryData mq = MediaQuery.of(context);

//     return Scaffold(
//       backgroundColor: primaryColor,
//       resizeToAvoidBottomInset: true,
//       body: Container(
//         height: mq.size.height,
//         width: mq.size.width,
//         decoration: const BoxDecoration(
//             // image: DecorationImage(
//             //     image: AssetImage("assets/login-bg.png"), fit: BoxFit.contain),
//             gradient: LinearGradient(begin: Alignment.bottomRight,
//                 //end: Alignment.bottomRight,
//                 colors: [
//               gradient1,
//               gradient2,
//             ])),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Positioned(
//                 left: 75,
//                 top: 110,
//                 bottom: 20,
//                 right: 20,
//                 child: Image.asset(
//                   "assets/signup-bg.png",
//                   height: mq.size.height - 10,
//                   width: mq.size.width - 105,
//                   fit: BoxFit.contain,
//                 )),
//             Positioned(
//                 left: -30,
//                 top: -30,
//                 child: Image.asset("assets/signup-1.png", height: 140)),
//             Positioned(
//                 left: 15,
//                 top: 122,
//                 child: Image.asset("assets/signup-2.png", height: 110)),
//             Center(
//               child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 50),
//                   child: Form(
//                     key: signupFormKey,
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           Hero(
//                               tag: "logo",
//                               child:
//                                   Image.asset("assets/Logo1.png", height: 70)),
//                           const SizedBox(height: 30),
//                           const StText("SIGN UP",
//                               color: Colors.white,
//                               size: 24,
//                               weight: FontWeight.w600),
//                           const SizedBox(height: 40),
//                           const Align(
//                             alignment: Alignment.centerLeft,
//                             child:
//                                 StText("Name", color: Colors.white, size: 15),
//                           ),
//                           const SizedBox(height: 5),
//                           StTF(controller: nameController, hintText: "Name"),
//                           const SizedBox(height: 10),
//                           const Align(
//                             alignment: Alignment.centerLeft,
//                             child: StText("Age", color: Colors.white, size: 15),
//                           ),
//                           const SizedBox(height: 5),
//                           StTF(
//                               controller: ageController,
//                               hintText: "Age",
//                               formatters: [
//                                 FilteringTextInputFormatter.digitsOnly
//                               ]),
//                           const SizedBox(height: 10),
//                           const Align(
//                             alignment: Alignment.centerLeft,
//                             child:
//                                 StText("Email", color: Colors.white, size: 15),
//                           ),
//                           const SizedBox(height: 5),
//                           StTF(controller: emailController, hintText: "Email"),
//                           const SizedBox(height: 10),
//                           const Align(
//                             alignment: Alignment.centerLeft,
//                             child:
//                                 StText("Gender", color: Colors.white, size: 15),
//                           ),
//                           const SizedBox(height: 5),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedGender = "Male";
//                                   });
//                                 },
//                                 child: customUserModeContainer(
//                                     'Male',
//                                     Icons.male_outlined,
//                                     selectedGender == "Male"),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedGender = "Female";
//                                   });
//                                 },
//                                 child: customUserModeContainer(
//                                     'Female',
//                                     Icons.female_outlined,
//                                     selectedGender == "Female"),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedGender = "Other";
//                                   });
//                                 },
//                                 child: customUserModeContainer(
//                                     'Other',
//                                     Icons.not_interested_outlined,
//                                     selectedGender == "Other"),
//                               )
//                             ],
//                           ),
//                           const SizedBox(height: 30),
//                           ElevatedButton(
//                               // isLoading: isLoading,
//                               style: ButtonStyle(
//                                   shape: MaterialStateProperty.all(
//                                       RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(20))),
//                                   padding: MaterialStateProperty.all(
//                                       const EdgeInsets.symmetric(
//                                           vertical: 10, horizontal: 16)),
//                                   backgroundColor:
//                                       MaterialStateProperty.all(Colors.white)),
//                               child: const Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 4, vertical: 2),
//                                 child: StText("Submit",
//                                     size: 14,
//                                     weight: FontWeight.w600,
//                                     color: primaryColor),
//                               ),
//                               onPressed: () async {
//                                 if (signupFormKey.currentState!.validate()) {
//                                   setState(() {
//                                     isLoading = true;
//                                   });
//                                   try {
//                                     // if (verificationID == null) {
//                                     //   await verifyPhone();
//                                     // } else {
//                                     //   await UserService().signInWithPhoneNumber(
//                                     //       initialCountryCode +
//                                     //           phoneController.text.trim(),
//                                     //       otpController.text.trim(),
//                                     //       verificationID!,
//                                     //       context,
//                                     //       userProvider);
//                                     // }
//                                   } catch (e) {
//                                     setState(() {
//                                       isLoading = false;
//                                     });
//                                   }
//                                 }
//                               }),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
