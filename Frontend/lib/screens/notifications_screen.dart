import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/notification_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/notification_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.read(userRoleProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications",
              style: TextStyle(
                color: AppColours.darkBlue,
                fontFamily: AppFonts.gabarito,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              )),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 20, right: 35, left: 35),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                                future: getNotifications(
                                    teamId: ref.read(teamIdProvider),
                                    userType:
                                        userRoleText(ref.read(userRoleProvider))
                                            .toLowerCase()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    List<NotificationData> notifications =
                                        snapshot.data!;
                                    return Column(
                                        children: notifications.isNotEmpty
                                            ? notifications
                                                .where((notification) =>
                                                    notification.date.isBefore(
                                                        DateTime.now()) ||
                                                    notification.date
                                                        .isAtSameMomentAs(
                                                            DateTime.now()))
                                                .map((notification) {
                                                return announcementBox(
                                                  icon: notificationTypeToIcon(
                                                      notification.type),
                                                  iconColor: notification
                                                              .type ==
                                                          NotificationType.event
                                                      ? AppColours.darkBlue
                                                      : AppColours.red,
                                                  title: notification.title,
                                                  description:
                                                      notification.desc,
                                                  date: notification.date
                                                      .toIso8601String(),
                                                );
                                              }).toList()
                                            : [
                                                emptySection(
                                                    Icons.notifications_off,
                                                    "No notifications yet")
                                              ]);
                                  } else {
                                    return emptySection(Icons.notifications_off,
                                        "No notifications yet");
                                  }
                                }),
                            const SizedBox(height: 20),
                          ]),
                    )))),
        bottomNavigationBar: roleBasedBottomNavBar(
          userRole,
          context,
          1,
        ));
  }
}
