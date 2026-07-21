import 'package:animate_do/animate_do.dart';
import 'package:books4/dialogs/dialogs.dart';
import 'package:books4/secret/secret.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class LicenseData {}

class ListData extends LicenseData {
  final List<dynamic> value;
  ListData(this.value);
}

class BoolData extends LicenseData {
  final bool value;
  BoolData(this.value);
}

class IntData extends LicenseData {
  final int value;
  IntData(this.value);
}

class StringData extends LicenseData {
  final String value;
  StringData(this.value);
}

class MapData extends LicenseData {
  final Map value;
  License? license;
  MapData({required this.value, this.license}) {
    license = License.fromJson(value as Map<String, dynamic>);
  }
}

GetLicenseCodeResponse getLicenseCodeResponseFromJson(String str) =>
    GetLicenseCodeResponse.fromJson(json.decode(str));

class GetLicenseCodeResponse {
  String status;
  String message;
  LicenseData data;

  GetLicenseCodeResponse({required this.status, required this.message, required this.data});

  factory GetLicenseCodeResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json["data"];
    dynamic data;

    if (dataJson is List) {
      data = ListData(dataJson);
    } else if (dataJson is bool) {
      data = BoolData(dataJson);
    } else if (dataJson is String) {
      data = StringData(dataJson);
    } else if (dataJson is int) {
      data = IntData(dataJson);
    } else if (dataJson is Map) {
      data = MapData(value: dataJson);
    } else {
      throw FormatException('Invalid data type: $dataJson');
    }

    return GetLicenseCodeResponse(
      status: json["status"] as String,
      message: json["message"] as String,
      data: data,
    );
  }
}

class License {
  String license;
  String app;
  String email;
  DateTime activatedDate;
  int locked;
  String message;

  License({
    required this.license,
    required this.app,
    required this.email,
    required this.activatedDate,
    required this.locked,
    required this.message,
  });

  factory License.fromJson(Map<String, dynamic> json) => License(
        license: json["LICENSE"],
        app: json["APP"],
        email: json["EMAIL"],
        activatedDate: DateTime.parse(json["ACTIVATED_DATE"]),
        locked: int.parse(json["LOCKED"]),
        message: json["MESSAGE"],
      );
}

class LicenseService {
  static final String appName = Secret.appName;
  static final String success = 'success';
  static final String error = 'error';
  static final String emailDev = Secret.emailDev;
  static final String baseUrl = Secret.licenseBaseUrl;

  static Future<GetLicenseCodeResponse> obtainLicense(String email) async {
    final url = Uri.parse('${baseUrl}get_license.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'app': appName}),
    );
    GetLicenseCodeResponse licenseCodeResponse = GetLicenseCodeResponse.fromJson(
      json.decode(response.body),
    );
    return licenseCodeResponse;
  }

  static Future<GetLicenseCodeResponse> setLicenseCode(String licenseCode, String email) async {
    final url = Uri.parse('${baseUrl}set_license.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'license': licenseCode, 'app': appName, 'email': email}),
    );
    GetLicenseCodeResponse licenseCodeResponse = GetLicenseCodeResponse.fromJson(
      json.decode(response.body),
    );
    return licenseCodeResponse;
  }

  static Future<GetLicenseCodeResponse> checkLicenseCode(String licenseCode) async {
    final url = Uri.parse('${baseUrl}check_license.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'license': licenseCode}),
    );
    GetLicenseCodeResponse licenseCodeResponse = GetLicenseCodeResponse.fromJson(
      json.decode(response.body),
    );
    return licenseCodeResponse;
  }

  static Future<void> checkLicense(BuildContext context) async {
    final cnx = await Utils.checkConnection();
    // Preferences.license = '';
    if (cnx && Preferences.license.isEmpty) {
      if (context.mounted) {
        final em = await showDialogInput(
          context,
          subtitle: 'Se envía un código de verificación para registrarse.',
          label: 'Email',
          inputType: TextInputType.emailAddress,
        );
        if (em[0]) {
          final GetLicenseCodeResponse r = await LicenseService.obtainLicense(em[1]);
          if (r.status == LicenseService.success && context.mounted) {
            final code = await showDialogInput(
              context,
              label: 'Código',
              subtitle: 'Introduce el código de verificación',
              maxLength: 13,
            );
            if (code[0]) {
              final GetLicenseCodeResponse r2 = await LicenseService.setLicenseCode(code[1], em[1]);
              if (r2.status == LicenseService.success && context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(Utils.snackBar('Registrado correctamente'));
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
                message: 'Esta licencia está bloqueada. Contacta con ${LicenseService.emailDev}',
              ).then((_) {
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
                'Ha habido un problema con la licencia. Contacta con ${LicenseService.emailDev}',
            cancel: false,
          );
          Preferences.license = '';
          SystemNavigator.pop();
        }
      }
    } else if (!cnx && Preferences.license.isEmpty) {
      if (context.mounted) {
        await showMessage(
          context: context,
          message: 'Necesita tener conexión para verificar la licencia',
        ).then((_) {
          SystemNavigator.pop();
        });
      }
    }
  }

  static Future<void> checkUpdates(BuildContext context) async {
    late PackageInfo packageInfo;
    final hasConnected = await Utils.checkConnection();
    if (hasConnected) {
      PackageInfo.fromPlatform().then((value) async {
        packageInfo = value;
        if (!context.mounted) return;
        final version = await UpdateService().getVersiones();
        if (version.isNotEmpty) {
          Versiones v = version.firstWhere(
            (v) => v.appname.toUpperCase() == UpdateService.appName.toUpperCase(),
          );
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
}

Future<dynamic> showDialogInput(
  BuildContext scaffoldContext, {
  TextInputType? inputType,
  String subtitle = '',
  String label = '',
  int maxLength = 75,
}) {
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  return showDialog(
    context: scaffoldContext,
    barrierDismissible: false,
    builder: (context) {
      return BounceInDown(
        child: AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Column(
            children: [Text('Indica el $label'), if (subtitle.isNotEmpty) Text(subtitle)],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      ZoomIn(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Rellena el $label';
                            }
                            return null;
                          },
                          controller: controller,
                          maxLength: maxLength,
                          decoration: InputDecoration(labelText: label, counterText: ''),
                          keyboardType: inputType ?? TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop([false]),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop([true, controller.text]);
                } else {
                  return;
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}

class UpdateService {
  final String _urlVersiones = Secret.urlVersiones;
  final String _urlUsuarios = Secret.urlUsuarios;
  final String _urlUserLock = Secret.urlUserLock;
  List<Versiones> versiones = [];
  List<CResultado> resultado = [];
  static final String appName = Secret.appName;
  static String urlUpdatePath = '';

  Future<List<Versiones>> getVersiones() async {
    final response = await http.get(Uri.parse(_urlVersiones));
    versiones = versionesFromJson(response.body);
    return versiones;
  }

  Future<List<CResultado>> setUser(String id, String info) async {
    final response = await http.post(
      Uri.parse(_urlUsuarios),
      body: {'app': appName, 'id': id, 'info': info},
    );
    resultado = cResultadoFromJson(response.body);
    return resultado;
  }

  Future<List<CResultado>> getUserLock(String id, String info) async {
    final params = {'app': appName, 'id': id};
    final uri = Uri.parse(_urlUserLock).replace(queryParameters: params);
    final response = await http.get(uri);
    resultado = cResultadoFromJson(response.body);
    return resultado;
  }
}

List<Versiones> versionesFromJson(String str) =>
    List<Versiones>.from(json.decode(str).map((x) => Versiones.fromJson(x)));

class Versiones {
  String appname;
  String appversion;
  String appurl;

  @override
  String toString() {
    return '$appname:$appversion';
  }

  Versiones({required this.appname, required this.appversion, required this.appurl});

  factory Versiones.fromJson(Map<String, dynamic> json) =>
      Versiones(appname: json["APPNAME"], appversion: json["APPVERSION"], appurl: json["APPURL"]);
}

List<CResultado> cResultadoFromJson(String str) =>
    List<CResultado>.from(json.decode(str).map((x) => CResultado.fromJson(x)));

class CResultado {
  String resultado;

  @override
  String toString() {
    return resultado;
  }

  CResultado({required this.resultado});

  factory CResultado.fromJson(Map<String, dynamic> json) =>
      CResultado(resultado: json["RESULTADO"].toString());
}

class UpdatePage extends StatelessWidget {
  static const String routeName = 'UpdatePage';
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.only(top: 30, right: 30),
                child: GestureDetector(
                  onTap: () => SystemNavigator.pop(),
                  child: Text('Salir', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          Expanded(child: Icon(Icons.download, size: 200)),
          Container(
            margin: const EdgeInsets.only(bottom: 80),
            height: 40,
            child: Center(
              child: Text(
                'Existe una versión más reciente',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
            child: ElevatedButton(
              onPressed: () async {
                !await launchUrl(
                  Uri.parse(UpdateService.urlUpdatePath),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: Text('Aceptar'),
            ),
          ),
        ],
      ),
    );
  }
}
