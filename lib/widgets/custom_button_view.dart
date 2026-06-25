import 'package:books4/providers/mainprovider.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class CustomButtonView extends StatelessWidget {
  final ETypeView view;
  final IconData icon;
  const CustomButtonView({super.key, required this.view, required this.icon});

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    return Bounceable(
      onTap: () => mainProvider.selectedView = view,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: mainProvider.selectedView == view ? Utils.circulo1 : Colors.transparent,
            borderRadius: BorderRadius.circular(20)),
        child: Icon(icon,
            size: 50, color: mainProvider.selectedView == view ? Utils.circulo3 : Utils.circulo1),
      ),
    );
  }
}
