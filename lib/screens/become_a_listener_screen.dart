import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:strangify/providers/user_provider.dart';
import 'package:strangify/screens/under_review_screen.dart';
import 'package:strangify/services/user_services.dart';

import 'package:strangify/widgets/dropdown_container.dart';
import 'package:strangify/widgets/st_text.dart';

import '../constants.dart';
import '../helpers/methods.dart';

class BecomeAListenerScreen extends StatefulWidget {
  final bool isListener;
  static const routeName = "/becomeAListenerScreen";
  const BecomeAListenerScreen({super.key, required this.isListener});

  @override
  State<BecomeAListenerScreen> createState() => _BecomeAListenerScreenState();
}

class _BecomeAListenerScreenState extends State<BecomeAListenerScreen> {
  List selectedTags = [];
  List selectedLanguages = [];
  bool isLoading = false;
  final List<String> languageList = [
    'English',
    'Hindi',
    "Assamese",
    "Bangla",
    "Gujrati",
    'Marwadi',
    "Kashmiri",
    "Kannada",
    "Malayalam",
    "Marathi",
    "Oriya",
    "Punjabi",
    "Tamil",
    "Telugu",
    "Sindhi",
    "Urdu"
  ];

  XFile? image;
  bool isCallSelected = true;
  bool isChatSelected = true;

  TextEditingController tagsController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController reaccountController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String selectedGender = "Male";
  String selectedAccountType = "Savings";
//TODO important
  // @override
  // void initState() {
  //   worksheet!.values.rowByKey("auth id").then((value) => print(value));
  //   super.initState();
  // }

  Widget customUserModeContainer(String title, IconData icon, bool isSelected,
      [double? width]) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
          height: 36,
          alignment: Alignment.center,
          width: width ?? MediaQuery.of(context).size.width / 4.2,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: isSelected ? gradient1 : Colors.white38,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : null),
              Text("$title ",
                  style: TextStyle(
                      color: isSelected ? Colors.white : greyColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              Transform.scale(
                  scale: 1.1,
                  child:
                      Image.asset("assets/become.png", width: double.infinity)),
              Positioned(
                top: 34,
                left: 26,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 22, color: Colors.white),
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StText(
                  "${widget.isListener ? "Listener" : "Counsellor"} Settings",
                  size: 20,
                  weight: FontWeight.w500),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                setState(() {});
              },
              child: Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(bottom: 0, top: 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: gradient1,
                      borderRadius: BorderRadius.circular(60),
                      image: image == null
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(image!.path)))),
                  child: image != null
                      ? null
                      : const StText("+", color: Colors.white, size: 40)),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 28),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: nameController,
                    cursorColor: primaryColor,
                    cursorWidth: 1.5,
                    cursorHeight: 16,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                        height: 1,
                        fontSize: 14),
                    decoration: getTfDecortion("First Name"),
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: ageController,
                    cursorColor: primaryColor,
                    cursorWidth: 1.5,
                    cursorHeight: 16,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                        height: 1,
                        fontSize: 14),
                    decoration: getTfDecortion("Age"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
            child: TextFormField(
              controller: emailController,
              cursorColor: primaryColor,
              cursorWidth: 1.5,
              cursorHeight: 16,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  height: 1,
                  fontSize: 14),
              decoration: getTfDecortion("Email Address"),
            ),
          ),
          // Padding(
          //     padding: const EdgeInsets.only(left: 20, right: 20),
          //     child: const Align(
          //       alignment: Alignment.centerLeft,
          //       child: StText("Gender", color: gradient1, size: 15),
          //     )),
          // const SizedBox(height: 5),
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedGender = "Male";
                      });
                    },
                    child: customUserModeContainer(
                        'Male', Icons.male_outlined, selectedGender == "Male"),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedGender = "Female";
                      });
                    },
                    child: customUserModeContainer('Female',
                        Icons.female_outlined, selectedGender == "Female"),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedGender = "Other";
                      });
                    },
                    child: customUserModeContainer(
                        'Other',
                        Icons.not_interested_outlined,
                        selectedGender == "Other"),
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
            child: TextFormField(
              controller: accountNameController,
              cursorColor: primaryColor,
              cursorWidth: 1.5,
              cursorHeight: 16,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  height: 1,
                  fontSize: 14),
              decoration: getTfDecortion("Account Holder Name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
            child: TextFormField(
              controller: bankNameController,
              cursorColor: primaryColor,
              cursorWidth: 1.5,
              cursorHeight: 16,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  height: 1,
                  fontSize: 14),
              decoration: getTfDecortion("Bank Name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
            child: TextFormField(
              controller: accountController,
              cursorColor: primaryColor,
              cursorWidth: 1.5,
              cursorHeight: 16,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
                height: 1,
                fontSize: 16,
              ),
              decoration: getTfDecortion("Account No"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
            child: TextFormField(
              controller: reaccountController,
              cursorColor: primaryColor,
              cursorWidth: 1.5,
              cursorHeight: 16,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  height: 1,
                  fontSize: 14),
              decoration: getTfDecortion("Re-enter Account No"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
            child: TextFormField(
              controller: ifscController,
              cursorColor: primaryColor,
              cursorWidth: 1.5,
              cursorHeight: 16,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
                height: 1,
                fontSize: 16,
              ),
              decoration: getTfDecortion("IFSC Code"),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedAccountType = "Savings";
                      });
                    },
                    child: customUserModeContainer(
                        'Savings',
                        Icons.account_balance_outlined,
                        selectedAccountType == "Savings",
                        MediaQuery.of(context).size.width / 3),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedAccountType = "Current";
                      });
                    },
                    child: customUserModeContainer(
                        'Current',
                        Icons.account_balance_outlined,
                        selectedAccountType == "Current",
                        MediaQuery.of(context).size.width / 3),
                  ),
                ],
              )),
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 4),
            //padding: const EdgeInsets.all(8.0),
            child: StText("Connecting Options",
                color: gradient1, weight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                SizedBox(
                    width: 140,
                    child: CheckboxListTile(
                      dense: true,
                      activeColor: gradient1,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: const StText("Call", size: 16),
                      value: isCallSelected,
                      onChanged: (value) {
                        setState(() {
                          isCallSelected = !isCallSelected;
                        });
                      },
                    )),
                SizedBox(
                    width: 140,
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: gradient1,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const StText("Chat", size: 16),
                      value: isChatSelected,
                      onChanged: (value) {
                        setState(() {
                          isChatSelected = !isChatSelected;
                        });
                      },
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                dropdownMaxHeight: 220,
                customButton: DropdownContainer(
                    title: widget.isListener ? "Interests" : "Specialization"),
                items: interestList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item["name"],
                    enabled: false,
                    child: StatefulBuilder(
                      builder: (context, menuSetState) {
                        final isSelected = selectedTags.contains(item["name"]);
                        return InkWell(
                          onTap: () {
                            isSelected
                                ? selectedTags.remove(item["name"])
                                : selectedTags.add(item["name"]);
                            setState(() {});
                            menuSetState(() {});
                          },
                          child: Container(
                            height: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                isSelected
                                    ? const Icon(Icons.check_box_outlined)
                                    : const Icon(Icons.check_box_outline_blank),
                                const SizedBox(width: 16),
                                StText(item["name"], size: 14),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
                searchController: tagsController,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 4, right: 8, left: 8),
                  child: TextFormField(
                    controller: tagsController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      hintText:
                          'Search for an${widget.isListener ? "interest" : "specialization"}...',
                      hintStyle: TextStyle(
                          color: gradient1, fontSize: 12, letterSpacing: 1.3),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return (item.value.toString().contains(searchValue));
                },
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    tagsController.clear();
                  }
                },
                onChanged: (value) {},
                buttonHeight: 40,
                buttonWidth: 240,
                itemHeight: 40,
                itemPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SizedBox(height: selectedTags.isEmpty ? 0 : 14),
          SizedBox(
            height: selectedTags.isEmpty ? 0 : 30,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: selectedTags.length,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Chip(
                        backgroundColor: primaryLight.withOpacity(.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        label: StText(selectedTags[i],
                            size: 14,
                            weight: FontWeight.w500,
                            color: gradient1),
                        onDeleted: () {
                          setState(() {
                            selectedTags.remove(selectedTags[i]);
                          });
                        }),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                  isExpanded: true,
                  dropdownMaxHeight: 220,
                  customButton: const DropdownContainer(title: "Languages"),
                  items: languageList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      enabled: false,
                      child: StatefulBuilder(
                        builder: (context, menuSetState) {
                          final isSelected = selectedLanguages.contains(item);
                          return InkWell(
                            onTap: () {
                              isSelected
                                  ? selectedLanguages.remove(item)
                                  : selectedLanguages.add(item);
                              setState(() {});
                              menuSetState(() {});
                            },
                            child: Container(
                              height: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  isSelected
                                      ? const Icon(Icons.check_box_outlined)
                                      : const Icon(
                                          Icons.check_box_outline_blank),
                                  const SizedBox(width: 16),
                                  StText(item, size: 14),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  searchController: languageController,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 4, right: 8, left: 8),
                    child: TextFormField(
                      controller: languageController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Search for a language...',
                        hintStyle: TextStyle(
                            color: gradient1, fontSize: 12, letterSpacing: 1.3),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      languageController.clear();
                    }
                  },
                  //   value: selectedTags.isEmpty ? null : selectedTags.last,
                  onChanged: (value) {},
                  buttonHeight: 40,
                  buttonWidth: 240,
                  itemHeight: 40,
                  itemPadding: EdgeInsets.zero),
            ),
          ),
          SizedBox(height: selectedLanguages.isEmpty ? 0 : 14),
          SizedBox(
            height: selectedLanguages.isEmpty ? 0 : 30,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: selectedLanguages.length,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Chip(
                        backgroundColor: primaryLight.withOpacity(.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        label: StText(selectedLanguages[i],
                            size: 14,
                            weight: FontWeight.w500,
                            color: gradient1),
                        onDeleted: () {
                          setState(() {
                            selectedLanguages.remove(selectedLanguages[i]);
                          });
                        }),
                  );
                }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: StText(widget.isListener ? "Your Story" : "Bio",
                color: gradient1, weight: FontWeight.w500),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            decoration: BoxDecoration(
                //color: Colors.red,
                border: Border.all(color: gradient1, width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: descController,
              cursorColor: gradient1,
              cursorWidth: 1.5,
              cursorHeight: 16,
              maxLines: 10,
              style: const TextStyle(fontSize: 14, height: 1),
              decoration: InputDecoration(
                  isDense: true,
                  hintText: widget.isListener
                      ? "Tell us your story..."
                      : "Describe yourself...",
                  hintStyle: TextStyle(
                      fontSize: 16, height: 1, fontWeight: FontWeight.w500),
                  border: InputBorder.none),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 10),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16)),
                  backgroundColor: MaterialStateProperty.all(
                      isLoading ? Colors.grey : gradient1)),
              icon: const Icon(CupertinoIcons.checkmark_alt),
              label: const StText("Complete Profile", color: Colors.white),
              onPressed: () async {
                if (image == null ||
                    !(isCallSelected || isChatSelected) ||
                    selectedLanguages.isEmpty ||
                    selectedTags.isEmpty ||
                    nameController.text.trim().isEmpty ||
                    ageController.text.trim().isEmpty ||
                    emailController.text.trim().isEmpty ||
                    accountNameController.text.trim().isEmpty ||
                    bankNameController.text.trim().isEmpty ||
                    //   ifscController.text.trim().isEmpty ||
                    reaccountController.text.trim().isEmpty ||
                    accountController.text.trim().isEmpty ||
                    ifscController.text.trim().isEmpty ||
                    descController.text.trim().isEmpty) {
                  showSnack(
                      context: context, message: "All inputs are required");
                } else if (accountController.text != reaccountController.text) {
                  showSnack(
                      context: context, message: "Account No.s don't match");
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  UserService()
                      .convertToListener(
                          age: ageController.text.trim(),
                          name: nameController.text.trim(),
                          bankName: bankNameController.text.trim(),
                          accountType: selectedAccountType,
                          email: emailController.text.trim(),
                          accountName: accountNameController.text.trim(),
                          gender: selectedGender,
                          phone: userProvider.getUser!.phone,
                          accountNo: accountController.text.trim(),
                          ifscCode: ifscController.text.trim(),
                          selectedTags: selectedTags,
                          role: widget.isListener
                              ? "under-review-listener"
                              : "under-review-counsellor",
                          description: descController.text.trim(),
                          image: image!,
                          languages: selectedLanguages,
                          isChatEnabled: isChatSelected,
                          isCallEnabled: isCallSelected)
                      .then((value) => value
                          ? userProvider.refreshUser().whenComplete(() =>
                              Navigator.of(context).pushReplacementNamed(
                                  UnderReviewScreen.routeName))
                          : showSnack(
                              context: context,
                              message: "Please try again later."));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
