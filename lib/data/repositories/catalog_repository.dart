import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class CatalogRepository {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final cachedProducts = await _cacheService.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        debugPrint('📦 Produits chargés depuis le cache');
        return cachedProducts;
      }

      debugPrint('🌐 Chargement des produits depuis le JSON local');
      final products = await _apiService.fetchProducts();

      await _cacheService.cacheProducts(products);

      return products;
    } catch (e) {
      final cachedProducts = await _cacheService.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
      throw Exception('Impossible de charger les produits : $e');
    }
  }

  Future<ProductModel> fetchProduct(String id) async {
    try {
      final cachedProduct = await _cacheService.getCachedProductDetail(id);
      if (cachedProduct != null) {
        return cachedProduct;
      }

      final product = await _apiService.fetchProduct(id);

      await _cacheService.cacheProductDetail(product);

      return product;
    } catch (e) {
      throw Exception('Impossible de charger le produit $id : $e');
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      return await _apiService.fetchCategories();
    } catch (e) {
      throw Exception('Impossible de charger les catégories : $e');
    }
  }

  Future<List<ProductModel>> refreshProducts() async {
    await _cacheService.clearProductsCache();
    return fetchProducts();
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      return await _apiService.searchProducts(query);
    } catch (e) {
      throw Exception('Erreur de recherche : $e');
    }
  }

  Future<List<ProductModel>> filterByCategory(String category) async {
    try {
      return await _apiService.filterByCategory(category);
    } catch (e) {
      throw Exception('Erreur de filtrage : $e');
    }
  }
}
