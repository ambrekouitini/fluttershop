import 'package:flutter/material.dart';
import 'dart:math' as math;

class KawaiiMascot extends StatefulWidget {
  final MascotMood mood;
  final String? message;
  final bool showMessage;

  const KawaiiMascot({
    super.key,
    this.mood = MascotMood.happy,
    this.message,
    this.showMessage = false,
  });

  @override
  State<KawaiiMascot> createState() => _KawaiiMascotState();
}

class _KawaiiMascotState extends State<KawaiiMascot>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _blinkController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    _startBlinking();
  }

  void _startBlinking() {
    Future.delayed(Duration(seconds: 2 + math.Random().nextInt(3)), () {
      if (mounted) {
        _blinkController.forward().then((_) {
          _blinkController.reverse();
          _startBlinking();
        });
      }
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bounceController, _blinkController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showMessage && widget.message != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFD4E5), width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFB5D6).withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.message!,
                        style: const TextStyle(
                          color: Color(0xFF6B5B5B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFD4E5), Color(0xFFFFE4F5)],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFB5D6).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildFace(),

                    Positioned(
                      top: 5,
                      left: 8,
                      child: _buildEar(),
                    ),
                    Positioned(
                      top: 5,
                      right: 8,
                      child: _buildEar(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFace() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEye(),
            const SizedBox(width: 16),
            _buildEye(),
          ],
        ),
        const SizedBox(height: 8),
        _buildMouth(),
      ],
    );
  }

  Widget _buildEye() {
    return Container(
      width: 8,
      height: 8 * _blinkAnimation.value,
      decoration: const BoxDecoration(
        color: Color(0xFF6B5B5B),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMouth() {
    switch (widget.mood) {
      case MascotMood.happy:
        return const Text('ω', style: TextStyle(fontSize: 20, color: Color(0xFFFFB5D6)));
      case MascotMood.excited:
        return const Text('∇', style: TextStyle(fontSize: 22, color: Color(0xFFFFB5D6)));
      case MascotMood.sad:
        return const Text('︵', style: TextStyle(fontSize: 18, color: Color(0xFF9B8B8B)));
      case MascotMood.thinking:
        return const Text('〜', style: TextStyle(fontSize: 18, color: Color(0xFFB8A8A8)));
      case MascotMood.love:
        return const Text('❤', style: TextStyle(fontSize: 14));
    }
  }

  Widget _buildEar() {
    return Container(
      width: 20,
      height: 25,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFE4F5), Color(0xFFFFD4E5)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

enum MascotMood {
  happy,
  excited,
  sad,
  thinking,
  love,
}

class InteractiveBook extends StatefulWidget {
  final Widget leftPage;
  final Widget rightPage;
  final bool isOpen;

  const InteractiveBook({
    super.key,
    required this.leftPage,
    required this.rightPage,
    this.isOpen = true,
  });

  @override
  State<InteractiveBook> createState() => _InteractiveBookState();
}

class _InteractiveBookState extends State<InteractiveBook>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isOpen) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              left: 0,
              right: MediaQuery.of(context).size.width / 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFFFD4E5), width: 3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(-5, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                  child: widget.leftPage,
                ),
              ),
            ),

            Positioned(
              left: MediaQuery.of(context).size.width / 2,
              right: 0,
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(math.pi * _rotationAnimation.value),
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFFFD4E5), width: 3),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    child: widget.rightPage,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class FloatingParticles extends StatefulWidget {
  final int particleCount;

  const FloatingParticles({super.key, this.particleCount = 20});

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    particles = List.generate(
      widget.particleCount,
      (index) => Particle(
        emoji: ['⭐', '✨', '💕', '🌸', '☁️', '🌈', '💫', '✿'][index % 8],
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        speed: 0.1 + math.Random().nextDouble() * 0.3,
        size: 15 + math.Random().nextDouble() * 15,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: particles.map((particle) {
            final progress = (_controller.value + particle.y) % 1.0;
            return Positioned(
              left: MediaQuery.of(context).size.width * particle.x,
              top: MediaQuery.of(context).size.height * progress,
              child: Opacity(
                opacity: 0.3 + math.sin(progress * math.pi) * 0.3,
                child: Text(
                  particle.emoji,
                  style: TextStyle(fontSize: particle.size),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class Particle {
  final String emoji;
  final double x;
  final double y;
  final double speed;
  final double size;

  Particle({
    required this.emoji,
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
  });
}
