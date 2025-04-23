import 'package:eftkdny/layout/cubit/states.dart';
import 'package:eftkdny/modules/Home/home_screen.dart';
import 'package:eftkdny/modules/New%20Child/add_screen.dart';
import 'package:eftkdny/modules/Settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/constants.dart';


class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    // Add your screen widgets here
    HomeScreen(),
    AddScreen(),
    SettingsScreen(),
  ];
  List<String> titles = [
    // Add your titles here
    home,
    add,
    settings,
  ];

  List<IconData> icons = [
    // Add your icons here
    Icons.home,
    Icons.add,
    Icons.settings,
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(LayoutChangeBottomNavState());
  }


}
