import 'package:equatable/equatable.dart';
import 'cart_item_model.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

class OrderModel extends Equatable {
  final String id;
  final List<CartItemModel> items;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String userId;

  const OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
    );
  }

  @override
  List<Object?> get props => [id, items, total, status, createdAt, userId];
}
