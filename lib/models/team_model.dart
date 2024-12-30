class Team {
  final int? id;
  final String? logo;
  final String? name;
  final bool? winner;

  Team({this.id, this.logo, this.name, this.winner});

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      logo: map['logo'],
      name: map['name'],
      winner: map['winner'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logo': logo,
      'name': name,
      'winner': winner,
    };
  }
}