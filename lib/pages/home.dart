import 'package:flutter/material.dart';
import 'package:offline_gamebox/pages/settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(body: Column(children: [CustomAppBar()]));
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 30, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              ),
            },
            icon: Icon(Icons.menu),
          ),
          ElevatedButton(
            onPressed: () => debugPrint("remove ads"),
            child: const Text('Remove Ads'),
          ),
        ],
      ),
    );
  }
}
