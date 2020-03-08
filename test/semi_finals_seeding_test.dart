import 'package:flutter_test/flutter_test.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/services/seeding/semi_finals.dart';

void main() {
  group('Semi Finals Seeding', () {
    test('seed', () {
      var teams = <Team>[
        Team(
          id: 'a',
          name: 'team one',
          currentTournament: 'asdf',
          division: Division.open,
          pointDifferential: -10,
        ),
        Team(
          id: 'b',
          name: 'team four',
          currentTournament: 'asdf',
          division: Division.open,
          pointDifferential: 5,
        ),
        Team(
          id: 'c',
          name: 'team three',
          currentTournament: 'asdf',
          division: Division.open,
          pointDifferential: 5,
        ),
        Team(
          id: 'd',
          name: 'team two',
          currentTournament: 'asdf',
          division: Division.open,
          pointDifferential: 2,
        ),
      ];

      SemiFinalsSeeding.start(teams);

      
    });
  });
}
