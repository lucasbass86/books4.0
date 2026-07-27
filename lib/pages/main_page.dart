// ignore_for_file: use_build_context_synchronously

import 'package:books4/pages/_pages.dart';
import 'package:books4/providers/mainprovider.dart';
import 'package:books4/services/license_service.dart';
import 'package:books4/services/servicio.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const String routeName = 'MainPage';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainProvider mainProvider;
  bool _hasRun = false;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    if (!_hasRun) {
      _hasRun = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1), () async {
          if (context.mounted) {
            await LicenseService.checkLicense(context);
            await LicenseService.checkUpdates(context);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of<MainProvider>(context);
    final Servicio servicio = Provider.of<Servicio>(context);
    return Scaffold(
      body: !servicio.isLoading
          ? ListaPage()
          : Center(child: Image.asset('assets/book.gif', width: 200, height: 200)),
    );
  }
}
