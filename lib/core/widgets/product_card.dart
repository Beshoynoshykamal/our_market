import 'package:flutter/material.dart';
import 'package:our_market/core/app_colors.dart';
import 'package:our_market/core/functions/navigate_to.dart';
import 'package:our_market/core/model/product_model/product_model.dart';
import 'package:our_market/core/widgets/cache_image.dart';
import 'package:our_market/views/auth/ui/widgets/custom_elevated_btn.dart';
import 'package:our_market/views/product_details/ui/product_details_view.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onPressed, required this.isFavorite});
  final ProductModel product;
 final void Function()? onPressed;
 final bool isFavorite ;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(context, ProductDetailsView(productModel:product ,));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: CachedImage(
                    url:
                        product.imageUrl ??
                        "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZHVjdHxlbnwwfHwwfHw%3D&w=1000&q=80",
                  ),
                  //   CachedImage(url: "",),
                ),

                Positioned(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      "${product.sale.toString()}%OFF",
                      style: TextStyle(
                        color: AppColors.kWhiteColor,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.productName.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed:onPressed,
                        icon: Icon(Icons.favorite,
                         color:isFavorite?AppColors.kPrimaryColor:
                         AppColors.kGreyColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "${product.price} LE",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${product.oldPrice} LE",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.kGreyColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      CustomEBtn(text: "Buy Now", onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
