import 'package:flutter/material.dart';
import 'admin_dashboard.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback? onLoginSuccess;

  const LoginPage({super.key, this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F1115) : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/CoffeeShop101.png',
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'COFFEE SHOP 101',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                      color: isDark
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 48),
                  const _LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AdminDashboard(
          orders: const [],
          onAdvanceStatus: (index) {},
          onExitAdmin: () => Navigator.of(context).popUntil((route) => route.isFirst),
          onPlaceOrder: (order) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your username',
            labelStyle: TextStyle(color: textMuted, fontSize: 13),
            hintStyle:
                TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
            filled: true,
            fillColor: bgSurface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
          style: TextStyle(color: textColor, fontSize: 14),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            labelStyle: TextStyle(color: textMuted, fontSize: 13),
            hintStyle:
                TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
            filled: true,
            fillColor: bgSurface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: textMuted,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          style: TextStyle(color: textColor, fontSize: 14),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _login,
            child: const Text(
              'LOGIN',
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
