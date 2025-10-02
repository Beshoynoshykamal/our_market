import 'package:flutter/material.dart';
import 'package:our_market/core/app_colors.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const CustomTextButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.kPrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
