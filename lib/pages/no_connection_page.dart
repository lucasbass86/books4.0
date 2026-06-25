import 'package:books4/pages/_pages.dart';
import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoConnectionPage extends StatefulWidget {
  static const String routeName = 'NoConnectionPage';
  const NoConnectionPage({super.key});

  @override
  State<NoConnectionPage> createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {
  bool isPressd = false;
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (Utils.isConnected && isPressd && context.mounted) {
        Navigator.pushReplacementNamed(context, MainPage.routeName);
      }
    });
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.only(top: 30, right: 30),
              child: GestureDetector(
                onTap: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: Text('Salir',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorContainer)),
              ),
            ),
          ),
          Expanded(child: SvgPicture.asset('assets/svg/no_signal.svg')),
          Container(
            margin: const EdgeInsets.only(bottom: 80),
            height: 40,
            child: Center(
              child: Text(
                'No hay conexión',
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: Utils.colorContainer),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Utils.checkConnection().then((value) {
              if (value) {
                isPressd = true;
                setState(() {});
              }
            }),
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Utils.colorContainer,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Center(
                child: Text('Reintentar'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
