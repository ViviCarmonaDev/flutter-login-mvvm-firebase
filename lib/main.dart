import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'repositories/firebase_auth_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GoogleSignIn.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Es donde se crea la ÚNICA instancia del ViewModel para toda la app.
      // Al pasarle "FirebaseAuthRepository()" (la implementación real), el ViewModel queda conectado a Firebase de verdad.
      create: (context) => AuthViewModel(FirebaseAuthRepository()),
      child: MaterialApp(
        title: 'Login MVVM Firebase',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        // pantalla inicial es siempre login
        home: Builder(
          builder: (context) => LoginScreen(
          onNavigateToRegister: (){
            // Navigator.push agrega una pantalla nueva "encima" de la actual (como abrir una carta nueva sobre un mazo). El usuario puede
            // volver atrás con el botón físico/gesto, que llama a "pop" solo.

            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => RegisterScreen(
                        onNavigateBackToLogin: () {
                          // pop() quita la pantalla actual, regresando a la anterior.
                          Navigator.of(context).pop();
                        },
                        onRegisterSuccess: () {
                          _goToHome(context);
                        },
                    ),
                ),
            );
          },
          onLoginSuccess: () {
            _goToHome(context);
          },
          ),
        ),
      ),
    );
  }

// Navega a Home, elimina el historial anterior (Login, Registro). Esto evita que el botón "atrás" regrese a una pantalla de auth
// después de haber iniciado sesión exitosamente.

  void _goToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          onSignOut: () {
            // Quita TODAS las pantallas hasta llegar a la primera (Login),que MaterialApp reconstruye automáticamente como raíz.
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
          (route) => false, // (route) => false significa "elimina el historial anterior".
    );
  }
}




