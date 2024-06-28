import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product extends ChangeNotifier {
  final String id;
  String title;
  double price;
  Color color;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.color,
  });

  Product copyWith({
    String? id,
    String? title,
    double? price,
    Color? color,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'price': price});
    result.addAll({'color': color.value});

    return result;
  }

  factory Product.fromMap(QueryDocumentSnapshot map) {
    return Product(
      id: map.id,
      title: map['title'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      color: Color(map['color']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.title == title &&
        other.price == price &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ price.hashCode ^ color.hashCode;
  }
}
