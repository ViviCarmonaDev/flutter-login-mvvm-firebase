# Flujo de autenticación

## Inicio de sesión con correo y contraseña

1. El usuario escribe su correo y contraseña en `LoginScreen`, usando dos
   `TextEditingController`.

2. Al presionar "Entrar", se llama a `viewModel.signIn(email, password)`.

3. `AuthViewModel` valida que los campos no estén vacíos y que la contraseña tenga
   al menos 6 caracteres. Si falla, actualiza el estado a `AuthError` de inmediato,
   sin llamar a Firebase.

4. Si la validación pasa, actualiza el estado a `AuthLoading` y llama a
   `authRepository.signInWithEmail(email, password)`, esperando el resultado con
   `await` (no requiere abrir una corrutina como en Kotlin, ya que el método ya es
   `Future<User>` por definición).

5. `FirebaseAuthRepository` llama a `_firebaseAuth.signInWithEmailAndPassword(...)`:
    - Si es exitoso, convierte el `User` de Firebase a un `User` propio y lo retorna.
    - Si falla, atrapa la excepción (`FirebaseAuthException`), la traduce a un
      mensaje en español según su código (`e.code`), y la relanza como `Exception`.
   
6. `AuthViewModel` captura el resultado con `try/catch`, actualizando el estado a
   `AuthSuccess` o `AuthError` según corresponda, y llama a `notifyListeners()`.

7. `LoginScreen`, que está observando el ViewModel mediante `context.watch()`, se
   redibuja automáticamente reflejando el nuevo estado.

## Inicio de sesión con Google

Desde `google_sign_in` v7, el flujo cambió respecto a versiones anteriores:

1. `GoogleSignIn.instance.authenticate()` abre la UI nativa de selección de cuenta.

2. Se obtiene el `idToken` desde `googleAccount.authentication` (ya no es asíncrono
   en esta versión).

3. Se construye una credencial con `GoogleAuthProvider.credential(idToken: ...)`.

4. Se llama a `_firebaseAuth.signInWithCredential(credential)`, igual que con el
   flujo de correo/contraseña.

> Es obligatorio llamar a **GoogleSignIn.instance.initialize()** una vez, al arrancar
> la app (en **main()**), antes de poder usar **authenticate()**.

## Registro de nuevos usuarios

Sigue el mismo flujo que el inicio de sesión, con una diferencia: RegisterScreen
valida localmente (dentro del propio StatefulWidget, usando setState) que la
contraseña y su confirmación coincidan, antes de llamar a
`viewModel.register(...)`.

## Manejo de errores

A diferencia de Android/Kotlin (donde Firebase lanza excepciones de distintas
clases), en Flutter todos los errores de autenticación llegan como una única clase
**FirebaseAuthException**, distinguible por su propiedad **.code**:

| Código de error | Mensaje mostrado |
|---|---|
| user-not-found | No existe una cuenta con este correo |
| wrong-password / invalid-credential | Correo o contraseña incorrectos |
| email-already-in-use | Ya existe una cuenta con este correo |
| weak-password | La contraseña es demasiado débil |
| invalid-email | El formato del correo no es válido |
| Cualquier otro | Ocurrió un error, intenta de nuevo |

## Navegación tras autenticación exitosa

Se usa **Navigator.of(context).pushAndRemoveUntil(...)** para ir a **HomeScreen**
eliminando el historial de Login/Registro, evitando que el botón "atrás" regrese
a una pantalla de autenticación después de haber iniciado sesión.

## Cierre de sesión

**authRepository.signOut()** cierra sesión tanto en Firebase (**_firebaseAuth.signOut()**)
como en Google (**GoogleSignIn.instance.signOut()**), y el **AuthViewModel** reinicia el
estado a **AuthIdle**.