# 🔥 Arquitectura de Firebase en el Juego

## Flujo de Datos

```
Firebase Firestore Cloud
        ↓
        ↓ (Real-time Listeners via StreamBuilder)
        ↓
┌─────────────────────────────────┐
│   FirebaseFirestore Instance    │
│   (Provider en main.dart)       │
└─────────────────────────────────┘
        ↓
        ├─→ FirestoreController (Sincronización bidireccional)
        │   ├─→ Local state (BoardState)
        │   └─→ Firestore collections
        │
        └─→ Widgets de Estadísticas
            ├─→ FirebaseStatsWidget (Menú Principal)
            ├─→ FirebaseGameStateWidget (Pantalla Debug)
            ├─→ FirebaseStatusBadge (Durante el Juego)
            └─→ FirebaseDebugScreen (Pantalla Completa Debug)
```

## Estructura del Proyecto

```
lib/
├── main.dart
│   └── Inicializa Firebase y proporciona FirebaseFirestore via Provider
│
├── firebase_stats/ ⭐ NUEVO
│   ├── firebase_stats_widget.dart
│   │   └── Widget para menú principal
│   ├── firebase_game_state_widget.dart
│   │   └── Widget para mostrar estado del juego
│   ├── firebase_status_badge.dart
│   │   └── Badge compacto durante el juego
│   ├── firebase_debug_screen.dart
│   │   └── Pantalla de debug completa
│   ├── README.md
│   ├── USAGE_EXAMPLES.md
│   └── ARCHITECTURE.md (este archivo)
│
├── main_menu/
│   └── main_menu_screen.dart (modificado)
│       └── Incluye FirebaseStatsWidget
│
├── play_session/
│   └── play_session_screen.dart (modificado)
│       └── Incluye FirebaseStatusBadge
│
├── multiplayer/
│   └── firestore_controller.dart
│       └── Sincronización bidireccional
│
├── game_internals/
│   └── board_state.dart
│       └── Estado local del juego
│
└── router.dart (modificado)
    └── Nueva ruta /firebase-debug
```

## Flujo de Sincronización

### 1️⃣ Local → Cloud

```
Player moves card
        ↓
BoardState.areaOne.update()
        ↓
areaOne.playerChanges emit event
        ↓
FirestoreController listens
        ↓
_updateFirestoreFromLocalAreaOne()
        ↓
Firestore: matches/match_1/areas/area_one updated
        ↓
Other widgets listen to changes
```

### 2️⃣ Cloud → Local

```
Remote changes in Firestore
        ↓
_areaOneRef.snapshots() emit event
        ↓
FirestoreController listens
        ↓
_updateLocalFromFirestore()
        ↓
BoardState.areaOne updated
        ↓
Widgets rebuilding automatically
```

### 3️⃣ Visualización

```
Firebase Data
        ↓
StreamBuilder snapshots()
        ↓
Widget rebuild
        ↓
┌─────────────────────────────────┐
│ FirebaseStatsWidget             │ (Menú Principal)
│ FirebaseGameStateWidget         │ (Debug)
│ FirebaseStatusBadge             │ (Juego)
│ FirebaseDebugScreen             │ (Debug Completo)
└─────────────────────────────────┘
        ↓
User sees real-time data
```

## Componentes Clave

### FirebaseStatsWidget
- **Ubicación**: Menú Principal
- **Datos**: Estado de conexión
- **Actualización**: Cada cambio en match_1
- **Performance**: Lightweight

### FirebaseGameStateWidget
- **Ubicación**: Pantalla Debug
- **Datos**: Contenido de area_one y area_two
- **Actualización**: Cambios en tiempo real
- **Performance**: Múltiples streams (una por área)

### FirebaseStatusBadge
- **Ubicación**: Pantalla de Juego (esquina)
- **Datos**: Estado compacto
- **Actualización**: Cambios en match_1
- **Performance**: Ultra lightweight

### FirebaseDebugScreen
- **Ubicación**: Ruta `/firebase-debug`
- **Datos**: Información completa de Firebase
- **Actualización**: En tiempo real
- **Performance**: Visible solo en debug

## Datos que Se Sincronizan

```
/matches/match_1/
├── areas/
│   ├── area_one/
│   │   └── cards: [
│   │       {
│   │         "suit": "♠",
│   │         "value": "A"
│   │       },
│   │       ...
│   │     ]
│   └── area_two/
│       └── cards: [...]
```

## Estados Mostrados

### Conexión
- 🟢 **Conectado**: Datos en tiempo real
- 🟠 **Caché**: Modo offline
- 🔴 **Desconectado**: Sin conexión
- ⚪ **Cargando**: Esperando datos

### Sincronización
- ✅ **Sincronizado**: Todo actualizado
- ⏳ **Sincronizando**: Hay cambios pendientes
- ⚠️ **Conflicto**: Problema de sincronización

## Integración con Provider

```dart
// En main.dart
runApp(
  Provider.value(
    value: FirebaseFirestore.instance,
    child: MyApp()
  )
);

// En cualquier widget
final firestore = Provider.of<FirebaseFirestore>(context);
// o
final firestore = context.read<FirebaseFirestore>();
```

## Flujo de Navegación

```
MainMenuScreen
├── FirebaseStatsWidget (muestra estado)
├── [Settings]
├── [Play]
│   └── PlaySessionScreen
│       └── FirebaseStatusBadge (esquina)
└── [Debug] (solo modo debug)
    ├── FirestoreDebugPage (original)
    └── [Firebase Debug] ⭐ NUEVO
        └── FirebaseDebugScreen
            └── FirebaseGameStateWidget
```

## Performance

| Widget | Streams | Updates | CPU | Memory |
|--------|---------|---------|-----|--------|
| FirebaseStatsWidget | 1 | On change | Low | Low |
| FirebaseGameStateWidget | 2 | On change | Low | Medium |
| FirebaseStatusBadge | 1 | On change | Very Low | Very Low |
| FirebaseDebugScreen | 3 | On change | Low | Medium |

## Offline Support

- ✅ Firestore caché automático
- ✅ Datos legibles en modo offline
- ✅ Cambios se sincronizarán cuando vuelva conexión
- ✅ Indicador visual de estado

## Security

- ✅ Usa reglas de Firestore del proyecto
- ✅ Datos solo lectura en debug
- ✅ Sin API keys expuestas
- ✅ Credenciales en firebase_options.dart

## Debugging

Para ver logs de Firestore:
```dart
import 'package:logging/logging.dart';

Logger.root.level = Level.FINE;
Logger.root.onRecord.listen((record) {
  print('${record.level.name}: ${record.message}');
});
```

## Próximas Optimizaciones

- [ ] Agregar paginación para muchas cartas
- [ ] Cacheo inteligente de datos
- [ ] Indicadores de latencia de red
- [ ] Animaciones de sincronización
- [ ] Estadísticas de uso de Firestore
- [ ] Offline mode mejorado

## Referencias

- [Firebase Firestore Docs](https://firebase.flutter.dev/docs/firestore/usage)
- [Provider Package](https://pub.dev/packages/provider)
- [Flutter StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html)
