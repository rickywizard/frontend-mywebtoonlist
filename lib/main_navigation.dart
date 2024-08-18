import 'package:flutter/material.dart';
import 'package:frontend/pages/collection_page.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageNavigation extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const PageNavigation({super.key, required this.onThemeChanged});

  @override
  State<PageNavigation> createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  int _currentIndex = 0;
  String? _lineId;

  @override
  void initState() {
    super.initState();
    _loadLineId();
  }

  Future<void> _loadLineId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lineId = prefs.getString('lineId');
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const CollectionPage(),
  ];

  void _onItemTapped(int index) {
    if (index != 2 && index != 3) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _showThemeMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 120,
        MediaQuery.of(context).size.height - kBottomNavigationBarHeight - 120,
        0,
        0,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            title: const Text('Light'),
            onTap: () {
              // Implement light theme change logic
              widget.onThemeChanged(false);
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('Dark'),
            onTap: () {
              // Implement dark theme change logic
              widget.onThemeChanged(true);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  void _showProfileMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 120,
        MediaQuery.of(context).size.height - kBottomNavigationBarHeight - 120,
        0,
        0,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            title: Text('$_lineId'),
            onTap: () {},
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('Logout'),
            onTap: () async {
              // Implement logout logic
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('id');
              await prefs.remove('lineId');
              if (mounted) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPage(onThemeChanged: widget.onThemeChanged)),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF00D563),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            _showThemeMenu();
          } else if (index == 3) {
            _showProfileMenu();
          } else {
            _onItemTapped(index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.collections), label: 'Collection'),
          BottomNavigationBarItem(
              icon: Icon(Icons.brightness_6), label: 'Theme'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
