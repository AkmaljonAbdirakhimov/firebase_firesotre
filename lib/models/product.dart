import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product extends ChangeNotifier {
  final String id;
  String title;
  double price;
  String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'price': price});
    result.addAll({'imageUrl': imageUrl});

    return result;
  }

  factory Product.fromMap(QueryDocumentSnapshot map) {
    return Product(
      id: map.id,
      title: map['title'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'],
    );
  }
}
