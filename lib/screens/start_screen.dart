import 'package:flutter/material.dart';
import 'package:english/screens/main_screen.dart';
import 'package:english/utils/navigation_utils.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(flex: 2),
              _TitleSection(),
              SizedBox(height: 12),
              _SloganSection(),
              Spacer(flex: 3),
              _StartButton(),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TOEIC',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w200,
            color: Color(0xFF111827),
            letterSpacing: -2,
          ),
        ),
        Text(
          'Master',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
            letterSpacing: -1,
            height: 0.8,
          ),
        ),
      ],
    );
  }
}

class _SloganSection extends StatelessWidget {
  const _SloganSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 30, height: 2, color: const Color(0xFF007AFF)),
        const SizedBox(height: 20),
        const Text(
          'Luyện thi thông minh.\nBứt phá điểm số tối ưu.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF4B5563),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NavigationUtils.navigateTo(
        context,
        const MainScreen(),
        replace: true,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF111827), width: 1),
          ),
        ),
        child: const SizedBox(
          height: 30,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bắt đầu ôn luyện',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFF111827),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
