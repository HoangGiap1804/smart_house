import 'package:flutter/material.dart';
import 'package:smart_house/module/home/screens/history_page.dart';
import 'package:smart_house/module/home/screens/home_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade700, Colors.pink.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerItem(
                icon: Icons.home,
                text: 'Home',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.person,
                text: 'History',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HistoryPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
      onTap: onTap,
      hoverColor: Colors.pink.shade100.withOpacity(0.3),
    );
  }
}
