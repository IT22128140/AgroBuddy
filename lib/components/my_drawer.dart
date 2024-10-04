import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff043e18),
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: Text('Home'),
          ),
          ListTile(
            title: Text('Business'),
          ),
          ListTile(
            title: Text('School'),
          ),
        ],
      ),
    );
  }
}
