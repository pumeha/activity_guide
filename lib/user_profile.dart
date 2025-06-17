import 'package:activity_guide/main.dart';
import 'package:activity_guide/shared/custom_widgets/custom_text.dart';
import 'package:activity_guide/shared/theme_mode_bloc/theme_bloc.dart';
import 'package:activity_guide/shared/theme_mode_bloc/theme_event_et_state.dart';
import 'package:activity_guide/shared/utils/constants.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'shared/utils/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> loadUserDetails() async {
    String fullname =
        await MysharedPreference().getPreferences(fullnameKey) ?? '';
    String role =
        await MysharedPreference().getPreferences(LoginKeys.role) ?? '';
    String dept = await MysharedPreference().getPreferences(deptKey) ?? '';
    return [role, fullname, dept];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: loadUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return customCircleIndicator();
          } else if (snapshot.hasError) {
            return CustomText(text: 'Error ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const CustomText(text: 'No User Details');
          } else {
            return ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: active),
                  child: Center(
                      child: Icon(
                    Icons.person_sharp,
                    color: Colors.white,
                    size: 60,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const CustomText(text: 'Staff Id'),
                    subtitle: Padding(
                      padding: EdgeInsets.all(8),
                      child: CustomText(
                        text: snapshot.data![1].toUpperCase(),
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: CustomText(
                        text: snapshot.data![0] == 'user'
                            ? 'Staff Dept/Unit'
                            : 'Role'),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CustomText(
                        text: snapshot.data![0] == 'user'
                            ? snapshot.data![2].toUpperCase()
                            : snapshot.data![0].toUpperCase(),
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await MysharedPreference().clearPreferenceAll();

                          context.read<ThemeBloc>().add(LightTheme());
                        context.beamToReplacementNamed('/login');
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.amberAccent)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ))
              ],
            );
          }
        },
      ),
    );
  }
}
