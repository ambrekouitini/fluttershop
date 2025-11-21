import 'package:flutter_test/flutter_test.dart';
import 'package:shop_flutter/data/models/cart_item_model.dart';
import 'package:shop_flutter/data/models/product_model.dart';

void main() {
  group('CartItemModel', () {
    const testProduct = ProductModel(
      id: '1',
      title: 'Test Product',
      price: 50.0,
      description: 'A test product',
      category: 'Electronics',
      thumbnail: 'https://example.com/image.jpg',
      images: ['https://example.com/image1.jpg'],
    );

    test('should calculate total price correctly', () {
      final cartItem = CartItemModel(
        product: testProduct,
        quantity: 3,
      );

      expect(cartItem.totalPrice, 150.0);
    });

    test('should create CartItemModel from JSON', () {
      final json = {
        'product': {
          'id': '1',
          'title': 'Test Product',
          'price': 50.0,
          'description': 'A test product',
          'category': 'Electronics',
          'thumbnail': 'https://example.com/image.jpg',
          'images': ['https://example.com/image1.jpg'],
        },
        'quantity': 2,
      };

      final cartItem = CartItemModel.fromJson(json);

      expect(cartItem.product.id, '1');
      expect(cartItem.quantity, 2);
      expect(cartItem.totalPrice, 100.0);
    });

    test('should copy CartItemModel with updated quantity', () {
      final cartItem = CartItemModel(
        product: testProduct,
        quantity: 2,
      );

      final updatedItem = cartItem.copyWith(quantity: 5);

      expect(updatedItem.quantity, 5);
      expect(updatedItem.product, testProduct);
      expect(updatedItem.totalPrice, 250.0);
    });
  });
}
