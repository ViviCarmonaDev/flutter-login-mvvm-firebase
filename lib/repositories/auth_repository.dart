
import '../models/user_model.dart';

// Contrato (clase abstracta) del repositorio de autenticación.
// El ViewModel depende únicamente de esta clase abstracta, nunca de FirebaseAuth directamente. Esto permite sustituir la implementación
// real por una falsa en pruebas unitarias, o cambiar de proveedor de backend sin modificar el ViewModel.

abstract class AuthRepository {
  User? get currentUser;

  Future<User> signInWithEmail(String email, String password);

  Future<User> registerWithEmail(String email, String password);

  Future<User> signInWithGoogle();

  Future<void> signOut();
}