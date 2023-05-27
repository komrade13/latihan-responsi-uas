import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CharList extends StatefulWidget {
  const CharList({Key? key}) : super(key: key);

  @override
  _CharListState createState() => _CharListState();
}

class _CharListState extends State<CharList> {
  late Future<List<String>> _characterList;

  @override
  void initState() {
    super.initState();
    _characterList = fetchCharacterList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character List'),
      ),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: _characterList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  String characterId = snapshot.data![index];
                  String characterImageUrl =
                      'https://api.genshin.dev/characters/$characterId/card';

                  return ListTile(
                    leading: Image.network(characterImageUrl),
                    title: Text(characterId),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharDetail(characterId: characterId),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Future<List<String>> fetchCharacterList() async {
  final response = await http.get(Uri.parse('https://api.genshin.dev/characters'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((character) => character.toString()).toList();
  } else {
    throw Exception('Failed to load character list');
  }
}


class CharDetail extends StatefulWidget {
  final String characterId;

  const CharDetail({Key? key, required this.characterId}) : super(key: key);

  @override
  _CharDetailState createState() => _CharDetailState();
}

class _CharDetailState extends State<CharDetail> {
  late Future<Map<String, dynamic>> _characterDetail;

  @override
  void initState() {
    super.initState();
    _characterDetail = fetchCharacterDetail();
  }

  Future<Map<String, dynamic>> fetchCharacterDetail() async {
    final response =
    await http.get(Uri.https('api.genshin.dev', 'characters/${widget.characterId}'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load character detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: _characterDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> characterDetail = snapshot.data!;
              String characterName = characterDetail['name'];

              return Text(characterName);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const Text('Loading...');
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _characterDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> characterDetail = snapshot.data!;
              String characterImageUrl =
                  'https://api.genshin.dev/characters/${widget.characterId}/icon';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(characterImageUrl),
                  const SizedBox(height: 16),
                  Text(
                    characterDetail['name'] ?? 'Unknown',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Vision: ${characterDetail['vision'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Weapon: ${characterDetail['weapon'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rarity: ${characterDetail['rarity'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Constellation: ${characterDetail['constellation'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    characterDetail['description'] ?? 'Unknown',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
