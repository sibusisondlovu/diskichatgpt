import 'team_model.dart';

class Teams {
  final Team? home;
  final Team? away;

  Teams({this.home, this.away});

  factory Teams.fromMap(Map<String, dynamic> map) {
    return Teams(
      home: map['home'] != null ? Team.fromMap(map['home']) : null,
      away: map['away'] != null ? Team.fromMap(map['away']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'home': home?.toMap(),
      'away': away?.toMap(),
    };
  }
}