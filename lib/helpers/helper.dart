import 'package:books4/dialogs/dialogs.dart';
import 'package:books4/models/models.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Helper {
  static void restPages(
      {required BuildContext context, required Libro libro, Leyendo? leyendo}) async {
    if (leyendo == null) {
      leyendo = Leyendo(codigoLibro: libro.codigo, paginas: 0);
      Preferences.addLeyendo(leyendo);
    }
    final resp = await inputBox(context, '¿Páginas leídas?',
        textInputType: TextInputType.number,
        textAlign: TextAlign.center,
        value: leyendo.paginas != -1 ? leyendo.paginas.toString() : '');
    if (resp[0]) {
      int paginas = int.parse(resp[1]);
      if (paginas > libro.paginas && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Número de páginas incorrecto',
            isGood: false, isFloating: true, isRounded: true));
        return;
      }
      leyendo.paginas = paginas;
      Preferences.updateLeyendo(leo: leyendo);
      DateTime inicio = DateTime.parse(Utils.dateStringSpanishToEnglish(libro.fechInicio));
      int llevo = DateTime.now().difference(inicio).inDays;
      if (llevo == 0) llevo = 1;
      int restante = (libro.paginas * llevo / paginas).ceil() - llevo;
      int pagsPorDia = (paginas / llevo).ceil();
      int pagsRestantes = restante != 0 ? ((libro.paginas - paginas) / restante).ceil() : 0;
      String msg =
          'A este ritmo ($pagsPorDia ppd) ${restante == 1 ? 'queda un día' : 'quedan unos $restante días'} para acabar el libro, a $pagsRestantes ppd.';
      if (pagsRestantes == 0) {
        msg = 'Ya has acabado el libro!';
      }
      if (!context.mounted) return;
      showModalBottomSheet(
        backgroundColor: Utils.colorContainer,
        context: context,
        builder: (context) {
          return Container(
            height: 270,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Utils.colorContainer,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Utils.radiusCircular),
                  topRight: Radius.circular(Utils.radiusCircular)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    double w = constraints.maxWidth;
                    return ProgressBarWidget(
                      width: w,
                      currentValue: paginas,
                      maxValue: libro.paginas,
                      backgroundColor: Utils.colorCard,
                      progressColor: Utils.colorEtiqueta,
                      textStyle: Utils.mainTextStyle,
                      showCurrentValue: true,
                      showValues: true,
                      showRestValue: true,
                      valueTextStyle: Utils.mainTextStyle.copyWith(fontSize: 13),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Text(msg),
                if (pagsRestantes != 0)
                  Text(
                      'Fecha aproximada de fin: ${Utils.dateEnglishToSpanish(DateTime.now().add(Duration(days: restante)).toString(), showTime: false)}'),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Aceptar'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
