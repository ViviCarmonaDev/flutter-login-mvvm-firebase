
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_state.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onNavigateToRegister;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.onNavigateToRegister,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Los "controllers" son la forma en Flutter de leer/escribir el valor
  // de un campo de texto (equivalente a "var email by remember { mutableStateOf("") }").
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Es obligatorio "liberar" los controllers cuando el widget se destruye, para evitar fugas de memoria
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // "watch" hace que este widget se redibuje automáticamente cada vez que el AuthViewModel llame a notifyListeners().
    final viewModel = context.watch<AuthViewModel>();
    final authState = viewModel.authState;

    // Si el login fue exitoso, navega. Esto se ejecuta en cada
    // redibujado, así que verifica el tipo antes de actuar.
    if (authState is AuthSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onLoginSuccess();
        viewModel.resetState();
      });
    }

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
                'Iniciar sesión',
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
                obscureText: true, // Oculta la contraseña, como PasswordVisualTransformation.
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              if (authState is AuthError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    authState.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              ElevatedButton(
                onPressed: authState is AuthLoading
                    ? null // "null" en onPressed deshabilita el botón.
                    : () => viewModel.signIn(
                  _emailController.text,
                  _passwordController.text,
                ),
                child: authState is AuthLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Entrar'),
              ),
              const SizedBox(height: 8),

              OutlinedButton(
                onPressed: () => viewModel.signInWithGoogle(),
                child: const Text('Continuar con Google'),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: widget.onNavigateToRegister,
                child: const Text('¿No tienes cuenta? Regístrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}