import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Widget que muestra estadísticas en tiempo real desde Firebase Firestore.
/// Esto demuestra que el juego está usando Firebase de forma activa.
class FirebaseStatsWidget extends StatelessWidget {
  final FirebaseFirestore firestore;

  const FirebaseStatsWidget({
    super.key,
    required this.firestore,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.collection('matches').doc('match_1').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '🔥 Firebase: No Data',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          );
        }

        final timestamp = snapshot.data!.metadata.hasPendingWrites;
        final lastModified = snapshot.data!.metadata.isFromCache;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              border: Border.all(
                color: Colors.orange,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🔥',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Firebase Connected',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (timestamp)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Tooltip(
                          message: 'Cambios pendientes de sincronizar',
                          child: SizedBox(
                            width: 8,
                            height: 8,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                if (lastModified)
                  const Text(
                    'Datos en caché local',
                    style: TextStyle(fontSize: 9, color: Colors.white54),
                  )
                else
                  const Text(
                    'Sincronizado en tiempo real',
                    style: TextStyle(fontSize: 9, color: Colors.white54),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
