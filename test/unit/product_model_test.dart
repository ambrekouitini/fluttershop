import 'package:flutter_test/flutter_test.dart';
import 'package:shop_flutter/data/models/product_model.dart';

void main() {
  group('ProductModel', () {
    test('should create ProductModel from JSON', () {
      final json = {
        'id': '1',
        'title': 'Test Product',
        'price': 99.99,
        'description': 'A test product',
        'category': 'Electronics',
        'thumbnail': 'https://example.com/image.jpg',
        'images': [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg'
        ],
      };

      final product = ProductModel.fromJson(json);

      expect(product.id, '1');
      expect(product.title, 'Test Product');
      expect(product.price, 99.99);
      expect(product.description, 'A test product');
      expect(product.category, 'Electronics');
      expect(product.thumbnail, 'https://example.com/image.jpg');
      expect(product.images.length, 2);
    });

    test('should convert ProductModel to JSON', () {
      const product = ProductModel(
        id: '1',
        title: 'Test Product',
        price: 99.99,
        description: 'A test product',
        category: 'Electronics',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
      );

      final json = product.toJson();

      expect(json['id'], '1');
      expect(json['title'], 'Test Product');
      expect(json['price'], 99.99);
      expect(json['description'], 'A test product');
      expect(json['category'], 'Electronics');
    });

    test('should support equality comparison', () {
      const product1 = ProductModel(
        id: '1',
        title: 'Test Product',
        price: 99.99,
        description: 'A test product',
        category: 'Electronics',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
      );

      const product2 = ProductModel(
        id: '1',
        title: 'Test Product',
        price: 99.99,
        description: 'A test product',
        category: 'Electronics',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
      );

      expect(product1, equals(product2));
    });
  });
}
