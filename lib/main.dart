import 'package:eftkdny/layout/main_layout.dart';
import 'package:eftkdny/modules/Auth/login_screen.dart';
import 'package:eftkdny/modules/Home/cubit/cubit.dart';
import 'package:eftkdny/shared/components/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'layout/cubit/cubit.dart';
import 'modules/Auth/cubit/cubit.dart';
import 'shared/bloc_observer.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/styles/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await clearOldCache();

  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();

  bool isLoggedIn = CacheHelper.getData(key: 'isLoggedIn') ?? false;

  Widget widget;
  uId = CacheHelper.getData(key: 'uId') ?? '';

  if (uId.isNotEmpty || isLoggedIn) {
    widget = MainLayout();
  }else{
    widget = LoginScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {


  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AuthCubit()),
        BlocProvider(create: (BuildContext context) => LayoutCubit()),
        BlocProvider(create: (BuildContext context) => HomeCubit()..getUserData()..getClassNames()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ar'),
        ],
          debugShowCheckedModeBanner: false,

          theme: lightTheme,
          home: startWidget,
      ),
    );
  }
}

Future<void> clearOldCache() async {
  try {
    final dir = await getTemporaryDirectory();
    final size = await _getFolderSize(dir);

    if (size > 10 * 1024 * 1024) { // 10MB threshold
      final files = dir.listSync();
      for (final file in files) {
        if (file is File) {
          await file.delete();
        } else if (file is Directory) {
          await file.delete(recursive: true);
        }
      }
      print('Cache cleared successfully');
    }
  } catch (e) {
    print('Error clearing cache: $e');
  }
}

// Helper function to calculate folder size
Future<int> _getFolderSize(Directory dir) async {
  var size = 0;
  try {
    final files = dir.listSync(recursive: true);
    for (final file in files) {
      if (file is File) {
        size += await file.length();
      }
    }
  } catch (e) {
    print('Error calculating folder size: $e');
  }
  return size;
}