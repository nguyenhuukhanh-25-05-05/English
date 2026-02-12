import 'package:flutter/material.dart';
import 'package:english/screens/home_screen.dart';
import 'package:english/screens/lesson_screen.dart';
import 'package:english/screens/exam.dart';
import 'package:english/screens/profile_screen.dart';
import 'package:english/widgets/app_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialPage = 0});

  final int initialPage;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialPage;
  }

  void _onBottomBarTap(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const LessonScreen();
      case 2:
        return const ExamScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: _buildScreen(),
      bottomNavigationBar: AppBottomBar(
        currentIndex: _currentIndex,
        onTap: _onBottomBarTap,
      ),
    );
  }
}
