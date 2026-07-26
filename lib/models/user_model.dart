
// Modelo de dominio que representa a un usuario autenticado.
// Se mapea a partir del User de Firebase, pero desacopla la capa de
// UI y ViewModel de la dependencia directa del SDK de Firebase.

class User {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  User({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });
}