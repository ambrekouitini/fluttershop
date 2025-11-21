import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/kawaii_decorations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _pageFlipController;
  late Animation<double> _pageFlipAnimation;

  @override
  void initState() {
    super.initState();

    _pageFlipController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pageFlipAnimation = CurvedAnimation(
      parent: _pageFlipController,
      curve: Curves.easeInOutCubic,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _pageFlipController.forward();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageFlipController.dispose();
    super.dispose();
  }

  void _handleRegister(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Expanded(child: Text('Les mots de passe ne correspondent pas')),
              ],
            ),
            backgroundColor: const Color(0xFFFF9FB0),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
        return;
      }

      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      await authViewModel.registerWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _nameController.text.trim(),
      );

      if (!mounted) return;

      if (authViewModel.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(authViewModel.errorMessage)),
              ],
            ),
            backgroundColor: const Color(0xFFFF9FB0),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      } else if (authViewModel.isAuthenticated) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.go('/catalog');
        }
      }
    }
  }

  void _handleGoogleSignIn(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.signInWithGoogle();

    if (!mounted) return;

    if (authViewModel.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(authViewModel.errorMessage)),
            ],
          ),
          backgroundColor: const Color(0xFFFF9FB0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFBF5),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  AnimatedBuilder(
                    animation: _pageFlipAnimation,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(0.3 * (1 - _pageFlipAnimation.value)),
                        alignment: Alignment.center,
                        child: Opacity(
                          opacity: _pageFlipAnimation.value,
                          child: _buildBookContent(context),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookContent(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFFFD4E5), width: 4),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB5D6).withValues(alpha: 0.3),
              blurRadius: 40,
              spreadRadius: 5,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Opacity(
                opacity: 0.03,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCI+PHJlY3Qgd2lkdGg9IjIwMCIgaGVpZ2h0PSIyMDAiIGZpbGw9IiNmZmYiLz48Y2lyY2xlIGN4PSI1MCIgY3k9IjUwIiByPSIyIiBmaWxsPSIjZjBmMGYwIi8+PC9zdmc+'),
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Consumer<AuthViewModel>(
                    builder: (context, authViewModel, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            '✧･ﾟ: *✧･ﾟ:*',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              color: Color(0xFFFFB5D6),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Chapitre 0',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFB8A8A8),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Rejoins l\'Aventure',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFFFB5D6),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '♡ ～(つˆ 0ˆ)つ｡☆ ♡',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFFFFD4E5),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFFFE4E5),
                                width: 2.5,
                              ),
                            ),
                            child: const Text(
                              'Crée ton compte pour débuter ton histoire ! ✨\nChaque aventure commence par un premier pas...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFB8A8A8),
                                height: 1.7,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          KawaiiTextField(
                            controller: _nameController,
                            labelText: 'Nom',
                            hintText: 'Ton joli nom',
                            icon: Icons.person_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '⚠ Nom requis';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          KawaiiTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            hintText: 'ton@email.com',
                            icon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '⚠ Email requis';
                              }
                              if (!value.contains('@')) {
                                return '⚠ Format email invalide';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          KawaiiTextField(
                            controller: _passwordController,
                            labelText: 'Mot de passe',
                            hintText: '••••••••',
                            icon: Icons.lock_rounded,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFFFFB5D6),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '⚠ Mot de passe requis';
                              }
                              if (value.length < 6) {
                                return '⚠ Minimum 6 caractères';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          KawaiiTextField(
                            controller: _confirmPasswordController,
                            labelText: 'Confirmer mot de passe',
                            hintText: '••••••••',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFFFFB5D6),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '⚠ Confirmation requise';
                              }
                              if (value != _passwordController.text) {
                                return '⚠ Les mots de passe ne correspondent pas';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          KawaiiButton(
                            text: authViewModel.isLoading
                                ? 'Chargement...'
                                : 'Commencer l\'aventure',
                            icon: Icons.star_rounded,
                            onPressed: authViewModel.isLoading
                                ? null
                                : () => _handleRegister(context),
                            isLoading: authViewModel.isLoading,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 2,
                                  color: const Color(0xFFFFD4E5)
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  '♡ ou ♡',
                                  style: TextStyle(
                                    color: Color(0xFFB8A8A8),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 2,
                                  color: const Color(0xFFFFD4E5)
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFFD4E5FF),
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD4E5FF)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: authViewModel.isLoading
                                    ? null
                                    : () => _handleGoogleSignIn(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD4E5FF),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                        Icons.g_mobiledata,
                                        size: 24,
                                        color: Color(0xFF87CEEB),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Connexion avec Google',
                                      style: TextStyle(
                                        color: Color(0xFF6B5B5B),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F5),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: const Color(0xFFFFD4E5),
                                width: 2.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Déjà inscrit ? ",
                                  style: TextStyle(
                                    color: Color(0xFFB8A8A8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => context.go('/login'),
                                  child: const Text(
                                    "Connecte-toi",
                                    style: TextStyle(
                                      color: Color(0xFFFFB5D6),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
