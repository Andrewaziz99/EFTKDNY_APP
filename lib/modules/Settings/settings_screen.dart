import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/uil.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/pattern.png',
            fit: BoxFit.fill,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0,),
              buildSettingItem(
                  icon: Icons.exit_to_app_rounded,
                  text: logout,
                  textColor: Colors.redAccent,
                  iconColor: Colors.redAccent,
                  function: (){
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
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
                          )
                    );
                  }
              ),
              SizedBox(height: 20.0,),
              buildSettingItem(
                  icon: Icons.contact_support_rounded,
                  text: contactUs,
                function: (){}
              ),
              SizedBox(height: 20.0,),
              buildSettingItem(
                  icon: Icons.info,
                  text: about,
                function: (){
                    showAdaptiveDialog(context: context, builder: (context) =>
                      AlertDialog(
                        title: const Text('حول التطبيق'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(aboutApp),
                            const SizedBox(height: 10.0,),
                            const Text('نسخة التطبيق: $appVersion'),
                            const SizedBox(height: 10.0,),
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
                      )
                    );
                }
              ),
            ],
          )
        ],
      ),
    );
  }
}
