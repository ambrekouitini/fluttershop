import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';

class ApiService {
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/products.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> productsJson = data['products'] as List<dynamic>;

      return productsJson
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des produits : $e');
    }
  }

  Future<ProductModel> fetchProduct(String id) async {
    try {
      final products = await fetchProducts();
      return products.firstWhere(
        (product) => product.id == id,
        orElse: () => throw Exception('Produit non trouvé'),
      );
    } catch (e) {
      throw Exception('Erreur lors du chargement du produit : $e');
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      final products = await fetchProducts();
      final categories = products.map((p) => p.category).toSet().toList();
      categories.sort();
      return categories;
    } catch (e) {
      throw Exception('Erreur lors du chargement des catégories : $e');
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final products = await fetchProducts();
      if (query.isEmpty) return products;

      final lowerQuery = query.toLowerCase();
      return products.where((product) {
        return product.title.toLowerCase().contains(lowerQuery) ||
            product.description.toLowerCase().contains(lowerQuery) ||
            product.category.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      throw Exception('Erreur lors de la recherche : $e');
    }
  }

  Future<List<ProductModel>> filterByCategory(String category) async {
    try {
      final products = await fetchProducts();
      if (category.isEmpty) return products;

      return products.where((product) {
        return product.category.toLowerCase() == category.toLowerCase();
      }).toList();
    } catch (e) {
      throw Exception('Erreur lors du filtrage : $e');
    }
  }
}
