import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
    required this.color,
    required this.description,
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final IconData icon;
  final Color color;
  final String description;
}
