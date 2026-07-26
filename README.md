# flutter-login-mvvm-firebase
Proyecto de práctica que implementa un flujo de **inicio de sesión y registro de usuarios**
con **Firebase Authentication**, aplicando la arquitectura **MVVM** en **Flutter/Dart**.

📖 Documentación técnica completa (arquitectura, decisiones de diseño, flujo de auth):

[![Documentación en GitBook](https://img.shields.io/badge/Docs-GitBook-3884FF?style=for-the-badge&logo=gitbook&logoColor=white)](https://v-c-myproyects.gitbook.io/android-login-mvvm-firebase/)

Este proyecto es la contraparte en Flutter del proyecto original en Kotlin/Android nativo,
implementando exactamente los mismos conceptos de arquitectura (Model, Repository, ViewModel,
View) pero adaptados a las convenciones idiomáticas de este ecosistema.

📖 Proyecto hermano en Android nativo (Kotlin): [android-login-mvvm-firebase](https://github.com/ViviCarmonaDev/android-login-mvvm-firebase)

---

## ✨ Funcionalidades
- Registro de usuario con correo y contraseña
- Inicio de sesión con correo y contraseña
- Inicio de sesión con Google (Google Sign-In)
- Pantalla Home tras autenticación exitosa, con cierre de sesión
- Navegación entre Login → Registro → Home, con manejo del historial
- Validaciones locales (campos vacíos, contraseñas coincidentes, longitud mínima)
- Manejo de estados de carga y error en la UI, con mensajes traducidos al español
- Arquitectura MVVM con separación clara de capas (Model, Repository, ViewModel, View)

## 🛠️ Stack técnico
| Capa | Tecnología |
|---|---|
| Lenguaje | Dart |
| Framework | Flutter |
| Arquitectura | MVVM |
| Manejo de estado | Provider (`ChangeNotifier`) |
| Backend / Auth | Firebase Authentication (Email/Password + Google Sign-In) |
| Navegación | Navigator (push/pop) |

## 📂 Estructura del proyecto

lib/

├── models/ # Clases de datos y estados de UI (User, AuthState)

├── repositories/ # Abstracción y acceso a Firebase Auth

├── viewmodels/ # Lógica de presentación (AuthViewModel con ChangeNotifier)

├── screens/ # Widgets de cada pantalla (Login, Registro, Home)

└── main.dart # Punto de entrada, configuración de Provider y navegación


## 🚀 Cómo correr el proyecto

### 1. Clona el repositorio
```bash
git clone https://github.com/ViviCarmonaDev/flutter-login-mvvm-firebase.git
```

### 2. Instala las dependencias
```bash
flutter pub get
```

### 3. Crea tu propio proyecto de Firebase
1. Ve a [Firebase Console](https://console.firebase.google.com/) y crea un proyecto (o usa uno existente).
2. Agrega una app **Android** con el package name: `com.vivicarmonadev.loginmvvmflutter`.
3. Descarga el archivo **`google-services.json`**.
4. Colócalo en: `android/app/google-services.json`.

> ⚠️ Este archivo está en `.gitignore` a propósito: cada persona que clone el repo debe usar su propio proyecto de Firebase.

### 4. Habilita los métodos de autenticación
En Firebase Console → **Authentication** → **Sign-in method**, habilita:
- Correo electrónico/contraseña
- Google

### 5. Configura Google Sign-In
1. Agrega la huella digital SHA-1 de tu entorno de desarrollo en Firebase Console
   (**Configuración del proyecto** → **Tus apps** → **Agregar huella digital**):
```bash
   cd android && ./gradlew signingReport
```
2. Verifica que el "ID de cliente web" esté generado en **Authentication** → **Sign-in method** → **Google**.

### 6. Corre la app
```bash
flutter run
```

## 📄 Licencia

Este proyecto está bajo la licencia MIT — úsalo libremente para practicar o como base de tus propios proyectos.
