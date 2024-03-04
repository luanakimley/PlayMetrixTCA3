import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';

class PlayerData {
  final int player_id;
  final String player_firstname;
  final String player_surname;
  final DateTime player_dob;
  final String player_contact_number;
  final Uint8List player_image;
  final String player_height;
  final String player_gender;

  PlayerData({
    required this.player_id,
    required this.player_firstname,
    required this.player_surname,
    required this.player_dob,
    required this.player_contact_number,
    required this.player_image,
    required this.player_height,
    required this.player_gender,
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      player_id: json['player_id'],
      player_firstname: json['player_firstname'],
      player_surname: json['player_surname'],
      player_dob: DateTime.parse(json['player_dob']),
      player_contact_number: json['player_contact_number'],
      player_image: base64.decode(json['player_image']),
      player_height: json['player_height'],
      player_gender: json['player_gender'],
    );
  }
}

class PlayerProfile {
  final int playerId;
  final String firstName;
  final String surname;
  final String dob;
  final String gender;
  final String height;
  final int teamNumber;
  final AvailabilityStatus status;
  final LineupStatus lineupStatus;
  final Uint8List? imageBytes;

  PlayerProfile(
      this.playerId,
      this.firstName,
      this.surname,
      this.dob,
      this.gender,
      this.height,
      this.teamNumber,
      this.status,
      this.lineupStatus,
      this.imageBytes);
}

class TeamPlayerData {
  final int team_id;
  final int player_id;
  final String team_position;
  final int player_team_number;
  final String playing_status;
  final String lineup_status;

  TeamPlayerData({
    required this.team_id,
    required this.player_id,
    required this.team_position,
    required this.player_team_number,
    required this.playing_status,
    required this.lineup_status,
  });
}

class AvailabilityData {
  final AvailabilityStatus status;
  final String message;
  final IconData icon;
  final Color color;

  AvailabilityData(this.status, this.message, this.icon, this.color);
}

final List<AvailabilityData> availabilityData = [
  AvailabilityData(AvailabilityStatus.available, "Available",
      Icons.check_circle, AppColours.green),
  AvailabilityData(
      AvailabilityStatus.limited, "Limited", Icons.warning, AppColours.yellow),
  AvailabilityData(AvailabilityStatus.unavailable, "Unavailable", Icons.cancel,
      AppColours.red)
];

class StatisticsData {
  final int matchesPlayed;
  final int matchesStarted;
  final int matchesOffTheBench;
  final int totalMinutesPlayed;
  final bool injuryProne;

  StatisticsData(this.matchesPlayed, this.matchesStarted,
      this.matchesOffTheBench, this.totalMinutesPlayed, this.injuryProne);
}

class Injury {
  final int id;
  final String type;
  final String nameAndGrade;
  final String location;
  final List<String> potentialRecoveryMethods;
  final int expectedMinRecoveryTime;
  final int expectedMaxRecoveryTime;

  Injury({
    required this.id,
    required this.type,
    required this.nameAndGrade,
    required this.location,
    required this.potentialRecoveryMethods,
    required this.expectedMinRecoveryTime,
    required this.expectedMaxRecoveryTime,
  });

  factory Injury.fromJson(Map<String, dynamic> json) {
    return Injury(
        id: json['injury_id'] ?? 0,
        type: json['injury_type'] ?? "",
        nameAndGrade: json['injury_name_and_grade'] ?? "",
        location: json['injury_location'] ?? "",
        potentialRecoveryMethods: [
          json['potential_recovery_method_1'] ?? "",
          json['potential_recovery_method_2'] ?? "",
          json['potential_recovery_method_3'] ?? ""
        ],
        expectedMinRecoveryTime: json['expected_minimum_recovery_time'],
        expectedMaxRecoveryTime: json['expected_maximum_recovery_time']);
  }
}

class AllPlayerInjuriesData {
  final int id;
  final String type;
  final String nameAndGrade;
  final String location;
  final List<String> potentialRecoveryMethods;
  final int expectedMinRecoveryTime;
  final int expectedMaxRecoveryTime;
  final DateTime dateOfInjury;
  final DateTime expectedDateOfRecovery;
  final int playerId;
  final int physioId;
  final Uint8List? playerInjuryReport;

  AllPlayerInjuriesData({
    required this.id,
    required this.type,
    required this.nameAndGrade,
    required this.location,
    required this.potentialRecoveryMethods,
    required this.expectedMinRecoveryTime,
    required this.expectedMaxRecoveryTime,
    required this.dateOfInjury,
    required this.expectedDateOfRecovery,
    required this.playerId,
    required this.physioId,
    this.playerInjuryReport,
  });
}

class PlayerInjuries {
  final int injuryId;
  final int playerId;
  final int physioId;
  final DateTime dateOfInjury;
  final DateTime dateOfRecovery;
  final Uint8List? playerInjuryReport;

  PlayerInjuries({
    required this.injuryId,
    required this.playerId,
    required this.physioId,
    required this.dateOfInjury,
    required this.dateOfRecovery,
    this.playerInjuryReport,
  });

  factory PlayerInjuries.fromJson(Map<String, dynamic> json) {
    return PlayerInjuries(
      injuryId: json['injury_id'],
      playerId: json['player_id'],
      physioId: json['physio_id'],
      dateOfInjury: DateTime.parse(json['date_of_injury']),
      dateOfRecovery: DateTime.parse(json['expected_date_of_recovery']),
      playerInjuryReport: json['player_injury_report'] != null
          ? base64.decode(json['player_injury_report'])
          : null,
    );
  }
}

String formatBytes(int bytes) {
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = 0;
  double size = bytes.toDouble();
  while (size > 1024) {
    size /= 1024;
    i++;
  }
  return '${size.toStringAsFixed(2)} ${suffixes[i]}';
}
