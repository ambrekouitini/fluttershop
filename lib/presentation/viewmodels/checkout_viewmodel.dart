import '../../data/models/cart_item_model.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import 'base_viewmodel.dart';

class CheckoutViewModel extends BaseViewModel {
  final OrderRepository _repository = OrderRepository();

  OrderModel? _createdOrder;

  OrderModel? get createdOrder => _createdOrder;

  Future<OrderModel?> createOrder({
    required List<CartItemModel> items,
    required String userId,
  }) async {
    setLoading(true);
    clearError();

    try {
      final totalAmount = items.fold(0.0, (sum, item) => sum + item.totalPrice);

      final order = await _repository.createOrder(
        items: items,
        total: totalAmount,
        userId: userId,
      );

      _createdOrder = order;
      notifyListeners();

      return order;
    } catch (e) {
      setError('Erreur création commande : $e');
      return null;
    } finally {
      setLoading(false);
    }
  }

  void clearCreatedOrder() {
    _createdOrder = null;
    notifyListeners();
  }
}
