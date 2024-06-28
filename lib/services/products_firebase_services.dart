import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsFirebaseServices {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  Stream<QuerySnapshot> getProducts() async* {
    yield* _products.snapshots();
  }

  void addProduct(
    String title,
    double price,
    Color color,
  ) async {
    final product = {
      "title": title,
      "price": price,
      "color": color.value,
    };
    await _products.add(product);
  }

  void editProduct(
    String productId,
    String title,
    double price,
    Color color,
  ) async {
    final product = {
      "title": title,
      "price": price,
      "color": color.value,
    };

    await _products.doc(productId).update(product);
  }

  void deleteProduct(String productId) async {
    await _products.doc(productId).delete();
  }
}
