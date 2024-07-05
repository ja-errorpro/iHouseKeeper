import 'package:flutter/material.dart';

class Buttons {
  static Widget getButton(String text, String image, Function()? onTap) {
    return SizedBox(
        height: 150,
        width: 150,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, width: 50, fit: BoxFit.cover),
              SizedBox(
                height: 2,
              ),
              Text(text)
            ],
          ), // Column
        ));
  }
}
