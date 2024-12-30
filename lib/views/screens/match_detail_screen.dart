import 'package:flutter/material.dart';

class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({super.key, required this.liveMatchData});
  static const String id = "matchDetailScreen";
  final dynamic liveMatchData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Match Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.pushNamed(context, 'banterRoomScreen', arguments: liveMatchData['fixture']['id']);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildScoreCard(),
            _buildTabBar(),
            _buildStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    print(liveMatchData);
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home Team
                Column(
                  children: [
                    Image.network(
                      liveMatchData['teams']['home']['logo'].toString(),
                      height: 60,
                      width: 60,
                    ),

                    Text(
                      liveMatchData['teams']['home']['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                // Score
                Column(
                  children: [
                    Text(
                      liveMatchData['fixture']['status']['long'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      liveMatchData['fixture']['status']['long'] == 'Not Started' ? '0 : 0' : '' ,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Away Team
                Column(
                  children: [
                    Image.network(
                      liveMatchData['teams']['away']['logo'].toString(), // Replace with actual logo
                      height: 60,
                      width: 60,
                    ),
                    Text(
                      liveMatchData['teams']['away']['name'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            //_buildScorersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildScorersList() {
    return Column(
      children: [
        _buildScorerRow('Mohamed Salah', "15', 39'", 'Taiwo Awoniyi', "25'"),
        _buildScorerRow('Luis Díaz', "65'", 'Callum Hudson', "41'"),
      ],
    );
  }

  Widget _buildScorerRow(String homePlayer, String homeTime, String awayPlayer, String awayTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              homePlayer,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            homeTime,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.sports_soccer, size: 16),
          ),
          Text(
            awayTime,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              awayPlayer,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTab('Stats', true),
          _buildTab('Summary', false),
          _buildTab('Lineups', false),
          _buildTab('H2H', false),
          _buildTab('Table', false),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.purple : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatRow('Shots on goal', 2, 6),
          _buildStatRow('Shots', 4, 15),
          _buildStatRow('Possession %', 26.0, 74.0),
          _buildStatRow('Yellow card', 3, 2),
          _buildStatRow('Corner kicks', 0, 2),
          _buildStatRow('Crosses', 10, 23),
          _buildStatRow('Goalkeeper saves', 3, 2),
        ],
      ),
    );
  }

  Widget _buildStatRow(String title, num homeValue, num awayValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                homeValue.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                awayValue.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    flex: homeValue.toInt(),
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: awayValue.toInt(),
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}