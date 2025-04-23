import 'package:eftkdny/layout/main_layout.dart';
import 'package:eftkdny/modules/Auth/login_screen.dart';
import 'package:eftkdny/modules/Home/cubit/cubit.dart';
import 'package:eftkdny/modules/Home/home_screen.dart';
import 'package:eftkdny/modules/New%20Child/add_screen.dart';
import 'package:eftkdny/shared/components/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'modules/Auth/cubit/cubit.dart';
import 'shared/bloc_observer.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/styles/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  Widget widget;
  uId = CacheHelper.getData(key: 'uId') ?? '';

  if (uId.isNotEmpty) {
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
    print(uId);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AuthCubit()),
        BlocProvider(create: (BuildContext context) => HomeCubit()),
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