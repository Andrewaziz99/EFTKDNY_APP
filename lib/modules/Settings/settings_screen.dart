import 'package:eftkdny/modules/Admin/admin_screen.dart';
import 'package:eftkdny/modules/Home/cubit/cubit.dart';
import 'package:eftkdny/modules/Home/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      builder: (BuildContext context, state) {
        final cubit = HomeCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/pattern.png',
                fit: BoxFit.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  buildSettingItem(
                      icon: Icons.exit_to_app_rounded,
                      text: logout,
                      textColor: Colors.redAccent,
                      iconColor: Colors.redAccent,
                      function: () {
                        showAdaptiveDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(logout),
                              content: const Text(confirmLogout),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      signOut(context);
                                    },
                                    child: const Text(yes)),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(no))
                              ],
                            ));
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  buildSettingItem(
                      icon: Icons.contact_support_rounded,
                      text: contactUs,
                      function: () {
                        showAdaptiveDialog(
                            context: context,
                            builder: (context) => contactUs_Dialog(context));
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  buildSettingItem(
                      icon: Icons.info,
                      text: about,
                      function: () {
                        showAdaptiveDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('حول التطبيق'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(aboutApp),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Text('نسخة التطبيق: $appVersion'),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Text(developer),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('حسنا'))
                              ],
                            ));
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  if(cubit.userModel!.isAdmin!)
                    buildSettingItem(
                        textColor: Colors.blue,
                        iconColor: Colors.blue,
                        icon: Icons.admin_panel_settings,
                        text: adminDashboard,
                        function: () {
                          navigateTo(context, AdminScreen());
                        })
                ],
              )
            ],
          ),
        );
      },
      listener: (BuildContext context, state) {  },
    );
  }
}

Widget contactUs_Dialog(BuildContext context) {
  return AlertDialog(
    title: const Text(contactUs),
    content: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.4,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(contactUsEmail),
            const SizedBox(
              height: 10.0,
            ),
            TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                    text: myEmail,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(emailCopied)),
                  );
                },
                child: Text(myEmail)),
            SizedBox(
              height: 20.0,
            ),
            Text(contactUsPhone),
            const SizedBox(
              height: 10.0,
            ),
            TextButton(
                onPressed: () {
                  call(myPhone);
                },
                child: Text(myPhone)),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('حسنا'))
    ],
  );
}
