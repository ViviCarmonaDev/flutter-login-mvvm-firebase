# Configuración de Firebase

Esta guía explica cómo configurar tu propio proyecto de Firebase para correr la app
localmente.

## 1. Crear (o reutilizar) el proyecto en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/).
2. Puedes crear un proyecto nuevo, o agregar esta app a un proyecto de Firebase
   existente (por ejemplo, el mismo usado en la versión de Kotlin).

## 2. Registrar la app Android

1. Dentro del proyecto, clic en el ícono de Android.
2. **Package name**: debe coincidir exactamente con el applicationId definido en
   android/app/build.gradle.kts.

   > Si ya tienes otra app Android registrada en el mismo proyecto de Firebase (por
   > ejemplo, la versión Kotlin), necesitas un package name **distinto** para esta
   > app de Flutter, ya que Firebase no permite duplicados dentro de un mismo proyecto.

3. Descarga el archivo **`google-services.json`**.
4. Colócalo en: `android/app/google-services.json`.

> Este archivo está en `.gitignore` a propósito: cada persona que clone el
> repositorio debe usar su propio proyecto de Firebase.

## 3. Habilitar los métodos de autenticación

En **Authentication** → **Sign-in method**:
1. Habilita **Correo electrónico/contraseña**.
2. Habilita **Google**.

## 4. Agregar la huella digital SHA-1

```bash
cd android
./gradlew signingReport
```

Copia el valor de SHA1 bajo Variant: debug, y agrégalo en Firebase Console →
**Configuración del proyecto** → **Tus apps** → **Agregar huella digital**.

## 5. Dependencias necesarias del proyecto

En `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^4.1.1
  firebase_auth: ^6.1.0
  google_sign_in: ^7.2.0
  provider: ^6.1.5
```

O instálalas directamente con:
```bash
flutter pub add firebase_core firebase_auth google_sign_in provider
```

## 6. Gradle: aplicar el plugin de Google Services

En `android/build.gradle.kts` (raíz de la carpeta `android/`), como **primer bloque**
del archivo:
```kotlin
plugins {
    id("com.google.gms.google-services") version "4.4.2" apply false
}
```

En `android/app/build.gradle.kts`, dentro de su bloque `plugins { }` existente:
```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

## 7. Inicialización en código

A diferencia de Android nativo (donde el plugin de Gradle es suficiente), en Flutter
Firebase debe inicializarse explícitamente antes de correr la app, en `lib/main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GoogleSignIn.instance.initialize();
  runApp(const MyApp());
}
```