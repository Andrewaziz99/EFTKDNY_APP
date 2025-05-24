import 'package:eftkdny/layout/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import '../shared/components/constants.dart';
import 'cubit/cubit.dart';

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
              // if(cubit.currentIndex == 2)
              //   IconButton(
              //     onPressed: () {
              //       // cubit.getAnswers();
              //     },
              //     icon: const Icon(Icons.file_upload, color: Colors.white),
              //     tooltip: uploadFile,
              //   ),
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
