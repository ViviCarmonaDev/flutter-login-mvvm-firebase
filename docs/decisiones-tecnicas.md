# Decisiones técnicas

## ¿Por qué Provider en vez de Riverpod o Bloc?

Provider ofrece la curva de aprendizaje más simple para quien viene de conceptos
como **ViewModel** + **StateFlow** en Android. **ChangeNotifier** es conceptualmente
similar: un objeto que mantiene estado y notifica a sus escuchas cuando cambia.
Riverpod y Bloc son alternativas más robustas para proyectos grandes, pero
introducen más conceptos nuevos de golpe.

## ¿Por qué Navigator simple en vez de go_router?

Para el tamaño actual del proyecto (3 pantallas), **Navigator.push**/ **pop** es
suficiente y más directo de entender. **go_router** sería preferible si el proyecto
creciera con rutas anidadas, deep links, o navegación basada en URLs (como en Web).
Queda registrado como mejora futura.

## ¿Por qué una clase abstracta (**AuthRepository**) en vez de solo usar **FirebaseAuthRepository** directamente?

Mismo principio aplicado en la versión de Kotlin: desacoplar el **AuthViewModel** del
SDK de Firebase. Permite sustituir la implementación en pruebas unitarias y evita
que la lógica de presentación dependa de detalles de un proveedor específico.

## ¿Por qué **Exception** con mensajes en vez de un tipo **Result<T>** como en Kotlin?

Dart no incluye un tipo **Result<T>** en su librería estándar. Implementar uno propio
sería posible, pero se optó por seguir el patrón idiomático de Dart/Flutter:
funciones **Future<T>** que lanzan excepciones (**throw**) en caso de error, capturadas
con **try/catch** por quien las llama. Esto mantiene el código más alineado con lo
que un desarrollador Flutter esperaría encontrar.

## ¿Por qué **sealed class** para **AuthState** en vez de variables booleanas sueltas?

Mismo razonamiento que en la versión Kotlin: evita estados contradictorios o
imposibles (por ejemplo, "cargando" y "con error" al mismo tiempo). Dart 3
introdujo **sealed class**, permitiendo el mismo patrón de modelado de estado que
ya se usaba en Kotlin.

## Migración de **google_sign_in** a la v7

Durante el desarrollo, el paquete **google_sign_in** publicó una versión mayor (v7)
con cambios importantes: se eliminó el constructor **GoogleSignIn()** en favor de un
patrón singleton (**GoogleSignIn.instance**), se renombró **signIn()** a **authenticate()**,
y se requiere una llamada explícita a **initialize()** antes de usar el paquete. El
código de este proyecto ya está actualizado a esta versión.