import 'dart:io';

import 'package:dars64_statemanagement/controllers/products_controller.dart';
import 'package:dars64_statemanagement/models/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ManageProductDialog extends StatefulWidget {
  final Product? product;
  const ManageProductDialog({
    super.key,
    this.product,
  });

  @override
  State<ManageProductDialog> createState() => _ManageProductDialogState();
}

class _ManageProductDialogState extends State<ManageProductDialog> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  File? image;

  void uploadImage() async {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 50,
    );

    if (file != null) {
      setState(() {
        image = File(file.path);
      });
    }
  }

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
    if (widget.product != null) {
      titleController.text = widget.product!.title;
      priceController.text = widget.product!.price.toString();
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
          TextButton.icon(
            onPressed: uploadImage,
            label: const Text("Rasm Yuklash"),
            icon: const Icon(Icons.camera),
          ),
          if (image != null)
            SizedBox(
              width: double.infinity,
              height: 150,
              child: Image.file(
                image!,
                fit: BoxFit.cover,
              ),
            ),
          if (image == null && widget.product != null)
            SizedBox(
              width: double.infinity,
              height: 150,
              child: Image.network(
                widget.product!.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
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
          onPressed: () async {
            String title = titleController.text;
            double price = double.tryParse(priceController.text) ?? 0;

            final productsController = context.read<ProductsController>();

            showLoading();
            if (widget.product == null) {
              await productsController.addProduct(
                title,
                price,
                image!,
              );
            } else {
              await productsController.editProduct(
                widget.product!.id,
                title,
                price,
                widget.product!.imageUrl,
                image,
              );
            }

            if (context.mounted) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          child: const Text("Saqlash"),
        ),
      ],
    );
  }
}
