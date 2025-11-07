import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/app_gradients.dart';
import '../firebase_stats/firebase_game_state_widget.dart';

/// Pantalla de debug que muestra datos en tiempo real desde Firebase.
class FirebaseDebugScreen extends StatelessWidget {
  const FirebaseDebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirebaseFirestore>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 Firebase Debug'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppGradients.debugGradient),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.debugGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información de la base de datos
              _buildInfoCard(
                title: 'Información de Firebase',
                children: [
                  _buildInfoRow('Proyecto', 'multyplay-ef1e9'),
                  _buildInfoRow('Colección', 'matches'),
                  _buildInfoRow('Documento', 'match_1'),
                ],
              ),
              const SizedBox(height: 20),

              // Estado del juego en tiempo real
              _buildSectionTitle('Estado del Juego en Tiempo Real'),
              const SizedBox(height: 12),
              FirebaseGameStateWidget(firestore: firestore),
              const SizedBox(height: 20),

              // Estadísticas de sincronización
              _buildSyncStatsCard(firestore),
              const SizedBox(height: 20),

              // Información técnica
              _buildInfoCard(
                title: 'Información Técnica',
                children: [
                  _buildInfoRow('Biblioteca', 'cloud_firestore'),
                  _buildInfoRow('Tipo de Datos', 'Firestore Collections'),
                  _buildInfoRow('Modo Sync', 'Real-time Listeners'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        border: Border.all(
          color: Colors.blue,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncStatsCard(FirebaseFirestore firestore) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.collection('matches').doc('match_1').snapshots(),
      builder: (context, snapshot) {
        final isFromCache = snapshot.data?.metadata.isFromCache ?? false;
        final hasPendingWrites =
            snapshot.data?.metadata.hasPendingWrites ?? false;
        final now = DateTime.now();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            border: Border.all(
              color: Colors.green,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estadísticas de Sincronización',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isFromCache ? Colors.orange : Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isFromCache
                        ? 'Datos desde caché local'
                        : 'Conectado a Firebase',
                    style: TextStyle(
                      fontSize: 12,
                      color: isFromCache ? Colors.orange : Colors.green,
                    ),
                  ),
                ],
              ),
              if (hasPendingWrites)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Sincronizando cambios...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Última actualización: ${now.hour}:${now.minute}:${now.second}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
