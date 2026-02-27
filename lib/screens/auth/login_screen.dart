import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePass   = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primaryGreen, Color(0xFF004D40), AppTheme.primaryBlue],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo & Title
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_hospital, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'AFYALINK',
                    style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold,
                      color: Colors.white, letterSpacing: 3,
                    ),
                  ),
                  const Text(
                    'Digital Patient Referral & Health Record System',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 40),

                  // Login Card
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Sign In',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            const Text('Enter your credentials to continue',
                                style: TextStyle(color: Colors.grey, fontSize: 13)),
                            const SizedBox(height: 24),

                            // Email
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (v) => (v?.isEmpty ?? true) ? 'Email is required' : null,
                            ),
                            const SizedBox(height: 16),

                            // Password
                            TextFormField(
                              controller: _passwordCtrl,
                              obscureText: _obscurePass,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePass ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () => setState(() => _obscurePass = !_obscurePass),
                                ),
                              ),
                              validator: (v) => (v?.isEmpty ?? true) ? 'Password is required' : null,
                            ),
                            const SizedBox(height: 24),

                            // Error message
                            Consumer<AuthProvider>(
                              builder: (_, auth, __) => auth.error != null
                                  ? Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.red.shade200),
                                      ),
                                      child: Row(children: [
                                        const Icon(Icons.error_outline, color: Colors.red, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(auth.error!,
                                            style: const TextStyle(color: Colors.red, fontSize: 13))),
                                      ]),
                                    )
                                  : const SizedBox.shrink(),
                            ),

                            // Login Button
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) => ElevatedButton(
                                onPressed: auth.isLoading ? null : _handleLogin,
                                child: auth.isLoading
                                    ? const SizedBox(
                                        height: 20, width: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Text('Sign In'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    '© 2024 AFYALINK • Ministry of Health Kenya',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final auth    = context.read<AuthProvider>();
    final success = await auth.login(_emailCtrl.text.trim(), _passwordCtrl.text);
    if (success && mounted) {
      context.go('/dashboard');
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}
