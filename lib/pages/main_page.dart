import 'package:flutter/material.dart';
import 'package:flutter_project/pages/add_task.dart';
import 'package:flutter_project/pages/all_task.dart';
import 'package:flutter_project/pages/finished_task.dart';
import 'package:flutter_project/pages/setting.dart';
import 'package:flutter_project/pages/unfinish_task.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List _screens = [
    const AllTaskPage(),
    const AddTask(),
    const FinishedTaskPage(),
    const UnfinishTaskPage(),
    const SettingPage()
  ];

  void _updateIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _updateIndex,
        selectedItemColor: Colors.blue[700],
        selectedFontSize: 16,
        unselectedFontSize: 13,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Finished'),
          BottomNavigationBarItem(
              icon: Icon(Icons.cancel_outlined), label: 'Unfinished'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
      ),
    );
  }
}
