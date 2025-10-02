import 'package:flutter/material.dart';
import 'package:our_market/core/app_colors.dart';

import 'custom_arrow_btn.dart';

class CustomRowWithArrowBtn extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const CustomRowWithArrowBtn({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: AppColors.kPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomArrowBtn(onPressed: onPressed),
      ],
    );
  }
}
