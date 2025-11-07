// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/settings.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import '../style/app_gradients.dart';
import '../firebase_stats/firebase_stats_widget.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();
    final firestore = Provider.of<FirebaseFirestore>(context, listen: false);

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.menuGradient),
        child: ResponsiveScreen(
          squarishMainArea: Center(
            child: Transform.rotate(
              angle: -0.1,
              child: const Text(
                'Drag&Drop Cards!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 55,
                  height: 1,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
          ),
          rectangularMenuArea: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyButton(
                onPressed: () {
                  audioController.playSfx(SfxType.buttonTap);
                  GoRouter.of(context).go('/play');
                },
                child: const Text('Play'),
              ),
              _gap,
              MyButton(
                onPressed: () => GoRouter.of(context).push('/settings'),
                child: const Text('Settings'),
              ),
              _gap,
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ValueListenableBuilder<bool>(
                  valueListenable: settingsController.audioOn,
                  builder: (context, audioOn, child) {
                    return IconButton(
                      onPressed: () => settingsController.toggleAudioOn(),
                      icon: Icon(
                        audioOn ? Icons.volume_up : Icons.volume_off,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              if (kDebugMode)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: MyButton(
                    onPressed: () => GoRouter.of(context).push('/debug'),
                    child: const Text('Debug'),
                  ),
                ),
              _gap,
              // Firebase Debug Button
              MyButton(
                onPressed: () => GoRouter.of(context).push('/firebase-debug'),
                child: const Text('🔥 Firebase Stats'),
              ),
              _gap,
              // Firebase Stats Widget
              FirebaseStatsWidget(firestore: firestore),
              _gap,
            ],
          ),
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 10);
}
