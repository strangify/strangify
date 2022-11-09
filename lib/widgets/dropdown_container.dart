import 'package:flutter/material.dart';
import 'package:strangify/widgets/st_text.dart';

import '../constants.dart';

class DropdownContainer extends StatelessWidget {
  final String title;
  const DropdownContainer({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StText(title),
            const Icon(Icons.arrow_drop_down, color: primaryColor)
          ],
        ),
      ),
    );
  }
}
