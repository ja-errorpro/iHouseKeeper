import 'package:flutter/material.dart';

class Buttons {
  static Widget getButton(String text, String image, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage(image),
              width: 50,
            ),
          ),
          Text(text)
        ],
      ), // Column
    );
  }
}
