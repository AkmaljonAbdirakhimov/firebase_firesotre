import 'dart:math';

import 'package:dars64_statemanagement/controllers/cart_controller.dart';
import 'package:dars64_statemanagement/controllers/products_controller.dart';
import 'package:dars64_statemanagement/models/product.dart';
import 'package:dars64_statemanagement/views/widgets/add_product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return ListTile(
      key: widget.key,
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return AddProductDialog(product: product);
          },
        );
      },
      leading: Container(
        width: 60,
        color: product.color,
      ),
      title: Text(
        product.title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        "\$${product.price}",
      ),
      trailing: Consumer<CartController>(
        builder: (ctx, cartController, child) {
          return cartController.isProductInCart(product.id)
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        cartController.removeFromCart(product.id);
                      },
                      icon: const Icon(Icons.remove_circle),
                    ),
                    Text(
                      cartController.getProductAmount(product.id).toString(),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        cartController.addToCart(product);
                      },
                      icon: const Icon(Icons.add_circle),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        final productsController =
                            context.read<ProductsController>();
                        productsController.deleteProduct(product.id);
                      },
                      icon: const Icon(
                        Icons.delete,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        cartController.addToCart(product);
                      },
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
