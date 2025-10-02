import 'package:flutter/material.dart';
import 'package:our_market/core/app_colors.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({super.key, this.onPressed,  this.controller});
final void Function()? onPressed;
final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Search in Market",
        suffixIcon: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(25),
            backgroundColor: AppColors.kPrimaryColor,
            foregroundColor: AppColors.kWhiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          label: const Icon(Icons.search),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.kBordersideColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.kBordersideColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
