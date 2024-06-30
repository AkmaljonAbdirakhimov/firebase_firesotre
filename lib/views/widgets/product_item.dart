import 'package:dars64_statemanagement/controllers/cart_controller.dart';
import 'package:dars64_statemanagement/controllers/products_controller.dart';
import 'package:dars64_statemanagement/models/product.dart';
import 'package:dars64_statemanagement/views/widgets/manage_product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  void showLoading() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return ListTile(
      key: widget.key,
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return ManageProductDialog(product: product);
          },
        );
      },
      leading: SizedBox(
        width: 60,
        child: Image.network(product.imageUrl),
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
        builder: (context, cartController, child) {
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
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text("Ishonchingiz komilmi?"),
                              content: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    const TextSpan(text: "Siz "),
                                    TextSpan(
                                      text: product.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(text: "ni o'chirmoqchisiz"),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Bekor Qilish"),
                                ),
                                FilledButton(
                                  onPressed: () async {
                                    final productsController =
                                        Provider.of<ProductsController>(context,
                                            listen: false);

                                    showLoading();
                                    await productsController
                                        .deleteProduct(product);

                                    if (ctx.mounted) {
                                      Navigator.pop(ctx);
                                      Navigator.pop(ctx);
                                    }
                                  },
                                  child: const Text("O'chirish"),
                                ),
                              ],
                            );
                          },
                        );
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
