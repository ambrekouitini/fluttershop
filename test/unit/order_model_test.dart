import 'package:flutter_test/flutter_test.dart';
import 'package:shop_flutter/data/models/order_model.dart';
import 'package:shop_flutter/data/models/cart_item_model.dart';
import 'package:shop_flutter/data/models/product_model.dart';

void main() {
  group('OrderModel', () {
    const testProduct = ProductModel(
      id: '1',
      title: 'Test Product',
      price: 100.0,
      description: 'A test product',
      category: 'Electronics',
      thumbnail: 'https://example.com/image.jpg',
      images: ['https://example.com/image1.jpg'],
    );

    final testCartItem = CartItemModel(
      product: testProduct,
      quantity: 2,
    );

    test('should calculate total correctly', () {
      final order = OrderModel(
        id: '1',
        items: [testCartItem],
        total: 200.0,
        status: OrderStatus.pending,
        createdAt: DateTime(2024, 1, 1),
        userId: 'user123',
      );

      expect(order.total, 200.0);
      expect(order.items.length, 1);
    });

    test('should create OrderModel from JSON', () {
      final json = {
        'id': '1',
        'items': [
          {
            'product': {
              'id': '1',
              'title': 'Test Product',
              'price': 100.0,
              'description': 'A test product',
              'category': 'Electronics',
              'thumbnail': 'https://example.com/image.jpg',
              'images': ['https://example.com/image1.jpg'],
            },
            'quantity': 2,
          }
        ],
        'total': 200.0,
        'status': 'pending',
        'createdAt': '2024-01-01T00:00:00.000',
        'userId': 'user123',
      };

      final order = OrderModel.fromJson(json);

      expect(order.id, '1');
      expect(order.total, 200.0);
      expect(order.items.length, 1);
      expect(order.items.first.quantity, 2);
      expect(order.status, OrderStatus.pending);
    });

    test('should convert OrderModel to JSON', () {
      final order = OrderModel(
        id: '1',
        items: [testCartItem],
        total: 200.0,
        status: OrderStatus.pending,
        createdAt: DateTime(2024, 1, 1),
        userId: 'user123',
      );

      final json = order.toJson();

      expect(json['id'], '1');
      expect(json['total'], 200.0);
      expect(json['items'], isA<List>());
      expect(json['createdAt'], isA<String>());
      expect(json['status'], 'pending');
      expect(json['userId'], 'user123');
    });
  });
}
