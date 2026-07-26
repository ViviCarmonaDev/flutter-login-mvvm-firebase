
import 'package:flutter/foundation.dart';
import '../models/auth_state.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

// ViewModel para las pantallas de Login y Registro.
// Extiende ChangeNotifier: cada vez que llamamos a notifyListeners(),
// todos los widgets "suscritos" (mediante Provider/Consumer) se redibujan automáticamente con el nuevo estado.

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  // A diferencia de StateFlow (que expone un stream observable), aquí simplemente guarda el estado en una variable privada normal,
  // y notifica  manualmente cuando cambia.

  AuthState _authState = AuthIdle();
  AuthState get authState => _authState;

  User? get currentUser => _authRepository.currentUser;

  Future<void> signIn(String email, String password) async {
    if (!_isInputValid(email, password)) return;

    _updateState(AuthLoading());

    try {
      final user = await _authRepository.signInWithEmail(email, password);
      _updateState(AuthSuccess(user));
    } catch (e) {
      _updateState(AuthError(_extractMessage(e)));
    }
  }

  Future<void> register(String email, String password) async {
    if (!_isInputValid(email, password)) return;

    _updateState(AuthLoading());

    try {
      final user = await _authRepository.registerWithEmail(email, password);
      _updateState(AuthSuccess(user));
    } catch (e) {
      _updateState(AuthError(_extractMessage(e)));
    }
  }

  Future<void> signInWithGoogle() async {
    _updateState(AuthLoading());

    try {
      final user = await _authRepository.signInWithGoogle();
      _updateState(AuthSuccess(user));
    } catch (e) {
      _updateState(AuthError(_extractMessage(e)));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _updateState(AuthIdle());
  }

  void resetState() {
    _updateState(AuthIdle());
  }

  bool _isInputValid(String email, String password) {
    if (email.trim().isEmpty || password.isEmpty) {
      _updateState(AuthError('Correo y contraseña son obligatorios'));
      return false;
    }
    if (password.length < 6) {
      _updateState(AuthError('La contraseña debe tener al menos 6 caracteres'));
      return false;
    }
    return true;
  }

  // Nuestra propia excepción, lanzada por el repository, viene envuelta
  // en un Exception genérico de Dart. Esto extrae el texto real del mensaje.

  String _extractMessage(Object error) {
    final text = error.toString();

    // Exception.toString() devuelve algo como "Exception: mensaje real".
    // Quita ese prefijo para mostrar solo el mensaje limpio.
    return text.replaceFirst('Exception: ', '');
  }

  void _updateState(AuthState newState) {
    _authState = newState;
    notifyListeners();
  }
}