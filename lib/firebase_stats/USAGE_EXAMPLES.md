# 📊 Ejemplos de Uso - Firebase Stats Widgets

## Ejemplo 1: Usar el Firebase Stats Widget en tu pantalla

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_stats/firebase_stats_widget.dart';

class MyCustomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirebaseFirestore>(context, listen: false);

    return Scaffold(
      body: Column(
        children: [
          // Tu contenido aquí
          FirebaseStatsWidget(firestore: firestore),
        ],
      ),
    );
  }
}
```

## Ejemplo 2: Usar el Firebase Game State Widget

```dart
import 'firebase_stats/firebase_game_state_widget.dart';

class GameStatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirebaseFirestore>(context, listen: false);

    return Scaffold(
      body: FirebaseGameStateWidget(firestore: firestore),
    );
  }
}
```

## Ejemplo 3: Usar el Firebase Status Badge en diferentes posiciones

```dart
import 'firebase_stats/firebase_status_badge.dart';

class MyGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirebaseFirestore>(context, listen: false);

    return Stack(
      children: [
        // Tu juego aquí
        
        // Badge en la esquina superior derecha (predeterminado)
        FirebaseStatusBadge(firestore: firestore),
        
        // O badge en la esquina superior izquierda
        FirebaseStatusBadge(
          firestore: firestore,
          alignment: Alignment.topLeft,
        ),
        
        // O en la esquina inferior derecha
        FirebaseStatusBadge(
          firestore: firestore,
          alignment: Alignment.bottomRight,
        ),
      ],
    );
  }
}
```

## Qué Muestran los Widgets

### FirebaseStatsWidget
```
Indicador visual:
🔥 Firebase Connected
Sincronizado en tiempo real
```

Con cambios pendientes:
```
🔥 Firebase Connected
Cambios pendientes de sincronizar (animación)
```

### FirebaseGameStateWidget
```
Area One
Cartas: 5
⚡ En Vivo

[A♠] [K♥] [Q♦] [J♣] [10♠]
```

### FirebaseStatusBadge
```
┌─────────────┐
│ 🔥 Sync     │  (cuando está sincronizando)
└─────────────┘
```

```
┌─────────────┐
│ 🔥 Caché ⏳  │  (cuando hay cambios pendientes)
└─────────────┘
```

## Información Mostrada en Cada Widget

### FirebaseStatsWidget
- ✅ Estado de conexión a Firebase
- ✅ Indicador de sincronización
- ✅ Estado de cambios pendientes
- ✅ Animación de carga

### FirebaseGameStateWidget
- ✅ Nombre del área
- ✅ Cantidad de cartas
- ✅ Estado de cache vs. en vivo
- ✅ Animación de sincronización
- ✅ Cartas individuales (palo y valor)

### FirebaseStatusBadge
- ✅ Estado compacto de Firebase
- ✅ Sincronización pendiente
- ✅ Tooltip informativo
- ✅ Indicador visual de conexión

### FirebaseDebugScreen (ruta: /firebase-debug)
- ✅ Información del proyecto Firebase
- ✅ Estado detallado del juego
- ✅ Estadísticas de sincronización
- ✅ Estado de cache local
- ✅ Información técnica

## Cómo Acceder a la Pantalla de Debug

1. En modo debug, en el menú principal verás un botón "Debug"
2. Presiona "Debug"
3. Verás la pantalla de debug original
4. Para ver la pantalla de Firebase Debug, modifica la URL a `/firebase-debug`

O simplemente navega directamente usando:
```dart
GoRouter.of(context).go('/firebase-debug');
```

## Color Coding

- 🟢 **Verde**: Conectado y sincronizado normalmente
- 🟠 **Naranja**: Modo caché o cambios pendientes
- 🔴 **Rojo**: Offline o desconectado
- 🔵 **Azul**: Información

## Estructura de Datos Mostrada

### Cards en Firestore
```json
{
  "suit": "♠",      // Palo de la carta
  "value": "A"      // Valor (A, K, Q, J, 2-10)
}
```

### Areas
```json
{
  "area_one": {
    "cards": [...]  // Lista de cartas
  },
  "area_two": {
    "cards": [...]  // Lista de cartas
  }
}
```

## Performance

- Los widgets usan `StreamBuilder` para actualizaciones eficientes
- Solo se reconstruyen cuando los datos cambian
- La carga de datos es asincrónica
- Soporta offline-first con caché local

## Troubleshooting

### El widget no muestra datos
- Verifica que Firestore esté inicializado en `main.dart`
- Verifica que la colección `matches/match_1` exista en Firestore
- Comprueba que tienes permisos de lectura en tu reglas de Firestore

### La conexión siempre muestra caché
- Es normal en modo offline
- Verifica tu conexión de internet
- Revisa la consola de Firestore en Firebase Console

### Los datos no se actualizan
- Los listeners están activos, los datos deberían actualizarse automáticamente
- Si no se actualiza, verifica que `FirestoreController` esté activo
- Revisa los logs de Firestore para ver si hay errores
