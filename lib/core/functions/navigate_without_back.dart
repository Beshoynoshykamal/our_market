import 'package:flutter/material.dart';

void navigateWithoutBack(BuildContext context, Widget view) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => view),
  );
}
