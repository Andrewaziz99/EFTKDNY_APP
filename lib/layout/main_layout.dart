import 'package:eftkdny/layout/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import '../modules/Home/month_picker_dialog.dart';
import '../shared/components/constants.dart';
import 'cubit/cubit.dart';
import '../modules/notification_center.dart';
import '../modules/Home/cubit/cubit.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      builder: (BuildContext context, state) {
        final cubit = LayoutCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              appName,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              if (cubit.currentIndex == 0)
                PopupMenuButton<int>(
                  icon: const Icon(Icons.notifications_active, color: Colors.white),
                  position: PopupMenuPosition.under,
                  popUpAnimationStyle: AnimationStyle(reverseCurve: FlippedCurve(Curves.bounceIn)),
                  tooltip: notification,
                  onSelected: (value) {
                    if (value == 1) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NotificationCenter(),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text('Notification Center'),
                    ),
                  ],
                ),

              if (cubit.currentIndex == 1)
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                  onPressed: () {
                    // HomeCubit.get(context).generateAttendancePdf(context, friday_attendance);
                    showDialog(context: context, builder: (context) => buildMonthPickerDialog(context,
                      onDateSelected: (selectedMonth) async {
                        HomeCubit.get(context).generateAttendancePdf(context, friday_attendance, selectedMonth);
                      },
                    ));
                  },
                ),
              if (cubit.currentIndex == 2)
                IconButton(
                  icon: const Icon(Icons.upload_file_outlined, color: Colors.white),
                  tooltip: uploadFile,
                  onPressed: () {
                    HomeCubit.get(context).uploadAndParseChildrenCsv(saveToDatabase: true);

                  },
                ),
            ],
          ),
          backgroundColor: Colors.transparent,
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: SlidingClippedNavBar(
            backgroundColor: Colors.white,
            onButtonPressed: (index) {
              cubit.changeBottomNav(index);
            },
            iconSize: 30,
            activeColor: Colors.blue,
            selectedIndex: cubit.currentIndex,
            barItems: [
              BarItem(title: cubit.titles[0],
                  icon: cubit.icons[0],),
              BarItem(title: cubit.titles[1],
                  icon: cubit.icons[1],),
              BarItem(title: cubit.titles[2],
                  icon: cubit.icons[2],),
              BarItem(title: cubit.titles[3],
                  icon: cubit.icons[3],)

            ],
          ),
        );
      },
      listener: (BuildContext context, state) {  },
    );
  }
}

