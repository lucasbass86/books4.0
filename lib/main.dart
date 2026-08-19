import 'package:books4/pages/_pages.dart';
import 'package:books4/providers/librarymanager.dart';
import 'package:books4/providers/mainprovider.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/routes/routes.dart';
import 'package:books4/themes/theme.dart';
import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'shared_preferences/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await Preferences.init();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => Servicio(), lazy: true),
        ChangeNotifierProvider(create: (_) => LibraryManager(), lazy: true),
      ],
      child: FutureBuilder(
        future: Utils.checkConnection(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isConnected = snapshot.data as bool;
            if (isConnected) {
              return const MyApp();
            } else {
              return const MyAppNoConnection();
            }
          } else {
            return const MyAppNoConnection();
          }
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Books 4.0',
      routes: routes,
      initialRoute: MainPage.routeName,
      theme: oscuro,
    );
  }
}

class MyAppNoConnection extends StatelessWidget {
  const MyAppNoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Books 4.0',
      routes: routes,
      initialRoute: NoConnectionPage.routeName,
      theme: oscuro,
    );
  }
}
