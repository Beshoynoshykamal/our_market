import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:our_market/core/api_services.dart';
import 'package:our_market/core/model/product_model/favorite_product.dart';
import 'package:our_market/core/model/product_model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final ApiServices _apiServices = ApiServices();
  final String userID = Supabase.instance.client.auth.currentUser!.id;
  List<ProductModel> products = [];
  List<ProductModel> searchResult = [];
  List<ProductModel> categoryProducts = [];
  Future<void> getProducts({String? quary, String? category}) async {
    products.clear();
    searchResult.clear();
    categoryProducts.clear();
    favoriteProducts.clear();
    favoriteProductsList.clear();
    emit(GetDataLoading());
    try {
      Response response = await _apiServices.getData(
        'products_table?select=*,favorite_products(*),purchase_table(*)',
      );
      for (var product in response.data) {
        products.add(ProductModel.fromJson(product));
      }
      search(quary);
      getProductsByCategory(category);
      getFavoriteProducts();
      emit(GetDataSuccess());
    } catch (e) {
      emit(GetDataError());
    }
  }

  void search(String? quary) {
    if (quary != null) {
      for (var product in products) {
        if (product.productName!.toLowerCase().contains(quary.toLowerCase())) {
          searchResult.add(product);
        }
      }
    }
  }

  void getProductsByCategory(String? category) {
    if (category != null) {
      for (var product in products) {
        if (product.category!.trim().toLowerCase() ==
            category.trim().toLowerCase()) {
          categoryProducts.add(product);
        }
      }
    }
  }

  Map<String, bool> favoriteProducts = {};
  Future<void> addToFavorite({required String productId}) async {
    emit(AddToFavoriteLoading());
    try {
      await _apiServices.postData("favorite_products", {
        "is_favorite": true,
        "for_user": userID,
        "for_product": productId,
      });
      favoriteProducts.addAll({productId: true});
      await getProducts();
      emit(AddToFavoriteSuccess());
    } catch (e) {
      log(e.toString());
      emit(AddToFavoriteError());
    }
  }

  Future<void> removeFavorite({required String productId}) async {
    emit(RemoveFavoriteLoading());
    try {
      await _apiServices.deleteData(
        "favorite_products?select=*&for_user=eq.$userID&for_product=eq.$productId",
      );
      favoriteProducts.removeWhere((k, v) => k == productId);
      await getProducts();
      emit(RemoveFavoriteSuccess());
    } catch (e) {
      log(e.toString());
      emit(RemoveFavoriteError());
    }
  }

  List<ProductModel> favoriteProductsList = [];
  void getFavoriteProducts() {
    for (ProductModel product in products) {
      if (product.favoriteProducts != null &&
          product.favoriteProducts!.isNotEmpty) {
        for (FavoriteProduct favoriteProduct in product.favoriteProducts!) {
          if (favoriteProduct.forUser == userID) {
            favoriteProductsList.add(product);
            favoriteProducts.addAll({product.productId!: true});
          }
        }
      }
    }
  }

  bool checkIsFavorite(String productId) {
    return favoriteProducts.containsKey(productId);
  }
}
