import 'package:flutter/material.dart';
import 'package:our_market/core/app_colors.dart';

class CustomRowBtn extends StatelessWidget {
  const CustomRowBtn({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });
  final void Function() onTap;
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.kPrimaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.person, color: AppColors.kWhiteColor),
              Text(
                text,
                style: TextStyle(
                  color: AppColors.kWhiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(icon, color: AppColors.kWhiteColor),
            ],
          ),
        ),
      ),
    );
  }
}
