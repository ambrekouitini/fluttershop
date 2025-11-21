import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import 'base_viewmodel.dart';

class OrdersViewModel extends BaseViewModel {
  final OrderRepository _repository = OrderRepository();

  List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;
  bool get hasOrders => _orders.isNotEmpty;

  Future<void> loadOrders(String userId) async {
    setLoading(true);
    clearError();

    try {
      _orders = await _repository.getOrdersByUserId(userId);
      notifyListeners();
    } catch (e) {
      setError('Erreur chargement commandes : $e');
    } finally {
      setLoading(false);
    }
  }

  OrderModel? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }
}
