
import 'user_model.dart';

// Representa el estado de la pantalla de autenticación en un momento dado.
// El ViewModel expone esto como un estado observable; la UI (widgets)
// simplemente reacciona a los cambios de estado sin lógica de negocio.

sealed class AuthState {}

class AuthIdle extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}