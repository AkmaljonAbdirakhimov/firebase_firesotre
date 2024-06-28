import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/products_firebase_services.dart';

class ProductsController extends ChangeNotifier {
  final productsFirebaseService = ProductsFirebaseServices();

  Stream<QuerySnapshot> getProducts() async* {
    yield* productsFirebaseService.getProducts();
  }

  void addProduct(String title, double price) {
    int red = Random().nextInt(255);
    int green = Random().nextInt(255);
    int blue = Random().nextInt(255);
    Color color = Color.fromRGBO(red, green, blue, 1);

    productsFirebaseService.addProduct(
      title,
      price,
      color,
    );
  }

  void editProduct(
    String productId,
    String newTitle,
    double newPrice,
  ) {
    int red = Random().nextInt(255);
    int green = Random().nextInt(255);
    int blue = Random().nextInt(255);
    Color color = Color.fromRGBO(red, green, blue, 1);

    productsFirebaseService.editProduct(
      productId,
      newTitle,
      newPrice,
      color,
    );
  }

  void deleteProduct(String productId) {
    productsFirebaseService.deleteProduct(productId);

    notifyListeners();
  }
}
