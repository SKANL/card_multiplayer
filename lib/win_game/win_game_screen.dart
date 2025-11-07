// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../game_internals/score.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import '../style/app_gradients.dart';

class WinGameScreen extends StatelessWidget {
  final Score score;

  const WinGameScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.playSessionGradient),
        child: ResponsiveScreen(
          squarishMainArea: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              gap,
              const Center(
                child: Text(
                  '🎉 You won! 🎉',
                  style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 50,
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
              gap,
              Center(
                child: Text(
                  'Score: ${score.score}\n'
                  'Time: ${score.formattedTime}',
                  style: const TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          rectangularMenuArea: MyButton(
            onPressed: () {
              GoRouter.of(context).go('/');
            },
            child: const Text('Continue'),
          ),
        ),
      ),
    );
  }
}
