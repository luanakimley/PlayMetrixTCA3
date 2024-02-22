import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/notification_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/sign_up_form_provider.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/authentication/landing_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/player/statistics_screen.dart';
import 'package:play_metrix/screens/profile/profile_screen.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/settings_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    final userId = ref.watch(userIdProvider.notifier).state;

    return FutureBuilder<Profile>(
        future: getProfileDetails(userId, userRole),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Profile profile = snapshot.data!;

            return PopScope(
                canPop: false,
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          smallPill(userRoleText(userRole)),
                          profileDropdown(context, profile, userRole, ref),
                        ]),
                    iconTheme: const IconThemeData(
                      color: Colors.white, //change your color here
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                  ),
                  body: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/assets/signup_page_bg.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                          top: kToolbarHeight + 60,
                          left: 0,
                          right: 0,
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 5),
                                    child: Text(
                                      "Hey, ${profile.firstName}!",
                                      style: const TextStyle(
                                        fontFamily: AppFonts.gabarito,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 36,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: Center(
                                          child: _menu(userRole, context)))
                                ],
                              ))),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: SingleChildScrollView(
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 30),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text("Latest Notifications",
                                          style: TextStyle(
                                            color: AppColours.darkBlue,
                                            fontFamily: AppFonts.gabarito,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                          )),
                                      const SizedBox(height: 20),
                                      FutureBuilder(
                                          future: getNotifications(
                                              teamId: ref.read(teamIdProvider),
                                              userType: userRoleText(ref
                                                      .read(userRoleProvider))
                                                  .toLowerCase()),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else if (snapshot.hasData) {
                                              return Column(
                                                  children: snapshot
                                                          .data!.isNotEmpty
                                                      ? snapshot.data!
                                                          .map((notification) {
                                                          return announcementBox(
                                                            icon: Icons.abc,
                                                            iconColor:
                                                                AppColours
                                                                    .darkBlue,
                                                            title: notification
                                                                .title,
                                                            description:
                                                                notification
                                                                    .desc,
                                                            date: notification
                                                                .date
                                                                .toIso8601String(),
                                                            onDeletePressed:
                                                                () {},
                                                          );
                                                        }).toList()
                                                      : [
                                                          const SizedBox(
                                                              height: 50),
                                                          emptySection(
                                                              Icons
                                                                  .notifications_off,
                                                              "No notifications yet")
                                                        ]);
                                            } else {
                                              return emptySection(
                                                  Icons.notifications_off,
                                                  "No notifications yet");
                                            }
                                          }),
                                    ],
                                  )),
                            ),
                          ))
                    ],
                  ),
                  bottomNavigationBar:
                      roleBasedBottomNavBar(userRole, context, 2),
                ));
          } else {
            return const Text('No data available');
          }
        });
  }

  Widget _buildMenuItem(String text, IconData icon, Color colour,
      VoidCallback onPressed, BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5 > 200
                ? 300
                : MediaQuery.of(context).size.width * 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white60,
                border: Border.all(color: colour, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: colour,
                    size: 30,
                  ),
                  const SizedBox(height: 5),
                  Flexible(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: colour,
                        fontFamily: AppFonts.gabarito,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )));
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

  Widget _gapBetweenMenuItems() {
    return const SizedBox(width: 20);
  }

  Widget _coachMenu(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _buildMenuItem(
                'Players', Icons.group, AppColours.mediumDarkBlue, () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      PlayersScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }, context)),
        // _gapBetweenMenuItems(),
        _buildMenuItem('Schedule', Icons.calendar_month, AppColours.mediumBlue,
            () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  MonthlyScheduleScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }, context),
        // _gapBetweenMenuItems(),
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _buildMenuItem(
                'My Profile', Icons.person, AppColours.lightBlue, () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      ProfileScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }, context)),
      ],
    );
  }

  Widget _physioMenu(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _buildMenuItem(
                'Players', Icons.group, AppColours.mediumDarkBlue, () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      PlayersScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }, context)),
        _gapBetweenMenuItems(),
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _buildMenuItem(
                'My Profile', Icons.person, AppColours.lightBlue, () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      ProfileScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }, context)),
      ],
    );
  }

  Widget _playerMenu(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _buildMenuItem('Statistics', Icons.bar_chart_rounded,
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
            }, context)),
        _gapBetweenMenuItems(),
        _buildMenuItem('Schedule', Icons.calendar_month, AppColours.mediumBlue,
            () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  MonthlyScheduleScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }, context),
        _gapBetweenMenuItems(),
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _buildMenuItem(
                'My Profile', Icons.group, AppColours.lightBlue, () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      PlayerProfileScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }, context)),
      ],
    );
  }

  Widget _managerMenu(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _buildMenuItem(
                'Players & Coaches', Icons.group, AppColours.mediumDarkBlue,
                () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      PlayersScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }, context)),
        _gapBetweenMenuItems(),
        _buildMenuItem('Schedule', Icons.calendar_month, AppColours.mediumBlue,
            () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  MonthlyScheduleScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }, context),
        _gapBetweenMenuItems(),
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _buildMenuItem(
                'My Profile', Icons.person, AppColours.lightBlue, () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      ProfileScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }, context)),
      ],
    );
  }
}

Widget profileDropdown(
    BuildContext context, Profile profile, UserRole userRole, WidgetRef ref) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(50),
      ),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        value: 'profile',
        hint: Row(
          children: [
            profile.imageBytes != null && profile.imageBytes!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.memory(
                      profile.imageBytes!,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    "lib/assets/icons/profile_placeholder.png",
                    width: 25,
                  ),
            const SizedBox(width: 10),
            const Text(
              "My Profile",
              style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: AppColours.darkBlue,
                fontSize: 18,
                color: AppColours.darkBlue,
                // fontFamily: AppFonts.gabarito,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        items: [
          DropdownMenuItem(
            value: 'profile',
            child: Row(
              children: [
                profile.imageBytes != null && profile.imageBytes!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Image.memory(
                          profile.imageBytes!,
                          width: 25,
                          height: 25,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        "lib/assets/icons/profile_placeholder.png",
                        width: 25,
                      ),
                const SizedBox(width: 10),
                const Text(
                  "My Profile",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                    color: AppColours.darkBlue,
                    decorationColor: AppColours.darkBlue,
                    fontFamily: AppFonts.gabarito,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const DropdownMenuItem(
            value: 'settings',
            child: Row(
              children: [
                Icon(Icons.settings),
                SizedBox(width: 5),
                Text("Settings"),
              ],
            ),
          ),
          const DropdownMenuItem(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 5),
                Text("Log Out"),
              ],
            ),
          ),
        ],
        onChanged: (String? value) {
          if (value == 'profile') {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    userRole == UserRole.player
                        ? PlayerProfileScreen()
                        : const ProfileScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (value == 'settings') {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const SettingsScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (value == 'logout') {
            ref.read(userRoleProvider.notifier).state = UserRole.manager;
            ref.read(userIdProvider.notifier).state = 0;
            ref.read(profilePictureProvider.notifier).state = null;
            ref.read(teamIdProvider.notifier).state = -1;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LandingScreen()),
            );
          }
        },
      ));
}
