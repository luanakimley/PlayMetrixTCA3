import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/schedule_details_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DailyScheduleScreen extends ConsumerWidget {
  const DailyScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final userRole = ref.watch(userRoleProvider.notifier).state;

    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Schedule"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: FutureBuilder(
              future: getTeamSchedules(ref.read(teamIdProvider.notifier).state),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final dataSource = snapshot.data;

                  return SfCalendar(
                    onTap: (CalendarTapDetails details) {
                      if (details.targetElement ==
                          CalendarElement.appointment) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScheduleDetailsScreen(
                              userId: ref.read(userIdProvider),
                              userRole: userRole,
                              teamId: ref.read(teamIdProvider),
                              scheduleId: details.appointments![0].id,
                            ),
                          ),
                        );
                      }
                    },
                    view: CalendarView.day,
                    headerStyle: const CalendarHeaderStyle(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.gabarito,
                      ),
                    ),
                    todayHighlightColor: AppColours.darkBlue,
                    selectionDecoration: BoxDecoration(
                      border:
                          Border.all(color: AppColours.darkBlue, width: 2.0),
                    ),
                    initialSelectedDate: selectedDate,
                    initialDisplayDate: selectedDate,
                    timeSlotViewSettings: const TimeSlotViewSettings(
                      numberOfDaysInView: 1,
                    ),
                    dataSource: AppointmentDataSource(dataSource!),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const CircularProgressIndicator();
              }),
        ),
        bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 2));
  }
}
