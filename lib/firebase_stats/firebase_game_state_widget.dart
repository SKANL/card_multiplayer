import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Widget que muestra el estado detallado de las áreas del juego desde Firebase.
class FirebaseGameStateWidget extends StatelessWidget {
  final FirebaseFirestore firestore;

  const FirebaseGameStateWidget({
    super.key,
    required this.firestore,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.collection('matches').doc('match_1').snapshots(),
      builder: (context, matchSnapshot) {
        if (matchSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildAreaCard(
                context,
                'Area One',
                firestore,
                'area_one',
              ),
              const SizedBox(height: 12),
              _buildAreaCard(
                context,
                'Area Two',
                firestore,
                'area_two',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        height: 40,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _buildAreaCard(
    BuildContext context,
    String title,
    FirebaseFirestore firestore,
    String areaId,
  ) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore
          .collection('matches')
          .doc('match_1')
          .collection('areas')
          .doc(areaId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildCardTemplate(
            title: title,
            children: [
              const SizedBox(
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ],
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return _buildCardTemplate(
            title: title,
            children: [
              const Text(
                'Sin datos',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final cards = data?['cards'] as List<dynamic>? ?? [];
        final isFromCache = snapshot.data!.metadata.isFromCache;
        final hasPendingWrites = snapshot.data!.metadata.hasPendingWrites;

        return _buildCardTemplate(
          title: title,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cartas: ${cards.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Tooltip(
                  message: isFromCache
                      ? 'Datos en caché local'
                      : 'Sincronizado en tiempo real',
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isFromCache
                          ? Colors.amber.withOpacity(0.3)
                          : Colors.green.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      isFromCache ? '📦 Caché' : '⚡ En Vivo',
                      style: TextStyle(
                        fontSize: 10,
                        color: isFromCache ? Colors.amber : Colors.green,
                      ),
                    ),
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
                    const SizedBox(width: 6),
                    const Text(
                      'Sincronizando...',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            if (cards.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index] as Map<String, dynamic>?;
                      final suit = card?['suit'] ?? '?';
                      final value = card?['value'] ?? '?';

                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.3),
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              '$value$suit',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCardTemplate({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        border: Border.all(
          color: Colors.blue,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}
