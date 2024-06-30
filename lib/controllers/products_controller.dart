import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars64_statemanagement/models/product.dart';
import 'package:flutter/material.dart';
import '../services/products_firebase_services.dart';

class ProductsController extends ChangeNotifier {
  final productsFirebaseService = ProductsFirebaseServices();

  Stream<QuerySnapshot> getProducts() async* {
    yield* productsFirebaseService.getProducts();
  }

  Future<void> addProduct(
    String title,
    double price,
    File image,
  ) async {
    await productsFirebaseService.addProduct(
      title,
      price,
      image,
    );
  }

  Future<void> editProduct(
    String productId,
    String newTitle,
    double newPrice,
    String imageUrl,
    File? image,
  ) async {
    await productsFirebaseService.editProduct(
      productId,
      newTitle,
      newPrice,
      imageUrl,
      image,
    );
  }

  Future<void> deleteProduct(Product product) async {
    await productsFirebaseService.deleteProduct(product);
  }
}
