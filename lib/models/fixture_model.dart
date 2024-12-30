import 'package:cloud_firestore/cloud_firestore.dart';

import 'goal_model.dart';
import 'league_model.dart';
import 'teams_model.dart';
import 'venue_model.dart';

class FixtureModel {
  final String date;
  final int id;
  final Map<String, dynamic>? periods;
  final String? referee;
  final Map<String, dynamic>? status;
  final int timestamp;
  final String timezone;
  final Venue? venue;
  final Goals? goals;
  final League? league;
  final Map<String, dynamic>? score;
  final Teams? teams;

  FixtureModel({
    required this.date,
    required this.id,
    this.periods,
    this.referee,
    this.status,
    required this.timestamp,
    required this.timezone,
    this.venue,
    this.goals,
    this.league,
    this.score,
    this.teams,
  });

  factory FixtureModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return FixtureModel(
      date: data['date'] ?? '',
      id: data['id'] ?? 0,
      periods: data['periods'] as Map<String, dynamic>?,
      referee: data['referee'],
      status: data['status'] as Map<String, dynamic>?,
      timestamp: data['timestamp'] ?? 0,
      timezone: data['timezone'] ?? '',
      venue: data['venue'] != null ? Venue.fromMap(data['venue']) : null,
      goals: data['goals'] != null ? Goals.fromMap(data['goals']) : null,
      league: data['league'] != null ? League.fromMap(data['league']) : null,
      score: data['score'] as Map<String, dynamic>?,
      teams: data['teams'] != null ? Teams.fromMap(data['teams']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'id': id,
      'periods': periods,
      'referee': referee,
      'status': status,
      'timestamp': timestamp,
      'timezone': timezone,
      'venue': venue?.toMap(),
      'goals': goals?.toMap(),
      'league': league?.toMap(),
      'score': score,
      'teams': teams?.toMap(),
    };
  }
}