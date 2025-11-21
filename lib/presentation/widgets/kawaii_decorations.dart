import 'package:flutter/material.dart';
import 'dart:math' as math;

class KawaiiBackground extends StatelessWidget {
  final Widget child;

  const KawaiiBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFFBF5), // Crème
                Color(0xFFFFF0F5), // Rose pâle
                Color(0xFFD4E5FF), // Bleu ciel
              ],
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 30,
          child: _FloatingEmoji(emoji: '⭐', size: 20),
        ),
        Positioned(
          top: 100,
          left: 40,
          child: _FloatingEmoji(emoji: '✨', size: 16),
        ),
        Positioned(
          bottom: 150,
          right: 50,
          child: _FloatingEmoji(emoji: '🌸', size: 18),
        ),
        Positioned(
          bottom: 100,
          left: 30,
          child: _FloatingEmoji(emoji: '💕', size: 22),
        ),
        Positioned(
          top: 200,
          right: 80,
          child: _FloatingEmoji(emoji: '☁️', size: 30),
        ),
        Positioned(
          top: 300,
          left: 60,
          child: _FloatingEmoji(emoji: '🌈', size: 24),
        ),
        child,
      ],
    );
  }
}

class _FloatingEmoji extends StatefulWidget {
  final String emoji;
  final double size;

  const _FloatingEmoji({required this.emoji, required this.size});

  @override
  State<_FloatingEmoji> createState() => _FloatingEmojiState();
}

class _FloatingEmojiState extends State<_FloatingEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2 + math.Random().nextInt(2)),
      vsync: this,
    )..repeat(reverse: true);
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
        return Transform.translate(
          offset: Offset(0, math.sin(_controller.value * math.pi * 2) * 10),
          child: Opacity(
            opacity: 0.3 + (_controller.value * 0.3),
            child: Text(
              widget.emoji,
              style: TextStyle(fontSize: widget.size),
            ),
          ),
        );
      },
    );
  }
}

class KawaiiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  const KawaiiCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFFFD4E5),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB5D6).withValues(alpha: 0.15),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class KawaiiButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isLoading;

  const KawaiiButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<KawaiiButton> createState() => _KawaiiButtonState();
}

class _KawaiiButtonState extends State<KawaiiButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.backgroundColor ?? const Color(0xFFFFB5D6),
                widget.backgroundColor?.withValues(alpha: 0.8) ?? const Color(0xFFFF9FC9),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: (widget.backgroundColor ?? const Color(0xFFFFB5D6)).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: widget.isLoading ? null : widget.onPressed,
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: widget.textColor ?? Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: widget.textColor ?? Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KawaiiTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const KawaiiTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, color: Color(0xFF6B5B5B)),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF0F5), Color(0xFFFFE4F5)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFFFFB5D6)),
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFFFD4E5), width: 2.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFFFD4E5), width: 2.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFFFB5D6), width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFFF9FB0), width: 2.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFFF9FB0), width: 3),
        ),
        labelStyle: const TextStyle(color: Color(0xFFB8A8A8), fontSize: 15),
        hintStyle: const TextStyle(color: Color(0xFFEFE5E5), fontSize: 14),
      ),
      validator: validator,
    );
  }
}
