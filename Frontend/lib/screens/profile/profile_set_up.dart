import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final profilePictureProvider = StateProvider<Uint8List?>((ref) => null);

class ProfileName {
  final String firstName;
  final String surname;

  ProfileName(this.firstName, this.surname);
}

class Profile {
  final String firstName;
  final String surname;
  final String contactNumber;
  final String email;
  final Uint8List? imageBytes;

  Profile(this.firstName, this.surname, this.contactNumber, this.email,
      this.imageBytes);
}

Future<Profile> getManagerProfile(int id) async {
  final apiUrl = 'http://127.0.0.1:8000/managers/$id';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      final parsed = jsonDecode(response.body);

      return Profile(
          parsed['manager_firstname'],
          parsed['manager_surname'],
          parsed['manager_contact_number'],
          parsed['manager_email'],
          base64Decode((parsed['manager_image'])));
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  return Profile("", "", "", "", null);
}

Future<void> updateManagerProfile(int id, ProfileName name,
    String contactNumber, Uint8List? imageBytes) async {
  final apiUrl = 'http://127.0.0.1:8000/managers/info/$id';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'manager_id': id,
        'manager_firstname': name.firstName,
        'manager_surname': name.surname,
        'manager_contact_number': contactNumber,
        'manager_image': imageBytes != null ? base64Encode(imageBytes) : "",
      }),
    );

    if (response.statusCode == 200) {
      print('Registration successful!');
      print('Response: ${response.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<Profile> getPhysioProfile(int id) async {
  final apiUrl = 'http://127.0.0.1:8000/physio/info/$id';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      final parsed = jsonDecode(response.body);

      return Profile(parsed['physio_firstname'], parsed['physio_surname'],
          parsed['physio_contact_number'], parsed['physio_email'], null);
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  return Profile("", "", "", "", null);
}

Future<void> updatePhysioProfile(
    int id, ProfileName name, String contactNumber) async {
  final apiUrl = 'http://127.0.0.1:8000/physio/info/$id';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'physio_id': id,
        'physio_firstname': name.firstName,
        'physio_surname': name.surname,
        'physio_contact_number': contactNumber,
      }),
    );

    if (response.statusCode == 200) {
      print('Registration successful!');
      print('Response: ${response.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<Profile> getCoachProfile(int id) async {
  final apiUrl = 'http://127.0.0.1:8000/coaches/info/$id';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      final parsed = jsonDecode(response.body);

      return Profile(
          parsed['coach_firstname'],
          parsed['coach_surname'],
          parsed['coach_contact'],
          parsed['coach_email'],
          base64Decode((parsed['coach_image'])));
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  return Profile("", "", "", "", null);
}

Future<void> updateCoachProfile(int id, ProfileName name, String contactNumber,
    Uint8List? imageBytes) async {
  final apiUrl = 'http://127.0.0.1:8000/coaches/info/$id';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'coach_id': id,
        'coach_firstname': name.firstName,
        'coach_surname': name.surname,
        'coach_contact': contactNumber,
        'coach_image': imageBytes != null ? base64Encode(imageBytes) : "",
      }),
    );

    if (response.statusCode == 200) {
      print('Registration successful!');
      print('Response: ${response.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

class ProfileSetUpScreen extends ConsumerWidget {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();

        ref.read(profilePictureProvider.notifier).state =
            Uint8List.fromList(imageBytes);
      }
    }

    final userRole = ref.watch(userRoleProvider.notifier).state;
    Uint8List? profilePicture = ref.watch(profilePictureProvider);

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
      body: Form(
          child: Container(
        padding: EdgeInsets.all(35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profile Set Up',
                style: TextStyle(
                  color: AppColours.darkBlue,
                  fontFamily: AppFonts.gabarito,
                  fontSize: 36.0,
                  fontWeight: FontWeight.w700,
                )),
            const Divider(
              color: AppColours.darkBlue,
              thickness: 1.0, // Set the thickness of the line
              height: 40.0, // Set the height of the line
            ),
            const SizedBox(height: 20),
            Center(
                child: Column(children: [
              profilePicture != null
                  ? Image.memory(
                      profilePicture,
                      width: 100,
                    )
                  : Image.asset(
                      "lib/assets/icons/profile_placeholder.png",
                      width: 100,
                    ),
              const SizedBox(height: 10),
              underlineButtonTransparent("Upload picture", () {
                pickImage();
              }),
            ])),
            const SizedBox(height: 20),
            formFieldBottomBorderController("Phone", _phoneController),
            const SizedBox(height: 50),
            bigButton("Save Changes", () async {
              if (userRole == UserRole.manager) {
                int userId = ref.watch(userIdProvider.notifier).state;
                Profile manager = await getManagerProfile(userId);

                await updateManagerProfile(
                    userId,
                    ProfileName(manager.firstName, manager.surname),
                    _phoneController.text,
                    ref.read(profilePictureProvider.notifier).state);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeamSetUpScreen()),
                );
              } else {
                if (userRole == UserRole.physio) {
                  int userId = ref.watch(userIdProvider.notifier).state;
                  Profile physio = await getPhysioProfile(userId);

                  await updatePhysioProfile(
                    userId,
                    ProfileName(physio.firstName, physio.surname),
                    _phoneController.text,
                  );
                } else if (userRole == UserRole.coach) {
                  int userId = ref.watch(userIdProvider.notifier).state;
                  Profile coach = await getCoachProfile(userId);

                  await updateCoachProfile(
                      userId,
                      ProfileName(coach.firstName, coach.surname),
                      _phoneController.text,
                      ref.read(profilePictureProvider.notifier).state);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }
            })
          ],
        ),
      )),
    );
  }
}
