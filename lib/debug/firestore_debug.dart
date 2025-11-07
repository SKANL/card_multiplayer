import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Simple debug page that shows the contents of the two `areas` documents
/// under `matches/match_1/areas/{area_one,area_two}`.
class FirestoreDebugPage extends StatelessWidget {
  const FirestoreDebugPage({super.key});

  Stream<DocumentSnapshot<Map<String, dynamic>>> _areaStream(String id) {
    return FirebaseFirestore.instance
        .collection('matches')
        .doc('match_1')
        .collection('areas')
        .doc(id)
        .snapshots();
  }

  Widget _buildArea(Stream<DocumentSnapshot<Map<String, dynamic>>> stream, String title) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ListTile(
            title: Text(title),
            subtitle: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return ListTile(
            title: Text(title),
            subtitle: const Text('Cargando...'),
          );
        }

        final data = snapshot.data!.data();
        if (data == null) {
          return ListTile(
            title: Text(title),
            subtitle: const Text('Documento vacío'),
          );
        }

        final cards = data['cards'] as List<Object?>?;
        if (cards == null) {
          return ListTile(
            title: Text(title),
            subtitle: const Text('Campo "cards" no encontrado'),
          );
        }

        return ExpansionTile(
          title: Text('$title — ${cards.length} cartas'),
          children: cards.map((c) {
            return ListTile(
              title: Text(c.toString()),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore debug'),
        actions: [
          if (kDebugMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(child: Text('DEBUG', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))),
            ),
        ],
      ),
      body: ListView(
        children: [
          _buildArea(_areaStream('area_one'), 'Area One'),
          const Divider(),
          _buildArea(_areaStream('area_two'), 'Area Two'),
        ],
      ),
    );
  }
}
