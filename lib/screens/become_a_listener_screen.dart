import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
    'Hindi',
    'English',
    'Tamil',
    'Punjabi',
    'Marwadi'
  ];
  final List<String> tagList = [
    'Loneliness',
    'Relationship',
    'Family Issues',
    'Office Issues'
  ];

  XFile? image;
  bool isCallSelected = true;
  bool isChatSelected = true;
  String gender = "male";
  TextEditingController tagsController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Colors.white,
        ),
        margin: const EdgeInsets.only(top: 66),
        padding: const EdgeInsets.only(left: 14, top: 0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 24,
                          //color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      StText(
                        "${widget.isListener ? "Listener" : "Counsellor"} Settings",
                        // color: Colors.white,
                        size: 20,
                        weight: FontWeight.w500,
                      )
                    ],
                  ),
                ),
                Container(
                    transform: Matrix4.translationValues(0, -18, 0),
                    width: 140,
                    child: Image.asset("assets/become_listener.png")),
              ],
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  setState(() {});
                },
                child: Container(
                    transform: Matrix4.translationValues(0, -15, 0),
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(bottom: 0, top: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
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
            // const Padding(
            //   padding: EdgeInsets.only(right: 16, left: 8, top: 10),
            //   //padding: const EdgeInsets.all(8.0),
            //   child:
            //       StText("Name", color: primaryColor, weight: FontWeight.w500),
            // ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 16, bottom: 20, top: 8),
              child: TextFormField(
                controller: nameController,
                cursorColor: primaryColor,
                cursorWidth: 1.5,
                cursorHeight: 16,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  height: 1,
                  fontSize: 16,
                ),
                decoration: getTfDecortion("Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 16, bottom: 20),
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
                  fontSize: 16,
                ),
                decoration: getTfDecortion("Email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 16, bottom: 20),
              child: TextFormField(
                controller: ageController,
                cursorColor: primaryColor,
                cursorWidth: 1.5,
                cursorHeight: 16,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  height: 1,
                  fontSize: 16,
                ),
                decoration: getTfDecortion("Age"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16, left: 8, top: 10),
              //padding: const EdgeInsets.all(8.0),
              child: StText("Select Gender",
                  color: primaryColor, weight: FontWeight.w500),
            ),
            Row(
              children: [
                SizedBox(
                    width: 140,
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: const StText("Male", size: 16),
                      activeColor: primaryColor,
                      value: "male",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    )),
                SizedBox(
                    width: 140,
                    child: RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: primaryColor,
                      title: const StText("Female", size: 16),
                      value: "female",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    )),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16, left: 8, top: 10, bottom: 4),
              //padding: const EdgeInsets.all(8.0),
              child: StText("Connecting Options",
                  color: primaryColor, weight: FontWeight.w500),
            ),
            Row(
              children: [
                SizedBox(
                    width: 140,
                    child: CheckboxListTile(
                      dense: true,
                      activeColor: primaryColor,
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
                      activeColor: primaryColor,
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

            Padding(
              padding: const EdgeInsets.only(right: 16, left: 6, top: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  customButton: DropdownContainer(
                    title: widget.isListener ? "Interests" : "Specialization",
                  ),
                  items: tagList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      enabled: false,
                      child: StatefulBuilder(
                        builder: (context, menuSetState) {
                          final isSelected = selectedTags.contains(item);
                          return InkWell(
                            onTap: () {
                              isSelected
                                  ? selectedTags.remove(item)
                                  : selectedTags.add(item);
                              //This rebuilds the StatefulWidget to update the button's text
                              setState(() {});
                              //This rebuilds the dropdownMenu Widget to update the check mark
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
                                  StText(
                                    item,
                                    size: 14,
                                  ),
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
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      controller: tagsController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Search for an interest...',
                        hintStyle: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            letterSpacing: 1.3),
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
                  //   value: selectedTags.isEmpty ? null : selectedTags.last,
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
                              color: primaryColor),
                          onDeleted: () {
                            setState(() {
                              selectedTags.remove(selectedTags[i]);
                            });
                          }),
                    );
                  }),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 16, left: 6, top: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  customButton: const DropdownContainer(
                    title: "Languages",
                  ),
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
                              //This rebuilds the StatefulWidget to update the button's text
                              setState(() {});
                              //This rebuilds the dropdownMenu Widget to update the check mark
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
                                  StText(
                                    item,
                                    size: 14,
                                  ),
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
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
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
                            color: primaryColor,
                            fontSize: 12,
                            letterSpacing: 1.3),
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
                  itemPadding: EdgeInsets.zero,
                ),
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
                              color: primaryColor),
                          onDeleted: () {
                            setState(() {
                              selectedLanguages.remove(selectedLanguages[i]);
                            });
                          }),
                    );
                  }),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16, left: 8, top: 20),
              //padding: const EdgeInsets.all(8.0),
              child: StText("Your Story",
                  color: primaryColor, weight: FontWeight.w500),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(
                  left: 6, right: 16, top: 10, bottom: 30),
              decoration: BoxDecoration(
                  //color: Colors.red,
                  border: Border.all(color: primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: descController,
                cursorColor: primaryColor,
                cursorWidth: 1.5,
                cursorHeight: 16,
                maxLines: 10,
                style: const TextStyle(fontSize: 14, height: 1),
                decoration: const InputDecoration(
                    isDense: true,
                    hintText: "Tell us your story...",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      height: 1,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6, right: 16, bottom: 30),
              child: ElevatedButton.icon(
                // isLoading: isLoading,
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16)),
                    backgroundColor: MaterialStateProperty.all(
                        isLoading ? Colors.grey : primaryColor)),
                icon: const Icon(CupertinoIcons.checkmark_alt),
                label: const StText("Complete Profile", color: Colors.white),
                onPressed: () async {
                  if (image == null ||
                      !(isCallSelected || isChatSelected) ||
                      selectedLanguages.isEmpty ||
                      selectedTags.isEmpty ||
                      descController.text.trim().isEmpty ||
                      ageController.text.trim().isEmpty ||
                      emailController.text.trim().isEmpty ||
                      nameController.text.trim().isEmpty) {
                    showSnack(
                        context: context, message: "All inputs are required");
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    UserService()
                        .convertToListener(
                            selectedTags: selectedTags,
                            role: "listener",
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            gender: gender,
                            age: ageController.text.toString(),
                            description: descController.text.trim(),
                            image: image!,
                            languages: selectedLanguages,
                            isChatEnabled: isChatSelected,
                            isCallEnabled: isCallSelected)
                        .then((value) => value
                            ? userProvider.refreshUser().whenComplete(() =>
                                Navigator.of(context).pushReplacementNamed(
                                    UnderReviewScreen.routeName,
                                    arguments: "true"))
                            : showSnack(
                                context: context,
                                message: "Please try again later."));
                  }
                  // Navigator.of(context)
                  //     .pushReplacementNamed(HomeScreen.routeName);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
