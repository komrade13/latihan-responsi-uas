import 'dart:io';

import 'package:flutter/material.dart';

class Extras extends StatelessWidget {
  const Extras({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Warning!'),
              content: const Text('This is no joke. Pressing the Proceed button will detonate your device that is currently running this app. Are you sure you want to do this?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: const Text('Proceed'),
                ),
              ],
            ),
          ),
          child: const Text('Detonate device'),
        ),
      ),
    );
  }
}
