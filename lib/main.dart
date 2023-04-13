
import 'package:edilclima_app/Components/MainScreenContent.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Screens/GameBoardScreen.dart';
import 'package:edilclima_app/Screens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import 'Screens/CardInfoScreen.dart';
import 'Screens/OtherTeamsScreen.dart';
import 'Screens/RetriveCardScreen.dart';
import 'firebase_options.dart';
import 'package:edilclima_app/GameModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/CameraScreen.dart';
import 'Screens/MatchMakingScreen.dart';
import 'Screens/WaitingScreen.dart';
import 'Screens/CardSelectionScreen.dart';

//todo: qui devi aggiungere un await e capire perchè va avanti all' infinito
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(create: (context) => GameModel(),
    child : const MainApp(),),
  );
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();


//todo: risistema le routes in modo che si possa tornare indietro con il tasto del device, ma togli lo splash dallo stack
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: "/initialScreen",
  routes: [
    ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainScreenContent(child);
        },
        routes: [
          GoRoute(path: "/cardSelectionScreen",
              pageBuilder: (context, state) {
                return NoTransitionPage(child: CardSelectionScreen());
              },
              parentNavigatorKey: shellNavigatorKey,
              routes: [ GoRoute(path: "cardInfoScreen",
                  parentNavigatorKey: shellNavigatorKey,
                  pageBuilder: (context, state) {
                    return NoTransitionPage(child: CardInfoScreen());
                  }
              )]
          ),
          GoRoute(path: "/retriveCardScreen",
              parentNavigatorKey: shellNavigatorKey,
              pageBuilder: (context, state) {
                return NoTransitionPage(child: RetriveCardScreen());
              }
          ),
          GoRoute(path: "/otherTeamsScreen",
              parentNavigatorKey: shellNavigatorKey,
              pageBuilder: (context, state) {
                return NoTransitionPage(child: OtherTeamsScreen());
              }
          ),
        ]
    ),
    GoRoute(
      path: '/initialScreen',
        parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) { return WaitingScreen();},
      routes: [
        GoRoute(
          path: 'cameraScreen',
            parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => CameraScreen(),
          routes: [
            GoRoute(
              path: 'splashScreen',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => SplashScreen(),
        ),
      ]
    ),
      GoRoute(
          path: 'matchMakingScreen',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => MatchMakingScreen(),
          routes: [
            GoRoute(
              path: 'gameBoardScreen',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => GameBoardScreen(),
            ),
          ]
      ),
  ],
)]);

class MainApp extends StatelessWidget{
  const MainApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

      return MaterialApp.router(
        title: 'Edilclima',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: darkBluePalette,
              elevation: 0,
            ),
            fontFamily: 'Roboto'
        ),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      );
  }
}