import 'package:flutter/material.dart';
import 'package:our_market/core/app_colors.dart';

class CustomArrowBtn extends StatelessWidget {
  final void Function() onPressed;
  const CustomArrowBtn({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Icon(Icons.arrow_forward, color: AppColors.kWhiteColor),
      ),
    );
  }
}
