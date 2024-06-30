import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars64_statemanagement/models/product.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductsFirebaseServices {
  final _products = FirebaseFirestore.instance.collection('products');
  final _storageService = FirebaseStorage.instance;

  Stream<QuerySnapshot> getProducts() async* {
    yield* _products.snapshots();
  }

  Future<void> addProduct(
    String title,
    double price,
    File image,
  ) async {
    String imageUrl = await _uploadProductImage(image, title);

    final product = {
      "title": title,
      "price": price,
      "imageUrl": imageUrl,
    };
    await _products.add(product);
  }

  Future<void> editProduct(
    String productId,
    String title,
    double price,
    String imageUrl,
    File? image,
  ) async {
    if (image != null) {
      await _storageService.refFromURL(imageUrl).delete();
      imageUrl = await _uploadProductImage(image, title);
    }

    final product = {
      "title": title,
      "price": price,
      "imageUrl": imageUrl,
    };

    await _products.doc(productId).update(product);
  }

  Future<void> deleteProduct(Product product) async {
    await _storageService.refFromURL(product.imageUrl).delete();
    await _products.doc(product.id).delete();
  }

  Future<String> _uploadProductImage(
    File image,
    String title,
  ) async {
    final imageRef = _storageService
        .ref()
        .child("products")
        .child("images")
        .child("$title.jpg");

    final uploadTask = imageRef.putData(
      image.readAsBytesSync(),
      SettableMetadata(
        contentType: "image/jpeg",
      ),
    );

    await uploadTask.whenComplete(() {});
    return imageRef.getDownloadURL();
  }
}
