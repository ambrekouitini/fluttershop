import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';

class CacheService {
  static const String _productsKey = 'cached_products';
  static const String _productDetailPrefix = 'product_detail_';
  static const String _cartKey = 'cart_items';
  static const String _ordersKey = 'orders';
  static const String _lastUpdateKey = 'last_products_update';

  static const Duration cacheValidity = Duration(hours: 1);

  Future<void> cacheProducts(List<ProductModel> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = products.map((p) => p.toJson()).toList();
    await prefs.setString(_productsKey, json.encode(jsonList));
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  Future<List<ProductModel>> getCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();

    final lastUpdateStr = prefs.getString(_lastUpdateKey);
    if (lastUpdateStr != null) {
      final lastUpdate = DateTime.parse(lastUpdateStr);
      if (DateTime.now().difference(lastUpdate) > cacheValidity) {
        return [];
      }
    }

    final jsonString = prefs.getString(_productsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> cacheProductDetail(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_productDetailPrefix${product.id}',
      json.encode(product.toJson()),
    );
  }

  Future<ProductModel?> getCachedProductDetail(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('$_productDetailPrefix$id');
    if (jsonString != null) {
      return ProductModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  Future<void> cacheCart(List<CartItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((item) => item.toJson()).toList();
    await prefs.setString(_cartKey, json.encode(jsonList));
  }

  Future<List<CartItemModel>> getCachedCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cartKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => CartItemModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> cacheOrder(OrderModel order) async {
    final orders = await getCachedOrders();
    orders.add(order);
    await _saveOrders(orders);
  }

  Future<List<OrderModel>> getCachedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_ordersKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => OrderModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> _saveOrders(List<OrderModel> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = orders.map((order) => order.toJson()).toList();
    await prefs.setString(_ordersKey, json.encode(jsonList));
  }

  Future<void> clearProductsCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_productsKey);
    await prefs.remove(_lastUpdateKey);
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
