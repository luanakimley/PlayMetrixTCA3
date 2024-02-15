import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/profile_class.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/profile/profile_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class ProfileViewScreen extends ConsumerWidget {
  final int userId;
  final UserRole userRole;

  const ProfileViewScreen(
      {super.key, required this.userId, required this.userRole});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      padding:
                          const EdgeInsets.only(top: 30, right: 35, left: 35),
                      child: Column(children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profile",
                              style: TextStyle(
                                fontFamily: AppFonts.gabarito,
                                color: AppColours.darkBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Column(children: [
                            const SizedBox(height: 20),
                            Text(
                              "${profile.firstName} ${profile.surname}",
                              style: const TextStyle(
                                fontFamily: AppFonts.gabarito,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            profile.imageBytes != null &&
                                    profile.imageBytes!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        75), // Adjust the radius as needed
                                    child: Image.memory(
                                      profile.imageBytes!,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit
                                          .cover, // Ensure the image fills the rounded rectangle
                                    ),
                                  )
                                : Image.asset(
                                    "lib/assets/icons/profile_placeholder.png",
                                    width: 150),
                            const SizedBox(height: 20),
                            smallPill(userRoleText(userRole)),
                            const SizedBox(height: 40),
                            FutureBuilder(
                                future: getTeamById(
                                    ref.read(teamIdProvider.notifier).state),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    TeamData team = snapshot.data!;
                                    return profilePill(
                                        team.team_name,
                                        team.team_location,
                                        "lib/assets/icons/logo_placeholder.png",
                                        team.team_logo, () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TeamProfileScreen()),
                                      );
                                    });
                                  } else {
                                    return emptySection(
                                        Icons.group_off, "No team yet");
                                  }
                                }),
                            const SizedBox(height: 20),
                            divider(),
                            const SizedBox(height: 20),
                            const Text("Contacts",
                                style: TextStyle(
                                  fontFamily: AppFonts.gabarito,
                                  fontSize: 32,
                                  color: AppColours.darkBlue,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 20),
                            detailWithDivider("Phone", profile.contactNumber),
                            const SizedBox(height: 10),
                            detailWithDivider("Email", profile.email),
                            const SizedBox(height: 25),
                          ]),
                        )
                      ]))),
            );
          } else {
            return const Text('No data available');
          }
        });
  }
}
