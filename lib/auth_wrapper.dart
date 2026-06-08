import 'package:flutter/material.dart';
import 'package:sehatalert/view/disease_selection/disease_selection.dart';
import 'package:sehatalert/view/home/home.dart';
import 'package:sehatalert/view/patient_information/patient_information.dart';
import 'package:sehatalert/view/signin/signin.dart';
import 'package:sehatalert/view/signup/signup.dart';
import 'package:sehatalert/core/shared_pref/shared_pref.dart';

import 'data/repository/authentication/authentication_repository.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkAuthAndGetScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: SizedBox.shrink());
        }

        return snapshot.data ?? const SignUpScreen();
      },
    );
  }

  Future<Widget> checkAuthAndGetScreen() async {
    final AuthRepository authRepository = AuthRepository();
    final SharedPreferencesService prefsService = SharedPreferencesService();

    // Check if this is first time opening the app
    final isFirstTime = await prefsService.isFirstTimeUser();

    if (isFirstTime) {
      // First time user - go to signup
      return const SignUpScreen();
    }

    // Not first time - check authentication
    final emailRememberMe = await prefsService.getRememberMe();
    final phoneRememberMe = await prefsService.getPhoneRememberMe();
    final rememberMe = emailRememberMe || phoneRememberMe;

    if (authRepository.isAuthenticated && rememberMe) {
      final userData = await authRepository.getCurrentUserData();

      if (userData == null) {
        return const SignInScreen();
      }

      // Check if patient info is filled
      if (userData.patientInfo == null) {
        return const PatientInformation();
      }

      // Check if diseases are selected
      if (userData.patientInfo!.diseases.isEmpty) {
        return const DiseaseSelection();
      }

      // All complete, go to home
      return const HomeScreen();
    } else {
      // Not authenticated or remember me is false
      if (authRepository.isAuthenticated) {
        await authRepository.signOut();
      }
      return const SignInScreen();
    }
  }
}
