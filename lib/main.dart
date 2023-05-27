import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latihanresponsi/charlist.dart';
import 'package:latihanresponsi/extras.dart';
import 'package:latihanresponsi/wpnlist.dart';

void main() {
  runApp(const MaterialApp(
    home: MyHomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? lastAccessedDetail;

  @override
  void initState() {
    super.initState();
    getLastAccessedDetail();
  }

  Future<void> getLastAccessedDetail() async {
    final prefs = await SharedPreferences.getInstance();
    final detail = prefs.getString('lastAccessedDetail');
    setState(() {
      lastAccessedDetail = detail;
    });
  }

  Future<void> setLastAccessedDetail(String detail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastAccessedDetail', detail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (lastAccessedDetail != null)
            IconButton(
              onPressed: () {
                // Navigate to the relevant detail page based on the last accessed detail
                if (lastAccessedDetail == 'Character') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CharList()),
                  );
                } else if (lastAccessedDetail == 'Weapon') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WpnList()),
                  );
                }
              },
              icon: const Icon(Icons.history),
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://4.bp.blogspot.com/-iz7Z_jLPL6E/XQ8eHVZTlnI/AAAAAAAAHtA/rDn9sYH174ovD4rbxsC8RSBeanFvfy75QCKgBGAs/w1440-h2560-c/genshin-impact-characters-uhdpaper.com-4K-2.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Opacity(
              opacity: 0.6,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 4,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/title.png',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setLastAccessedDetail('Character');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CharList()),
                      );
                    },
                    child: const Text('Characters'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setLastAccessedDetail('Weapon');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WpnList()),
                      );
                    },
                    child: const Text('Weapons'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Extras()),
                      );
                    },
                    child: const Text('Bonus'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
