import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ecommerce/Navigaton/home_page.dart';
import 'package:simple_ecommerce/Onboarding/onboarding_page.dart';

import 'package:simple_ecommerce/colorcode/appcolor.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showLogin = true;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

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
      _isLoading = false;
      _formKey.currentState?.reset();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      FocusScope.of(context).unfocus();
    });
  }

  // IMPORTANT BLOCK!! COMMENT OUT LATER

  // String? _validateEmail(String? value) {
  //   if (value == null || value.trim().isEmpty) return 'Email tidak boleh kosong';
  //   if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Format email tidak valid';
  //   return null;
  // }
  //
  // String? _validatePassword(String? value) {
  //   if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
  //   if (value.length < 6) return 'Password minimal 6 karakter';
  //   return null;
  // }
  //
  // String? _validateConfirmPassword(String? value) {
  //   if (!_showLogin) {
  //     if (value == null || value.isEmpty) return 'Konfirmasi password tidak boleh kosong';
  //     if (value != _passwordController.text) return 'Password tidak cocok';
  //   }
  //   return null;
  // }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    await Future.delayed(const Duration(seconds: 1));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    Widget nextPage;
    if (!hasSeenOnboarding) {
      await prefs.setBool('hasSeenOnboarding', true);
      nextPage = const OnboardingPage();
    } else {
      nextPage = const HomePage();
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => nextPage),
      );
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        decoration: BoxDecoration(
          color: AppColors.authFormBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _showLogin ? 'Selamat Datang!' : 'Buat Akun Baru',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.authPrimaryText,
                    shadows: [
                      Shadow(
                          blurRadius: 5.0, color: Colors.black.withAlpha(100))
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _showLogin
                    ? 'Masuk untuk melanjutkan'
                    : 'Daftar dengan data dirimu',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.authSecondaryText,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                // validator: _validateEmail, // IMPORTANT!!
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                obscureText: !_isPasswordVisible,
                // validator: _validatePassword,  // IMPORTANT!!
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.authSecondaryText,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
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
                            obscureText: !_isConfirmPasswordVisible,
                            // validator: _validateConfirmPassword, // IMPORTANT!!
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.authSecondaryText,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.authAccent,
                  foregroundColor: AppColors.authButtonText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                onPressed: _isLoading ? null : _handleAuth,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black87)))
                    : Text(
                        _showLogin ? 'Login' : 'Register',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _isLoading ? null : _toggleForm,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.authSecondaryText,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  _showLogin
                      ? 'Belum punya akun? Register di sini'
                      : 'Sudah punya akun? Login di sini',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                      child:
                          Divider(thickness: 1, color: AppColors.authDivider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('ATAU',
                        style: TextStyle(
                            color: AppColors.authSecondaryText,
                            fontWeight: FontWeight.w600)),
                  ),
                  Expanded(
                      child:
                          Divider(thickness: 1, color: AppColors.authDivider)),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: _buildGoogleSignInImageButton(),
              ),
              const SizedBox(height: 20),
            ],
          ),
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
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: AppColors.authPrimaryText, fontSize: 16),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.authHintText),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
          child: Icon(icon, color: AppColors.authPrefixIcon, size: 22),
        ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 24, minHeight: 24),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.authTextFieldFill,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.authBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.authAccent, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.authError, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.authError, width: 2),
        ),
        errorStyle: TextStyle(color: AppColors.authError),
      ),
    );
  }

  Widget _buildGoogleSignInImageButton() {
    const String googleLogoAssetPath = 'asset/Asset/UI/Images/googleicon.webp';

    return Material(
      color: AppColors.googleButtonBackground,
      shape: const CircleBorder(),
      elevation: 2.0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _isLoading
            ? null
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Fitur Login Google belum diimplementasikan')),
                );
              },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            width: 28.0,
            height: 28.0,
            child: Image.asset(
              googleLogoAssetPath,
              errorBuilder: (context, error, stackTrace) {
                // print("Error loading Google icon: $error");
                return Icon(Icons.g_mobiledata,
                    color: Colors.grey[600], size: 28.0);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.authGradientStart, AppColors.authGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.9],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: Offset(_showLogin ? 1.0 : -1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeInOutCubic));
                final fadeAnimation = Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeIn));

                return FadeTransition(
                  opacity: fadeAnimation,
                  child:
                      SlideTransition(position: offsetAnimation, child: child),
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
