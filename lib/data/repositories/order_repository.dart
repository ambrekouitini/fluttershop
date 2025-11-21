import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../services/cache_service.dart';

class OrderRepository {
  final CacheService _cacheService = CacheService();
  final _uuid = const Uuid();

  Future<List<OrderModel>> getOrders() async {
    try {
      return await _cacheService.getCachedOrders();
    } catch (e) {
      debugPrint('Erreur chargement commandes : $e');
      return [];
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final orders = await getOrders();
      return orders.firstWhere(
        (order) => order.id == orderId,
        orElse: () => throw Exception('Commande non trouvée'),
      );
    } catch (e) {
      debugPrint('Erreur : $e');
      return null;
    }
  }

  Future<OrderModel> createOrder({
    required List<CartItemModel> items,
    required double total,
    required String userId,
  }) async {
    final order = OrderModel(
      id: _uuid.v4(),
      items: items,
      total: total,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      userId: userId,
    );

    await _cacheService.cacheOrder(order);
    return order;
  }

  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    final orders = await getOrders();
    return orders.where((order) => order.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
