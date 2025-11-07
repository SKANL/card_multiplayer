# 🔥 Firebase Integration en Card Game

Este documento describe cómo se ha integrado Firebase Firestore en el juego de cartas para mostrar datos en tiempo real.

## Archivos Creados

### 1. **firebase_stats_widget.dart**
Widget que muestra el estado de conexión de Firebase en la pantalla principal.

**Características:**
- Indicador visual de conexión a Firebase
- Muestra si los datos están sincronizados o en caché local
- Animación de carga cuando se conecta a la base de datos
- Estado de sincronización de cambios

**Ubicación:** `lib/firebase_stats/firebase_stats_widget.dart`

**Uso:**
```dart
FirebaseStatsWidget(firestore: firestore)
```

### 2. **firebase_game_state_widget.dart**
Widget que muestra el estado detallado del juego desde Firestore.

**Características:**
- Visualiza las cartas de ambas áreas (Area One y Area Two) en tiempo real
- Muestra el número de cartas en cada área
- Indica el estado de caché vs. sincronización en vivo
- Muestra animación de sincronización de cambios
- Visualiza las cartas individuales con su palo y valor

**Ubicación:** `lib/firebase_stats/firebase_game_state_widget.dart`

**Uso:**
```dart
FirebaseGameStateWidget(firestore: firestore)
```

### 3. **firebase_status_badge.dart**
Badge compacto que se muestra en la esquina de la pantalla de juego.

**Características:**
- Indicador visual pequeño del estado de Firebase
- Muestra si está en modo offline/caché, sincronización, etc.
- Se puede posicionar en cualquier esquina
- Tooltip informativo al pasar el mouse

**Ubicación:** `lib/firebase_stats/firebase_status_badge.dart`

**Uso:**
```dart
FirebaseStatusBadge(
  firestore: firestore,
  alignment: Alignment.topRight,
)
```

### 4. **firebase_debug_screen.dart**
Pantalla completa de debug que muestra información detallada de Firebase.

**Características:**
- Información del proyecto Firebase
- Estado detallado del juego en tiempo real
- Estadísticas de sincronización
- Información técnica de Firestore
- Solo disponible en modo debug

**Ubicación:** `lib/firebase_stats/firebase_debug_screen.dart`

**Acceso:** En modo debug, navega a `/firebase-debug`

## Archivos Modificados

### 1. **main_menu/main_menu_screen.dart**
Se agregó el `FirebaseStatsWidget` para mostrar el estado de Firebase en el menú principal.

**Cambios:**
- Import de `cloud_firestore` y `FirebaseStatsWidget`
- Lectura de instancia de Firestore desde Provider
- Widget agregado en el menu area

### 2. **play_session/play_session_screen.dart**
Se agregó el `FirebaseStatusBadge` para mostrar el estado de Firebase durante el juego.

**Cambios:**
- Import de `FirebaseStatusBadge`
- Lectura de instancia de Firestore
- Badge agregado en la Stack del juego

### 3. **router.dart**
Se agregó la ruta `/firebase-debug` para acceder a la pantalla de debug.

**Cambios:**
- Import de `FirebaseDebugScreen`
- Nueva ruta en el router (solo en modo debug)

## Estructura de Firestore

El juego utiliza la siguiente estructura en Firestore:

```
/matches
  /match_1
    /areas
      /area_one
        cards: [
          { suit: "♠", value: "A" },
          { suit: "♥", value: "K" },
          ...
        ]
      /area_two
        cards: [
          { suit: "♦", value: "Q" },
          { suit: "♣", value: "10" },
          ...
        ]
```

## Características de Firebase Mostradas

### 1. **Real-time Listeners**
El juego usa `StreamBuilder` con `snapshots()` para mantener una conexión activa a Firestore.

### 2. **Metadata de Sincronización**
Se muestra información de:
- `isFromCache`: Indica si los datos están en caché local
- `hasPendingWrites`: Muestra si hay cambios pendientes de sincronizar

### 3. **Sincronización Bidireccional**
- El `FirestoreController` sincroniza cambios locales con Firestore
- Los cambios remotos se reflejan en el juego en tiempo real

### 4. **Indicadores Visuales**
- 🔥 Emoji de fuego para identificar Firebase
- ⚡ Icono de rayo para indicar sincronización en vivo
- 📦 Icono de paquete para indicar modo caché
- Bordes de colores (verde=conectado, naranja=caché, rojo=offline)

## Cómo Usarlo

### En el Menú Principal
El widget `FirebaseStatsWidget` está visible en la pantalla principal y muestra el estado de conexión a Firebase.

### Durante el Juego
El badge `FirebaseStatusBadge` aparece en la esquina superior derecha durante el juego.

### Pantalla de Debug
En modo debug, presiona el botón "Debug" en el menú principal para acceder a opciones adicionales.

Luego puedes navegar a la pantalla de Firebase Debug para ver información detallada de Firestore.

## Integración con el Código Existente

El `FirebaseFirestore.instance` se proporciona a través de Provider en `main.dart`:

```dart
runApp(
  Provider.value(
    value: FirebaseFirestore.instance,
    child: MyApp()
  )
);
```

Esto permite que cualquier widget acceda a la instancia de Firestore:

```dart
final firestore = Provider.of<FirebaseFirestore>(context);
```

## Notas Técnicas

1. **Conexión de Baja Latencia**: Los listeners de Firestore se actualizan en tiempo real
2. **Caché Local**: Firestore mantiene automáticamente los datos en caché para modo offline
3. **Sincronización Automática**: Los cambios se sincronizan automáticamente cuando hay conexión
4. **Estado Visible**: Los usuarios pueden ver claramente que el juego usa Firebase

## Próximas Mejoras

- [ ] Mostrar información de usuarios conectados
- [ ] Estadísticas de latencia de red
- [ ] Historial de cambios recientes
- [ ] Información de almacenamiento utilizado
- [ ] Notificaciones de eventos de Firestore
