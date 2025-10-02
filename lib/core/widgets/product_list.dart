import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_market/core/cubit/home_cubit.dart';
import 'package:our_market/core/model/product_model/product_model.dart';
import 'package:our_market/core/widgets/custom_circle_pro_ind.dart';
import 'package:our_market/core/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    this.quary,
    this.category,
    this.isFavoriteView = false,
  });
  final String? quary;
  final String? category;
  final bool isFavoriteView;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeCubit()..getProducts(quary: quary, category: category),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit homeCubit = context.read<HomeCubit>();
          List<ProductModel> products;
          if (quary != null && category == null) {
            products = homeCubit.searchResult;
          } else if (quary == null && category != null) {
            products = homeCubit.categoryProducts;
          } else if (isFavoriteView) {
            products = homeCubit.favoriteProductsList;
          } else {
            products = homeCubit.products;
          }
          return state is GetDataLoading
              ? const CustomCircleProgIndicator()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => ProductCard(
                    isFavorite: homeCubit.checkIsFavorite(
                      products[index].productId!,
                    ),
                    product: products[index],
                    onPressed: () {
                      homeCubit.checkIsFavorite(products[index].productId!)
                          ? homeCubit.removeFavorite(
                              productId: products[index].productId!,
                            )
                          : homeCubit.addToFavorite(
                              productId: products[index].productId!,
                            );
                    },
                  ),
                );
        },
      ),
    );
  }
}
