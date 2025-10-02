import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:our_market/core/app_colors.dart';
import 'package:our_market/core/functions/build_appbar.dart';
import 'package:our_market/core/functions/navigate_without_back.dart';
import 'package:our_market/core/model/product_model/product_model.dart';
import 'package:our_market/core/widgets/cache_image.dart';
import 'package:our_market/views/auth/logic/cubit/authentication_cubit.dart';
import 'package:our_market/views/auth/ui/widgets/custom_text_form_field.dart';
import 'package:our_market/views/product_details/logic/cubit/product_details_cubit.dart';
import 'widgets/comments_list.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final TextEditingController? commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductDetailsCubit()
            ..getRate(productId: widget.productModel.productId!),
      child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          if (state is AddOrUpdateRateSuccess) {
            navigateWithoutBack(context, widget);
          }
        },
        builder: (context, state) {
          ProductDetailsCubit cubit = context.read<ProductDetailsCubit>();
          return Scaffold(
            appBar: buildCustomAppBar(
              context,
              widget.productModel.productName!,
            ),
            body: state is GetRateLoading || state is AddCommentLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      CachedImage(url: widget.productModel.imageUrl!),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 16,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.productModel.productName!),
                                Text("${widget.productModel.price}LE"),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(cubit.averageRate.toString()),
                                    Icon(Icons.star, color: Colors.amber),
                                  ],
                                ),
                                Icon(
                                  Icons.favorite,
                                  color: AppColors.kGreyColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Text(widget.productModel.description!),

                            SizedBox(height: 20),
                            RatingBar.builder(
                              initialRating: cubit.userRate.toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              itemBuilder: (context, _) =>
                                  Icon(Icons.star, color: Colors.amber),
                              onRatingUpdate: (rating) {
                                cubit.addOrUpdateUserRate(
                                  productId: widget.productModel.productId!,
                                  data: {
                                    "rate": rating.toInt(),
                                    "for_user": cubit.userID,
                                    "for_product":
                                        widget.productModel.productId!,
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 20),
                            CustomTextFormField(
                              labelText: "Type Your Feedback",
                              controller: commentController,
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  await context.read<AuthenticationCubit>().getUserData();
                                await  cubit.addComment(
                                    data: {
                                      "comment": commentController!.text,
                                      "for_user": cubit.userID,
                                      "for_product":
                                          widget.productModel.productId!,
                                      // ignore: use_build_context_synchronously
                                      "user_name": context
                                          .read<AuthenticationCubit>()
                                          .userDataModel!
                                          .name
                                    },
                                  );commentController!.clear();
                                },
                                icon: Icon(Icons.send),
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  "Comments",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            CommentsList(productModel:widget.productModel,),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    commentController!.dispose();
    super.dispose();
  }
}
