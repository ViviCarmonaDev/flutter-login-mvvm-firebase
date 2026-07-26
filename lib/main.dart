import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'repositories/auth_repository.dart';
import 'repositories/firebase_auth_repository.dart';
import 'viewmodels/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        home: const Scaffold(
          body: Center(
            child: Text('Firebase conectado correctamente'),
          ),
        ),
      ),
    );
  }
}

