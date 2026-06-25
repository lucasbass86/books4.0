// ignore_for_file: use_build_context_synchronously

import 'package:books4/dialogs/dialogs.dart';
import 'package:books4/models/versiones_model.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/providers/mainprovider.dart';
import 'package:books4/services/license_service.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/services/update_service.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
            await _checkLicense(context);
            await _checkUpdates(context);
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
      drawer: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.globalPosition.dx < 30) {
            SystemNavigator.pop();
          }
        },
        child: DrawerWidget(),
      ),
      body: !servicio.isLoading
          ? ListaPage()
          : Center(child: Image.asset('assets/book.gif', width: 200, height: 200)),
    );
  }

  Future<void> _checkUpdates(BuildContext context) async {
    late PackageInfo packageInfo;
    final hasConnected = await Utils.checkConnection();
    if (hasConnected) {
      PackageInfo.fromPlatform().then((value) async {
        packageInfo = value;
        if (!context.mounted) return;
        final version = await Provider.of<UpdateService>(context, listen: false).getVersiones();
        if (version.isNotEmpty) {
          Versiones v = version
              .firstWhere((v) => v.appname.toUpperCase() == UpdateService.appName.toUpperCase());
          UpdateService.urlUpdatePath = v.appurl;
          if (int.parse(packageInfo.version.replaceAll('.', '')) <
              int.parse(v.appversion.replaceAll('.', ''))) {
            if (context.mounted) {
              Navigator.pushNamed(context, UpdatePage.routeName);
            }
          }
        }
      });
    }
  }

  Future<void> _checkLicense(BuildContext context) async {
    final cnx = await Utils.checkConnection();
    // Preferences.license = '';
    if (cnx && Preferences.license.isEmpty) {
      if (context.mounted) {
        final em = await showDialogInput(context,
            subtitle: 'Se envía un código de verificación para registrarse.',
            label: 'Email',
            inputType: TextInputType.emailAddress);
        if (em[0]) {
          final GetLicenseCodeResponse r = await LicenseService.obtainLicense(em[1]);
          if (r.status == LicenseService.success && context.mounted) {
            final code = await showDialogInput(context,
                label: 'Código', subtitle: 'Introduce el código de verificación', maxLength: 13);
            if (code[0]) {
              final GetLicenseCodeResponse r2 = await LicenseService.setLicenseCode(code[1], em[1]);
              if (r2.status == LicenseService.success && context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(Utils.snackBar('Registrado correctamente'));
                Preferences.license = code[1];
              }
            } else {
              SystemNavigator.pop();
            }
          }
        } else {
          SystemNavigator.pop();
        }
      }
    } else if (cnx && Preferences.license.isNotEmpty) {
      final GetLicenseCodeResponse r = await LicenseService.checkLicenseCode(Preferences.license);
      if (r.status == LicenseService.success) {
        MapData licenseData = r.data as MapData;
        if (licenseData.license != null) {
          if (licenseData.license!.locked == 1) {
            if (context.mounted) {
              await showMessage(
                      context: context,
                      message:
                          'Esta licencia está bloqueada. Contacta con ${LicenseService.emailDev}')
                  .then((_) {
                SystemNavigator.pop();
              });
            }
          }
          if (licenseData.license!.message.isNotEmpty) {
            if (context.mounted) {
              await showMessage(context: context, message: licenseData.license!.message);
            }
          }
        }
      } else {
        if (context.mounted) {
          await showMessage(
                  context: context,
                  message:
                      'Ha habido un problema con la licencia. Contacta con ${LicenseService.emailDev}')
              .then((_) {
            SystemNavigator.pop();
          });
        }
      }
    } else if (!cnx && Preferences.license.isEmpty) {
      if (context.mounted) {
        await showMessage(
                context: context, message: 'Necesita tener conexión para verificar la licencia')
            .then((_) {
          SystemNavigator.pop();
        });
      }
    }
  }
}
