import 'package:flutter/foundation.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/catalog_repository.dart';
import 'base_viewmodel.dart';

class CatalogViewModel extends BaseViewModel {
  final CatalogRepository _repository = CatalogRepository();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = '';
  String _searchQuery = '';

  List<ProductModel> get products => _filteredProducts.isEmpty && _searchQuery.isEmpty && _selectedCategory.isEmpty 
      ? _allProducts 
      : _filteredProducts;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  int get productsCount => products.length;

  CatalogViewModel() {
    loadData();
  }

  Future<void> loadData() async {
    await loadProducts();
    await loadCategories();
  }

  Future<void> loadProducts() async {
    if (isLoading) return;
    
    setLoading(true);
    clearError();

    try {
      _allProducts = await _repository.fetchProducts();
      _filteredProducts = [];
      notifyListeners();
    } catch (e) {
      setError('Impossible de charger les produits : $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _repository.fetchCategories();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement catégories : $e');
    }
  }

  Future<void> refreshProducts() async {
    setLoading(true);
    clearError();

    try {
      _allProducts = await _repository.refreshProducts();
      _applyFilters();
    } catch (e) {
      setError('Impossible de rafraîchir : $e');
    } finally {
      setLoading(false);
    }
  }

  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      bool matchesCategory = _selectedCategory.isEmpty ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();

      bool matchesSearch = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery) ||
          product.description.toLowerCase().contains(_searchQuery);

      return matchesCategory && matchesSearch;
    }).toList();

    notifyListeners();
  }

  ProductModel? getProductById(String id) {
    try {
      return _allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  void clearFilters() {
    _selectedCategory = '';
    _searchQuery = '';
    _filteredProducts = [];
    notifyListeners();
  }
}
