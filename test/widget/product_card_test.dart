import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_flutter/data/models/product_model.dart';
import 'package:shop_flutter/presentation/widgets/product_card.dart';

void main() {
  group('ProductCard Widget', () {
    const testProduct = ProductModel(
      id: '1',
      title: 'Test Product',
      price: 99.99,
      description: 'A test product description',
      category: 'Electronics',
      thumbnail: 'https://example.com/image.jpg',
      images: ['https://example.com/image1.jpg'],
    );

    testWidgets('should display product information', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Electronics'), findsOneWidget);
      expect(find.textContaining('99'), findsOneWidget);
    });

    testWidgets('should display product image', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );

      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should be wrapped in a Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });
  });
}
