import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class EditPlayerProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Players"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(35),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Edit Player',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.gabarito,
                            fontSize: 36.0,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 10),
                      divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (userRole == UserRole.manager)
                                Center(
                                  child: _availabilityDropdown(),
                                ),
                              const SizedBox(height: 20),
                              Center(
                                  child: Column(children: [
                                Image.asset(
                                  "lib/assets/icons/profile_placeholder.png",
                                  width: 120,
                                ),
                                const SizedBox(height: 10),
                                underlineButtonTransparent(
                                    "Edit picture", () {}),
                              ])),
                              formFieldBottomBorder("First name", "Luana"),
                              formFieldBottomBorder("Surname", "Kimley"),
                              formFieldBottomBorder("Number", "6"),
                              formFieldBottomBorder(
                                  "Date of birth", "22/01/2002"),
                              formFieldBottomBorder("Height", "183cm"),
                              if (userRole == UserRole.manager)
                                dropdownWithDivider(
                                    "Position",
                                    "Defender",
                                    [
                                      "Forward",
                                      "Midfielder",
                                      "Defender",
                                      "Goalkeeper"
                                    ],
                                    (p0) {}),
                              const SizedBox(height: 30),
                              bigButton("Save Changes", () {})
                            ]),
                      )
                    ]))),
        bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 1));
  }
}

Widget _availabilityDropdown() {
  List<AvailabilityData> availability = [
    AvailabilityData(AvailabilityStatus.Available, "Available",
        Icons.check_circle, AppColours.green),
    AvailabilityData(AvailabilityStatus.Limited, "Limited", Icons.warning,
        AppColours.yellow),
    AvailabilityData(AvailabilityStatus.Unavailable, "Unavailable",
        Icons.cancel, AppColours.red)
  ];

  return DropdownButton<AvailabilityData>(
    value: availability[0],
    items: availability.map((AvailabilityData item) {
      return DropdownMenuItem<AvailabilityData>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon, color: item.color),
            const SizedBox(width: 8),
            Text(
              item.message,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }).toList(),
    onChanged: (selectedItem) {
      // Handle the selected item here
    },
  );
}
