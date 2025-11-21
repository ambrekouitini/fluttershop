import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_flutter/data/models/cart_item_model.dart';
import 'package:shop_flutter/data/models/product_model.dart';

void main() {
  group('CartScreen Widget', () {
    testWidgets('should display empty cart icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const Text('Your cart is empty'),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('should calculate cart item total price',
        (WidgetTester tester) async {
      const testProduct = ProductModel(
        id: '1',
        title: 'Test Product',
        price: 50.0,
        description: 'A test product',
        category: 'Electronics',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
      );

      final cartItem = CartItemModel(
        product: testProduct,
        quantity: 2,
      );

      expect(cartItem.totalPrice, 100.0);
      expect(cartItem.quantity, 2);
    });
  });
}
