
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_state.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onNavigateBackToLogin;
  final VoidCallback onRegisterSuccess;

  const RegisterScreen({
    super.key,
    required this.onNavigateBackToLogin,
    required this.onRegisterSuccess,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Error que solo le concierne a esta pantalla (contraseñas no coinciden), separado del authState que viene del ViewModel/Firebase.
  String? _localError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();
    final authState = viewModel.authState;

    if (authState is AuthSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onRegisterSuccess();
        viewModel.resetState();
      });
    }

    // Combina el error local con el de Firebase, el que exista primero.
    final String? errorMessage =
        _localError ?? (authState is AuthError ? authState.message : null);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Crear cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              ElevatedButton(
                onPressed: authState is AuthLoading
                    ? null
                    : () {
                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    setState(() {
                      _localError = 'Las contraseñas no coinciden';
                    });
                  } else {
                    setState(() => _localError = null);
                    viewModel.register(
                      _emailController.text,
                      _passwordController.text,
                    );
                  }
                },
                child: authState is AuthLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Registrarme'),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: widget.onNavigateBackToLogin,
                child: const Text('¿Ya tienes cuenta? Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}