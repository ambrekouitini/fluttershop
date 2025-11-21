import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../services/cache_service.dart';

class CartRepository {
  final CacheService _cacheService = CacheService();

  Future<List<CartItemModel>> loadCart() async {
    try {
      return await _cacheService.getCachedCart();
    } catch (e) {
      debugPrint('Erreur chargement panier : $e');
      return [];
    }
  }

  Future<void> saveCart(List<CartItemModel> items) async {
    try {
      await _cacheService.cacheCart(items);
    } catch (e) {
      debugPrint('Erreur sauvegarde panier : $e');
      throw Exception('Impossible de sauvegarder le panier');
    }
  }

  Future<void> clearCart() async {
    await _cacheService.clearCart();
  }
}
