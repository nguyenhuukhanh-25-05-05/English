import 'package:flutter/material.dart';

class NavigationUtils {
  static void navigateTo(
    BuildContext context,
    Widget screen, {
    bool replace = false,
  }) {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.05);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var slideTransition = animation.drive(
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve)),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slideTransition, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );

    if (replace) {
      Navigator.pushReplacement(context, route);
    } else {
      Navigator.push(context, route);
    }
  }
}
