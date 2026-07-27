
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart' as model;
import 'auth_repository.dart';

// Implementación concreta de AuthRepository respaldada por Firebase Authentication.
// Esta clase es la ÚNICA parte de la app que habla directamente con los SDKs de Firebase y Google Sign-In.

class FirebaseAuthRepository implements AuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({firebase.FirebaseAuth? firebaseAuth,})
      : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;

  @override
  model.User? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return _toDomainUser(user);
  }

  @override
  Future<model.User> signInWithEmail(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = result.user;
      if (firebaseUser == null) {
        throw Exception('No se pudo obtener el usuario');
      }
      return _toDomainUser(firebaseUser);
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception(_traducirError(e));
    }
  }

  @override
  Future<model.User> registerWithEmail(String email, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = result.user;
      if (firebaseUser == null) {
        throw Exception('No se pudo crear el usuario');
      }
      return _toDomainUser(firebaseUser);
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception(_traducirError(e));
    }
  }

  @override
  Future<model.User> signInWithGoogle() async {
    try {
      final googleAccount = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleAccount.authentication;
      final credential = firebase.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final result = await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = result.user;
      if (firebaseUser == null) {
        throw Exception('No se pudo autenticar con Google');
      }
      return _toDomainUser(firebaseUser);
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception(_traducirError(e));
    } catch (e) {
      throw Exception('Inicio de sesión con Google cancelado');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn.instance.signOut();
  }

  // Traduce las excepciones específicas de Firebase Auth a mensajes en español para el usuario final.

  String _traducirError(firebase.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No existe una cuenta con este correo';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este correo';
      case 'weak-password':
        return 'La contraseña es demasiado débil';
      case 'invalid-email':
        return 'El formato del correo no es válido';
      default:
        return 'Ocurrió un error, intenta de nuevo';
    }
  }

  // Traduce un User de Firebase hacia nuestro modelo de dominio propio.
  model.User _toDomainUser(firebase.User firebaseUser) {
    return model.User(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }
}