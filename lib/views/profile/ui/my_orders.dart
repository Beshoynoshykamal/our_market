import 'package:flutter/material.dart';
import 'package:our_market/core/functions/build_appbar.dart';
import 'package:our_market/core/widgets/product_list.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, "My Orders"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [ProductList()]),
      ),
    );
  }
}
