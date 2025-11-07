import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Widget compacto que muestra el estado de Firebase en la esquina de la pantalla de juego.
class FirebaseStatusBadge extends StatelessWidget {
  final FirebaseFirestore firestore;
  final Alignment alignment;

  const FirebaseStatusBadge({
    super.key,
    required this.firestore,
    this.alignment = Alignment.topLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection('matches').doc('match_1').snapshots(),
        builder: (context, snapshot) {
          final isConnected =
              snapshot.connectionState == ConnectionState.active;
          final isFromCache = snapshot.data?.metadata.isFromCache ?? false;
          final hasPendingWrites =
              snapshot.data?.metadata.hasPendingWrites ?? false;

          return Tooltip(
            message: isFromCache
                ? 'Modo offline - datos en caché'
                : 'Conectado a Firebase Firestore',
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                border: Border.all(
                  color: isFromCache ? Colors.orange : Colors.green,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🔥',
                    style: TextStyle(
                      fontSize: 14,
                      color: isConnected ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isConnected
                        ? isFromCache
                            ? 'Caché'
                            : 'Sync'
                        : 'Offline',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isFromCache ? Colors.orange : Colors.green,
                    ),
                  ),
                  if (hasPendingWrites)
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.orange,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
