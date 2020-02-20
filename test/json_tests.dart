import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pond_hockey/enums/game_status.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('JSON Game tests', () {
    test('toJson', () {
      final test = {
        'id': '1',
        'status': "Not started",
        'teamOne': {'1': 2},
        'teamTwo': {
          '1': 2,
        },
        'tournament': '/tournaments/LORQyVSHgMkChOecIj3A',
        'type': 'Closing'
      };
      final game = Game(
        id: '1',
        status: GameStatus.notStarted,
        teamOne: {
          '1': 2,
        },
        teamTwo: {
          '1': 2,
        },
        tournament:
            Firestore.instance.document('/tournaments/LORQyVSHgMkChOecIj3A'),
        type: GameType.closing,
      );
      expect(game.toJson(), jsonEncode(test));
    });
  });
}
