import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../../data/models/product_model.dart';

class CollectibleProductCard extends StatefulWidget {
  final ProductModel product;
  final int index;

  const CollectibleProductCard({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  State<CollectibleProductCard> createState() => _CollectibleProductCardState();
}

class _CollectibleProductCardState extends State<CollectibleProductCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _flipController;
  late AnimationController _shineController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _shineAnimation;

  bool _isFlipped = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shineController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _shineAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _hoverController.forward().then((_) => _hoverController.reverse());
      }
    });
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _flipController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_flipController.status == AnimationStatus.completed) {
      _flipController.reverse();
      setState(() => _isFlipped = false);
    } else if (_flipController.status == AnimationStatus.dismissed) {
      _flipController.forward();
      setState(() => _isFlipped = true);

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isFlipped) {
          _flipController.reverse();
          setState(() => _isFlipped = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge(
            [_hoverController, _flipController, _shineController]),
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateZ(_rotationAnimation.value)
              ..rotateY(math.pi * _flipController.value),
            alignment: Alignment.center,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: () {
                  if (!_isFlipped) {
                    context.go('/product/${widget.product.id}');
                  }
                },
                onDoubleTap: _handleTap,
                child: _flipController.value < 0.5
                    ? _buildFrontCard()
                    : Transform(
                        transform: Matrix4.identity()..rotateY(math.pi),
                        alignment: Alignment.center,
                        child: _buildBackCard(),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    final currencyFormatter = NumberFormat.currency(symbol: '€');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getCardColor().withValues(alpha: _isHovered ? 0.5 : 0.3),
            blurRadius: _isHovered ? 30 : 20,
            spreadRadius: _isHovered ? 3 : 0,
            offset: Offset(0, _isHovered ? 12 : 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: _getCardColor().withValues(alpha: 0.15),
              ),
            ),
            Positioned(
              left: _shineAnimation.value * 200,
              top: -100,
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Container(
                  width: 100,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getCardColor(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getCardColor(),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          widget.product.category,
                          style: TextStyle(
                            color: _getCardColor(),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(
                          _getCardRarity(),
                          (index) => const Icon(
                            Icons.star,
                            color: Color(0xFFFFFACD),
                            size: 14,
                            shadows: [
                              Shadow(
                                color: Color(0xFFD4A574),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getCardColor().withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          imageUrl: widget.product.thumbnail,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFFFFF5F7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: _getCardColor(),
                                  strokeWidth: 2,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '(◕‿◕)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFFFFF5F7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '✿',
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: _getCardColor(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '(>_<)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFB8A8A8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.product.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B5B5B),
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currencyFormatter.format(widget.product.price),
                              style: TextStyle(
                                color: _getCardColor(),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getCardColor(),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        _getCardColor().withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add_shopping_cart_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                        if (_isHovered)
                          Text(
                            '✨ Double-tap pour plus d\'infos',
                            style: TextStyle(
                              fontSize: 9,
                              color: _getCardColor().withValues(alpha: 0.7),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _getCardColor(),
        boxShadow: [
          BoxShadow(
            color: _getCardColor().withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: 3,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '✨ Description',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                widget.product.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '👆 Tap pour retourner',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCardColor() {
    final category = widget.product.category.toLowerCase();
    if (category.contains('peluche')) return const Color(0xFFFFB5D6);
    if (category.contains('mode')) return const Color(0xFFFFC9DC);
    if (category.contains('vaisselle')) return const Color(0xFFFFD4E5);
    if (category.contains('papeterie')) return const Color(0xFFFFE4F5);
    if (category.contains('accessoire')) return const Color(0xFFFF9FB0);
    if (category.contains('décoration')) return const Color(0xFFFFDAE9);
    return const Color(0xFFFFB5D6);
  }

  int _getCardRarity() {
    final price = widget.product.price;
    if (price > 100) return 5;
    if (price > 75) return 4;
    if (price > 50) return 3;
    if (price > 25) return 2;
    return 1;
  }
}
