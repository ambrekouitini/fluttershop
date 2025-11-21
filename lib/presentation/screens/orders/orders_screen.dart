import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/models/order_model.dart';
import '../../viewmodels/orders_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      final currentUser = authViewModel.user;
      if (currentUser != null) {
        context.read<OrdersViewModel>().loadOrders(currentUser.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersViewModel = context.watch<OrdersViewModel>();
    final currencyFormatter = NumberFormat.currency(symbol: '€');
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB5D6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shopping_bag_rounded, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Mes Commandes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFD4E5), width: 2),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFFF69B4)),
            onPressed: () => context.go('/catalog'),
          ),
        ),
      ),
      body: ordersViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ordersViewModel.hasError
              ? Center(child: Text(ordersViewModel.errorMessage))
              : ordersViewModel.orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 100,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune commande',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          const Text('Commencez vos achats pour voir vos commandes'),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => context.go('/catalog'),
                            child: const Text('Voir les produits'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: ordersViewModel.orders.length,
                      itemBuilder: (context, index) {
                        final order = ordersViewModel.orders[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 4,
                          shadowColor: const Color(0xFFFFB6C1).withValues(alpha: 0.3),
                          child: ExpansionTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getStatusColor(order.status).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              'Commande #${order.id.substring(0, 8)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(dateFormatter.format(order.createdAt)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(order.status),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _getStatusText(order.status),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      currencyFormatter.format(order.total),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            children: [
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Articles (${order.items.length})',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 12),
                                    ...order.items.map((item) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${item.product.title} x${item.quantity}',
                                                ),
                                              ),
                                              Text(
                                                currencyFormatter
                                                    .format(item.totalPrice),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status.name) {
      case 'pending':
        return const Color(0xFFFFB347); // Orange pastel
      case 'processing':
        return const Color(0xFF87CEEB); // Bleu ciel
      case 'shipped':
        return const Color(0xFFE6A8D7); // Violet pastel
      case 'delivered':
        return const Color(0xFF90EE90); // Vert pastel
      case 'cancelled':
        return const Color(0xFFFF6B9D); // Rose-rouge
      default:
        return const Color(0xFFD3D3D3); // Gris clair
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status.name) {
      case 'pending':
        return 'EN ATTENTE';
      case 'processing':
        return 'EN TRAITEMENT';
      case 'shipped':
        return 'EXPÉDIÉE';
      case 'delivered':
        return 'LIVRÉE';
      case 'cancelled':
        return 'ANNULÉE';
      default:
        return status.name.toUpperCase();
    }
  }
}
