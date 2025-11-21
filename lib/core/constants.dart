
class AppConstants {
  static const String appName = 'Cutie Cutie Shop';
  static const String appVersion = '1.0.0';
  
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String catalogRoute = '/catalog';
  static const String productRoute = '/product';
  static const String cartRoute = '/cart';
  static const String checkoutRoute = '/checkout';
  static const String ordersRoute = '/orders';
  static const String profileRoute = '/profile';
  
  static const Duration cacheValidity = Duration(hours: 1);
  
  static const Duration apiTimeout = Duration(seconds: 10);
}
