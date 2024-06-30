import 'package:dars64_statemanagement/controllers/products_controller.dart';
import 'package:dars64_statemanagement/models/product.dart';
import 'package:dars64_statemanagement/views/screens/cart_screen.dart';
import 'package:dars64_statemanagement/views/widgets/manage_product_dialog.dart';
import 'package:dars64_statemanagement/views/widgets/product_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsController = context.watch<ProductsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("D I N A M O"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) {
                    return const CartScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                title: const Text("C H I Q I S H"),
                trailing: const Icon(Icons.logout),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: productsController.getProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final products = snapshot.data!.docs;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (ctx, index) {
              final product = Product.fromMap(products[index]);
              return ChangeNotifierProvider.value(
                value: product,
                child: ProductItem(),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return ManageProductDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
