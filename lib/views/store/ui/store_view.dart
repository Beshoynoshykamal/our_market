import 'package:flutter/material.dart';
import 'package:our_market/core/app_colors.dart';
import 'package:our_market/core/widgets/custom_search_field.dart';
import 'package:our_market/core/widgets/product_list.dart';

class StoreView extends StatelessWidget {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Center(
            child: const Text(
              "Welcome to Our Market",
              style: TextStyle(
                fontSize: 24,
                color: AppColors.kBlackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const CustomSearchField(),
          const SizedBox(height: 20),
          const ProductList(),
        ],
      ),
    );
  }
}
