import 'package:flutter/material.dart';
import 'package:movie_app/pages/account_page.dart';
import 'package:movie_app/pages/category_page.dart';
import 'package:movie_app/pages/home_page.dart';

class MainPage extends StatefulWidget {
  final int? defaultGenre;
  const MainPage({Key? key, this.defaultGenre}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Navigation index
  int _selectedIdx = 0;
  List<Widget> pages = [
    const HomePage(),
    const CategoryPage(),
    const AccountPage()
  ];

  @override
  void initState() {
    super.initState();
    int? genreId = widget.defaultGenre;
    if (genreId != null) {
      pages[1] = CategoryPage(genreId: genreId);
      _selectedIdx = 1;
    }
  }

  void navigateBar(int idx) {
    setState(() {
      _selectedIdx = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF80DEEA),
          iconSize: 30,
          selectedFontSize: 15,
          unselectedFontSize: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIdx,
          selectedItemColor: Colors.cyan[600],
          onTap: navigateBar,
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(Icons.menu, color: Color(0xFF80DEEA)),
          title: const Text(
            'MovAIO',
            style: TextStyle(
                color: Color(0xFF80DEEA),
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: IndexedStack(
          index: _selectedIdx,
          children: pages,
        ));
  }
}
