
import 'package:edilclima_app/Components/MainScreenContent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';

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

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: "/initialScreen",
  routes: [
    ShellRoute(
       navigatorKey: shellNavigatorKey,
       builder: (context, state, child) {
         return MainScreenContent(child);
       },
      routes: <RouteBase>[
        GoRoute(path: "/cardSelectionScreen",
          pageBuilder: (context, state) {
          return NoTransitionPage(child: CardSelectionScreen());
          }
        ),
        GoRoute(path: "/retriveCardScreen",
            pageBuilder: (context, state) {
              return NoTransitionPage(child: RetriveCardScreen());
            }
        ),
        GoRoute(path: "/otherTeamsScreen",
            pageBuilder: (context, state) {
              return NoTransitionPage(child: OtherTeamsScreen());
            }
        )
      ]
    ),
    GoRoute(
      path: '/initialScreen',
      builder: (context, state) => WaitingScreen(),
    ),
    GoRoute(
      path: '/matchMakingScreen',
      builder: (context, state) => MatchMakingScreen(),
    ),
    GoRoute(
      path: '/gameBoardScreen',
      builder: (context, state) => WaitingScreen(),
    ),
    GoRoute(
      path: '/cameraScreen',
      builder: (context, state) => CameraScreen(),
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    print("into build main app");
    return MaterialApp.router(
      title: 'Edilclima',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}