import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WpnList extends StatefulWidget {
  const WpnList({Key? key}) : super(key: key);

  @override
  _WpnListState createState() => _WpnListState();
}

class _WpnListState extends State<WpnList> {
  late Future<List<String>> _weaponList;

  @override
  void initState() {
    super.initState();
    _weaponList = fetchWeaponList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weapon List'),
      ),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: _weaponList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  String weaponId = snapshot.data![index];
                  String weaponImageUrl =
                      'https://api.genshin.dev/weapons/$weaponId/icon';

                  return ListTile(
                    leading: Image.network(weaponImageUrl),
                    title: Text(weaponId),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WpnDetail(weaponId: weaponId),
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

class WpnDetail extends StatelessWidget {
  final String weaponId;

  const WpnDetail({Key? key, required this.weaponId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String weaponDetailUrl = 'https://api.genshin.dev/weapons/$weaponId';

    return Scaffold(
      appBar: AppBar(
        title: Text(weaponId),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchWeaponDetail(weaponDetailUrl),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> weaponDetail = snapshot.data!;
              String weaponImageUrl =
                  'https://api.genshin.dev/weapons/$weaponId/icon';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(weaponImageUrl),
                  const SizedBox(height: 16),
                  Text(
                    weaponDetail['name'] ?? 'Unknown',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Type: ${weaponDetail['type'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rarity: ${weaponDetail['rarity'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Base ATK: ${weaponDetail['baseAttack'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Secondary Stat: ${weaponDetail['secondaryStat'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Passive Ability: ${weaponDetail['passiveName'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weaponDetail['description'] ?? 'Unknown',
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




Future<List<String>> fetchWeaponList() async {
  final response = await http.get(Uri.parse('https://api.genshin.dev/weapons'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((weapon) => weapon.toString()).toList();
  } else {
    throw Exception('Failed to load weapon list');
  }
}

Future<Map<String, dynamic>> fetchWeaponDetail(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  } else {
    throw Exception('Failed to load weapon detail');
  }
}
