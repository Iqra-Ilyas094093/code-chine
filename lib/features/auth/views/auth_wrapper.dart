import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/features/auth/views/home_screen.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'onboarding_screen.dart';
import 'sign_in_screen.dart';
import 'register_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      child: switch (vm.screen) {
        AuthScreen.onboarding =>
        const OnboardingScreen(key: ValueKey('onboarding')),
        AuthScreen.signIn => const SignInScreen(key: ValueKey('signin')),
        AuthScreen.register => const RegisterScreen(key: ValueKey('register')),
      AuthScreen.home=>const HomeScreen(key: ValueKey('home'),)
      },
    );
  }
}