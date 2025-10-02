import 'package:flutter/material.dart';
import 'package:our_market/core/model/product_model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client
          .from('comments_table')
          .stream(primaryKey: ["id"])
          .eq("for_product", productModel.productId!)
          .order("created_at"),
      builder: (context, snapshot) {
        List<Map<String, dynamic>>? data = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return  UserComment(comment: data![index],);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount:data?.length ?? 0,
          );
        } else if (!snapshot.hasData) {
          return const Center(child: Text("No Comments Yet"));
        } else {
          return const Center(
            child: Text("some thing went wrong please try again"),
          );
        }
      },
    );
  }
}

class UserComment extends StatelessWidget {
  const UserComment({super.key, required this.comment});
 final Map<String, dynamic> comment; 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(comment["user_name"], style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Row(children: [Text(comment["comment"] ?? "No Comments")]),
         comment["replay"]!=null?
         Column(
          children: [
            Row(
         
          children: [
            Text("Replay:-", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Row(children: [Text(comment["replay"])])
         ])
       :SizedBox(height: 0,)
      ],
    );
  }
}