import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleForm() {
    setState(() {
      _showLogin = !_showLogin;
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      FocusScope.of(context).unfocus();
    });
  }

  Widget _buildForm() {
    final formKey = ValueKey(_showLogin ? 'login' : 'register');

    return Container(
      key: formKey,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(51), // Diganti dari withOpacity(0.2)
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                _showLogin ? 'Selamat Datang!' : 'Buat Akun Baru',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 10.0, color: Colors.black.withAlpha(128)) // Diganti dari withOpacity(0.5)
                    ]
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _showLogin ? 'Masuk untuk melanjutkan' : 'Daftar dengan data dirimu',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[300],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            _buildTextField(
              controller: _emailController,
              hintText: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              hintText: 'Password',
              icon: Icons.lock_outline,
              obscureText: true,
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: _showLogin ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                child: !_showLogin
                    ? Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _buildTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Konfirmasi Password',
                    icon: Icons.lock_person_outlined,
                    obscureText: true,
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: Colors.tealAccent[700],
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
              onPressed: () {
                if (_showLogin) { } else {
                  if (_passwordController.text != _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password tidak cocok!'), backgroundColor: Colors.redAccent,)
                    );
                  }
                }
                FocusScope.of(context).unfocus();
              },
              child: Text(
                _showLogin ? 'Login' : 'Register',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),

            TextButton(
              onPressed: _toggleForm,
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                _showLogin
                    ? 'Belum punya akun? Register di sini'
                    : 'Sudah punya akun? Login di sini',
              ),
            ),
            const SizedBox(height: 24),

            const Row(
              children: [
                Expanded(child: Divider(thickness: 1, color: Colors.white38)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text('ATAU', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w600)),
                ),
                Expanded(child: Divider(thickness: 1, color: Colors.white38)),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Login via SSO nanti di sini',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
          child: Icon(icon, color: Colors.tealAccent[100], size: 22),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        filled: true,
        fillColor: Colors.black.withAlpha(128), // Diganti dari withOpacity(0.5)
        contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.tealAccent[700]!, width: 2.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withAlpha(51), width: 1), // Diganti dari withOpacity(0.2)
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: _showLogin ? 0.0 : 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, lerpValue, child) {
          final List<Color> loginColors = [
            const Color(0xFF0D47A1),
            const Color(0xFF00695C),
            const Color(0xFF4A148C),
            const Color(0xFF0D47A1),
          ];
          final List<Color> registerColors = [
            const Color(0xFF880E4F),
            const Color(0xFFB71C1C),
            const Color(0xFF4A0072),
            const Color(0xFF880E4F),
          ];

          List<Color> currentColors = [];
          for (int i = 0; i < loginColors.length; i++) {
            currentColors.add(Color.lerp(loginColors[i], registerColors[i], lerpValue)!);
          }

          final List<double> stops = [0.0, 0.33, 0.66, 1.0];

          return Container(
            decoration: BoxDecoration(
              gradient: SweepGradient(
                center: Alignment.center,
                colors: currentColors,
                stops: stops,
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: Offset(_showLogin ? 1.0 : -1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic));
                final fadeAnimation = Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));
                return FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(position: offsetAnimation, child: child),
                );
              },
              child: _buildForm(),
            ),
          ),
        ),
      ),
    );
  }
}