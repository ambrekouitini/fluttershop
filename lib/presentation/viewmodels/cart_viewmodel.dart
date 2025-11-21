import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/cart_repository.dart';
import 'base_viewmodel.dart';

class CartViewModel extends BaseViewModel {
  final CartRepository _repository = CartRepository();

  List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  String get formattedTotal => '${totalAmount.toStringAsFixed(2)} €';
  bool get isEmpty => _items.isEmpty;

  CartViewModel() {
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      _items = await _repository.loadCart();
      notifyListeners();
    } catch (e) {
      setError('Erreur chargement panier : $e');
    }
  }

  Future<void> addProduct(ProductModel product, {int quantity = 1}) async {
    try {
      final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

      if (existingIndex != -1) {
        _items[existingIndex].quantity += quantity;
      } else {
        _items.add(CartItemModel(product: product, quantity: quantity));
      }

      await _saveCart();
    } catch (e) {
      setError('Erreur ajout au panier : $e');
    }
  }

  Future<void> removeProduct(String productId) async {
    try {
      _items.removeWhere((item) => item.product.id == productId);
      await _saveCart();
    } catch (e) {
      setError('Erreur suppression : $e');
    }
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await removeProduct(productId);
        return;
      }

      final index = _items.indexWhere((item) => item.product.id == productId);
      if (index != -1) {
        _items[index].quantity = newQuantity;
        await _saveCart();
      }
    } catch (e) {
      setError('Erreur mise à jour : $e');
    }
  }

  Future<void> clearCart() async {
    try {
      _items = [];
      await _repository.clearCart();
      notifyListeners();
    } catch (e) {
      setError('Erreur vidage panier : $e');
    }
  }

  Future<void> _saveCart() async {
    await _repository.saveCart(_items);
    notifyListeners();
  }
}
