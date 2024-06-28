import 'package:dars64_statemanagement/controllers/products_controller.dart';
import 'package:dars64_statemanagement/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductDialog extends StatelessWidget {
  final Product? product;
  AddProductDialog({
    super.key,
    this.product,
  });

  final titleController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (product != null) {
      titleController.text = product!.title;
      priceController.text = product!.price.toString();
    }

    return AlertDialog(
      title: const Text("Mahsulot qo'shish"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Nomi",
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Narxi",
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Bekor qilish"),
        ),
        FilledButton(
          onPressed: () {
            String title = titleController.text;
            double price = double.tryParse(priceController.text) ?? 0;

            final productsController = context.read<ProductsController>();

            // Provider.of<ProductsController>(
            //   context,
            //   listen: false,
            // );
            if (product == null) {
              productsController.addProduct(title, price);
            } else {
              productsController.editProduct(product!.id, title, price);
            }

            Navigator.pop(context);
          },
          child: const Text("Saqlash"),
        ),
      ],
    );
  }
}
