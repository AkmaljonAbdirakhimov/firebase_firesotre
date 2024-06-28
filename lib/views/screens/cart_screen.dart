import 'package:dars64_statemanagement/controllers/cart_controller.dart';
import 'package:dars64_statemanagement/models/product.dart';
import 'package:dars64_statemanagement/views/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);

    final products = cartController.cart.products;
    return Scaffold(
      appBar: AppBar(
        title: const Text("S A V A T C H A"),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text("Savatchangiz bo'sh. Mahsulot qo'shing!"),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, index) {
                final product = products.values.toList()[index]['product'];
                return ChangeNotifierProvider<Product>.value(
                  value: product,
                  child: ProductItem(),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.amber,
        extendedPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 50,
        ),
        label: Text(
          "\$${cartController.cart.totalPrice}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
