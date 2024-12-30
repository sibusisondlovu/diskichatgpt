class League {
  final String? country;
  final String? flag;
  final int? id;
  final String? logo;
  final String? name;
  final String? round;
  final int? season;

  League({
    this.country,
    this.flag,
    this.id,
    this.logo,
    this.name,
    this.round,
    this.season,
  });

  factory League.fromMap(Map<String, dynamic> map) {
    return League(
      country: map['country'],
      flag: map['flag'],
      id: map['id'],
      logo: map['logo'],
      name: map['name'],
      round: map['round'],
      season: map['season'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'flag': flag,
      'id': id,
      'logo': logo,
      'name': name,
      'round': round,
      'season': season,
    };
  }
}