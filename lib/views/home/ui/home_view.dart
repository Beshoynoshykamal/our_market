import 'package:our_market/core/functions/navigate_to.dart';
import 'package:our_market/core/widgets/custom_search_field.dart';
import 'package:our_market/core/widgets/product_list.dart';
import 'package:flutter/material.dart';
import 'package:our_market/views/home/ui/search_view.dart';
import 'widgets/categories_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          CustomSearchField(
            controller: searchController,
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                navigateTo(context, SearchView(query: searchController.text));
                searchController.clear();
              }
            },
          ),
          const SizedBox(height: 20),

          Image.asset("assets/images/buy.jpg"),
          const SizedBox(height: 15),
          const Text(
            "Popular Categories",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 15),
          const CategoriesList(),
          const SizedBox(height: 15),
          const Text(
            "Recently Products",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 15),
          const ProductList(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
