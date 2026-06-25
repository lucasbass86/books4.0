import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

void showModalTypeView(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Utils.colorContainer,
    builder: (context) {
      return Container(
        height: 150,
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vista'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButtonView(icon: Utils.iconVistaLista, view: ETypeView.lista),
                CustomButtonView(icon: Utils.iconVistaGrilla, view: ETypeView.cuadricula),
                CustomButtonView(icon: Utils.iconVistaPortada, view: ETypeView.portada),
                CustomButtonView(icon: Utils.iconVistaListaGlass, view: ETypeView.listaGlass),
              ],
            ),
          ],
        ),
      );
    },
  );
}
