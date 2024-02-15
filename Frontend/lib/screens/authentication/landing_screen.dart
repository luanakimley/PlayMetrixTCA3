import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/screens/authentication/sign_up_steps/name_sign_up_screen.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/landing_page_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/logo.png',
                width: 350,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 18),
              CupertinoButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NameSignUpScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(25),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 85),
                color: AppColours.darkBlue,
                child: const Text(
                  'Sign up with email',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: AppFonts.openSans,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "or",
                style: TextStyle(
                  color: AppColours.darkBlue,
                  fontFamily: AppFonts.openSans,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              CupertinoButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogInScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(25),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 85),
                color: Colors.white,
                child: const Text(
                  'Log in with account',
                  style: TextStyle(
                    color: AppColours.darkBlue,
                    fontFamily: 'Open Sans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
