import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:our_market/core/api_services.dart';
import 'package:our_market/views/product_details/models/rate_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());
  final ApiServices _apiServices = ApiServices();
  List<RateModel> rates = [];
  int averageRate = 0;
  int userRate = 5;
  String userID = Supabase.instance.client.auth.currentUser!.id;
  Future<void> getRate({required String productId}) async {
    emit(GetRateLoading());
    try {
      Response response = await _apiServices.getData(
        "rates_table?select=*&for_product=eq.$productId",
      );
      for (var rate in response.data) {
        rates.add(RateModel.fromJson(rate));
      }
      _getAverageRate();
      _getUserRate();

      emit(GetRateSuccess());
    } catch (e) {
      log("error   ${e.toString()}");
      emit(GetRateError());
    }
  }

  void _getUserRate() {
    List<RateModel> userRates = rates
        .where((RateModel rate) => rate.forUser == userID)
        .toList();
    userRate = userRates.isNotEmpty ? userRates[0].rate! : 5;
  }

  void _getAverageRate() {
    for (int i = 0; i < rates.length; i++) {
      averageRate += rates[i].rate!;
    }
    if(rates.isEmpty){
      averageRate = 0;
    }
    else{
       averageRate = averageRate ~/ rates.length;
    }
   
  }

  bool _isUserRateExist({required String productId}) {
    List<RateModel> userRates = rates
        .where(
          (RateModel rate) =>
              rate.forUser == userID && rate.forProduct == productId,
        )
        .toList();
    return userRates.isNotEmpty ? true : false;
  }

  Future<void> addOrUpdateUserRate({
    required String productId,
    required Map<String, dynamic> data,
  }) async {
    emit(AddOrUpdateRateLoading());
    String path =
        "rates_table?select=*&for_user=eq.$userID&for_product=eq.$productId";
    try {
      if (_isUserRateExist(productId: productId)) {
       await _apiServices.patchData(path, data);
      } else {
      await  _apiServices.postData(path, data);
      }
   
      emit(AddOrUpdateRateSuccess());
    } catch (e) {
      log(e.toString());
      emit(AddOrUpdateRateError());
    }
  }
  Future<void>addComment ({required Map<String,dynamic> data})async{
    emit(AddCommentLoading());
    try{
      await _apiServices.postData("comments_table",data);
      emit(AddCommentSuccess());
    }catch(e){
      log(e.toString());
      emit(AddCommentError());
    }
  }
}
