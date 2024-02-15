import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/profile_class.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/state_providers/authentication_providers.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/profile/profile_screen.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/player/statistics_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<PlayerData> getPlayerById(int id) async {
  final apiUrl =
      '$apiBaseUrl/players/info/$id'; // Replace with your actual backend URL and provide the user ID

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      PlayerData player = PlayerData.fromJson(jsonDecode(response.body));

      return player;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print("user");
    print('Error: $error');
  }
  throw Exception('Failed to retrieve player data');
}

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    final userId = ref.watch(userIdProvider.notifier).state;

    return FutureBuilder<Profile>(
        future: getProfileDetails(userId, userRole),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Profile profile = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Image.asset(
                  'lib/assets/logo.png',
                  width: 150,
                  fit: BoxFit.contain,
                ),
                iconTheme: const IconThemeData(
                  color: AppColours.darkBlue, //change your color here
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              body: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.only(top: 30, right: 35, left: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          smallPill(userRoleText(userRole)),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            userRole == UserRole.player
                                                ? PlayerProfileScreen()
                                                : ProfileScreen(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              child: Container(
                                  // padding: const EdgeInsets.all(5),
                                  // decoration: BoxDecoration(
                                  //   color: AppColours.lightBlue,
                                  //   borderRadius: BorderRadius.circular(20),
                                  // ),
                                  child: Row(children: [
                                profile.imageBytes != null &&
                                        profile.imageBytes!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(75),
                                        child: Image.memory(
                                          profile.imageBytes!,
                                          width: 35,
                                          height: 35,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        "lib/assets/icons/profile_placeholder.png",
                                        width: 35,
                                      ),
                                const SizedBox(width: 10),
                                const Text("My Profile",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 20,
                                      color: AppColours.darkBlue,
                                      fontFamily: AppFonts.gabarito,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ])))
                        ]),
                    const SizedBox(height: 40),
                    Text(
                      "Hey, ${profile.firstName}!",
                      style: const TextStyle(
                        fontFamily: AppFonts.gabarito,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _menu(userRole, context)
                  ],
                ),
              )),
              bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 0),
            );
          } else {
            return const Text('No data available');
          }
        });
  }

  Widget _buildMenuItem(
      String text, String imagePath, Color colour, VoidCallback onPressed) {
    return InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          decoration: BoxDecoration(
            // color: AppColours.darkBlue,
            border: Border.all(color: colour, width: 5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                imagePath,
                width: 100,
                height: 100,
              ),
              Flexible(
                child: Wrap(
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: colour,
                        fontFamily: AppFonts.gabarito,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _menu(UserRole userRole, BuildContext context) {
    switch (userRole) {
      case UserRole.manager:
        return _managerMenu(context);
      case UserRole.coach:
        return _coachMenu(context);
      case UserRole.player:
        return _playerMenu(context);
      case UserRole.physio:
        return _physioMenu(context);
    }
  }

  Widget _coachMenu(BuildContext context) {
    return Column(children: [
      _buildMenuItem('Players', 'lib/assets/icons/players_menu.png',
          AppColours.mediumDarkBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PlayersScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('Schedule', 'lib/assets/icons/schedule_menu.png',
          AppColours.mediumBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                MonthlyScheduleScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('My Profile', 'lib/assets/icons/manager_coach_menu.png',
          AppColours.lightBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
    ]);
  }

  Widget _playerMenu(BuildContext context) {
    return Column(children: [
      _buildMenuItem('Statistics', 'lib/assets/icons/statistics_menu.png',
          AppColours.mediumDarkBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                StatisticsScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('Schedule', 'lib/assets/icons/schedule_menu.png',
          AppColours.mediumBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                MonthlyScheduleScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('My Profile', 'lib/assets/icons/players_menu.png',
          AppColours.lightBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                PlayerProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
    ]);
  }

  Widget _physioMenu(BuildContext context) {
    return Column(children: [
      _buildMenuItem('Players & Coaches', 'lib/assets/icons/players_menu.png',
          AppColours.mediumDarkBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PlayersScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('My Profile', 'lib/assets/icons/manager_coach_menu.png',
          AppColours.lightBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
    ]);
  }

  Widget _managerMenu(BuildContext context) {
    return Column(children: [
      _buildMenuItem('Players & Coaches', 'lib/assets/icons/players_menu.png',
          AppColours.mediumDarkBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PlayersScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('Schedule', 'lib/assets/icons/schedule_menu.png',
          AppColours.mediumBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                MonthlyScheduleScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('My Profile', 'lib/assets/icons/manager_coach_menu.png',
          AppColours.lightBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
    ]);
  }
}
