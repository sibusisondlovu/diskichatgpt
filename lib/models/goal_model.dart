class Goals {
  final int? home;
  final int? away;

  Goals({this.home, this.away});

  factory Goals.fromMap(Map<String, dynamic> map) {
    return Goals(
      home: map['home'],
      away: map['away'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'home': home,
      'away': away,
    };
  }
}