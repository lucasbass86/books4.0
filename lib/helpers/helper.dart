import 'package:books4/dialogs/dialogs.dart';
import 'package:books4/models/models.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Helper {
  // static void restPages(
  //     {required BuildContext context, required Libro libro, Leyendo? leyendo}) async {
  //   if (leyendo == null) {
  //     int leibles = libro.paginas;
  //     final resp = await inputBox(context, 'Páginas de contenido',
  //         textAlign: TextAlign.center, value: leibles.toString());
  //     if (resp[0] != null && int.tryParse(resp[1]) != null) {
  //       leibles = int.parse(resp[1]);
  //     }
  //     leyendo = Leyendo(codigoLibro: libro.codigo, paginas: 0, leibles: leibles);
  //     Preferences.addLeyendo(leyendo);
  //   }
  //   if (!context.mounted) return;
  //   final resp = await inputBox(context, '¿Páginas leídas?',
  //       textInputType: TextInputType.number,
  //       textAlign: TextAlign.center,
  //       value: leyendo.paginas != -1 ? leyendo.paginas.toString() : '');
  //   if (resp[0]) {
  //     int paginas = int.parse(resp[1]);
  //     if (paginas > libro.paginas && context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Número de páginas incorrecto',
  //           isGood: false, isFloating: true, isRounded: true));
  //       return;
  //     }
  //     leyendo.paginas = paginas;
  //     int leibles = libro.paginas;
  //     if (leyendo.leibles == 0 && context.mounted) {
  //       final resp = await inputBox(context, 'Páginas de contenido',
  //           textAlign: TextAlign.center, value: leibles.toString());
  //       if (resp[0] != null && int.tryParse(resp[1]) != null) {
  //         leibles = int.parse(resp[1]);
  //         leyendo.leibles = leibles;
  //       }
  //     }
  //     Preferences.updateLeyendo(leo: leyendo);
  //     DateTime inicio = DateTime.parse(Utils.dateStringSpanishToEnglish(libro.fechInicio));
  //     int llevo = DateTime.now().difference(inicio).inDays;
  //     if (llevo == 0) llevo = 1;
  //     // int restante = (libro.paginas * llevo / paginas).ceil() - llevo;
  //     int restante = (leyendo.leibles * llevo / paginas).ceil() - llevo;
  //     int pagsPorDia = (paginas / llevo).ceil();
  //     int pagsRestantes = restante != 0 ? ((leyendo.leibles - paginas) / restante).ceil() : 0;
  //     String msg =
  //         'A este ritmo ($pagsPorDia ppd) ${restante == 1 ? 'queda un día' : 'quedan unos $restante días'} para acabar el libro, a $pagsRestantes ppd.';
  //     if (pagsRestantes == 0) {
  //       msg = 'Ya has acabado el libro!';
  //     }
  //     if (!context.mounted) return;
  //     showModalBottomSheet(
  //       backgroundColor: Utils.colorContainer,
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           height: 270,
  //           padding: const EdgeInsets.all(20),
  //           decoration: BoxDecoration(
  //             color: Utils.colorContainer,
  //             borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(Utils.radiusCircular),
  //                 topRight: Radius.circular(Utils.radiusCircular)),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               const SizedBox(height: 10),
  //               LayoutBuilder(
  //                 builder: (context, constraints) {
  //                   double w = constraints.maxWidth;
  //                   return ProgressBarWidget(
  //                     width: w,
  //                     currentValue: paginas,
  //                     maxValue: leyendo!.leibles,
  //                     backgroundColor: Utils.colorCard,
  //                     progressColor: Utils.colorEtiqueta,
  //                     textStyle: Utils.mainTextStyle,
  //                     showCurrentValue: true,
  //                     showValues: true,
  //                     showRestValue: true,
  //                     valueTextStyle: Utils.mainTextStyle.copyWith(fontSize: 13),
  //                   );
  //                 },
  //               ),
  //               const SizedBox(height: 10),
  //               Text(msg),
  //               if (pagsRestantes != 0)
  //                 Text(
  //                     'Fecha aproximada de fin: ${Utils.dateEnglishToSpanish(DateTime.now().add(Duration(days: restante)).toString(), showTime: false)}'),
  //               const SizedBox(height: 10),
  //               Row(mainAxisAlignment: MainAxisAlignment.end, spacing: 10, children: [
  //                 OutlinedButton(
  //                   onPressed: () async {
  //                     await resetRestPages(context: context, libro: libro, leyendo: leyendo!);
  //                   },
  //                   child: Text(
  //                     'Cambiar',
  //                     style: TextStyle(color: Utils.circulo3),
  //                   ),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   child: Text('Aceptar'),
  //                 ),
  //               ]),
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }
  static void restPages(
      {required BuildContext context, required Libro libro, Leyendo? leyendo}) async {
    if (leyendo == null) {
      int leibles = libro.paginas;
      final resp = await inputBox(context, 'Páginas de contenido',
          textAlign: TextAlign.center, value: leibles.toString());
      if (resp[0] != null && int.tryParse(resp[1]) != null) {
        leibles = int.parse(resp[1]);
      }
      leyendo = Leyendo(codigoLibro: libro.codigo, paginas: 0, leibles: leibles);
      Preferences.addLeyendo(leyendo);
    }
    if (!context.mounted) return;
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
      int leibles = libro.paginas;
      if (leyendo.leibles == 0 && context.mounted) {
        final resp = await inputBox(context, 'Páginas de contenido',
            textAlign: TextAlign.center, value: leibles.toString());
        if (resp[0] != null && int.tryParse(resp[1]) != null) {
          leibles = int.parse(resp[1]);
          leyendo.leibles = leibles;
        }
      }
      Preferences.updateLeyendo(leo: leyendo);
      DateTime inicio = DateTime.parse(Utils.dateStringSpanishToEnglish(libro.fechInicio));
      int llevo = DateTime.now().difference(inicio).inDays;
      if (llevo == 0) llevo = 1;
      // int restante = (libro.paginas * llevo / paginas).ceil() - llevo;
      // int restante = (leyendo.leibles * llevo / paginas).ceil() - llevo;
      // int pagsPorDia = (paginas / llevo).ceil();
      // int pagsRestantes = restante != 0 ? ((leyendo.leibles - paginas) / restante).ceil() : 0;
      // String msg =
      //     'A este ritmo ($pagsPorDia ppd) ${restante == 1 ? 'queda un día' : 'quedan unos $restante días'} para acabar el libro, a $pagsRestantes ppd.';
      // if (pagsRestantes == 0) {
      //   msg = 'Ya has acabado el libro!';
      // }
      if (!context.mounted) return;
      showModalBottomSheet(
        backgroundColor: Utils.colorContainer,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              int restante = (leyendo!.leibles * llevo / paginas).ceil() - llevo;
              int pagsPorDia = (paginas / llevo).ceil();
              int pagsRestantes =
                  restante != 0 ? ((leyendo!.leibles - paginas) / restante).ceil() : 0;
              String msg =
                  'A este ritmo ($pagsPorDia ppd) ${restante == 1 ? 'queda un día' : 'quedan unos $restante días'} para acabar el libro, a $pagsRestantes ppd.';
              if (pagsRestantes == 0) {
                msg = 'Ya has acabado el libro!';
              }
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
                          maxValue: leyendo!.leibles,
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
                    Row(mainAxisAlignment: MainAxisAlignment.end, spacing: 10, children: [
                      OutlinedButton(
                        onPressed: () async {
                          leyendo = await resetRestPages(
                              context: context, libro: libro, leyendo: leyendo!);
                          setState(
                            () {},
                          );
                        },
                        child: Text(
                          'Cambiar',
                          style: TextStyle(color: Utils.circulo3),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Aceptar'),
                      ),
                    ]),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  static Future<Leyendo> resetRestPages(
      {required BuildContext context, required Libro libro, required Leyendo leyendo}) async {
    int leibles = leyendo.leibles;
    final resp = await inputBox(context, 'Páginas de contenido',
        textAlign: TextAlign.center, value: leibles.toString());
    if (resp[0] != null && int.tryParse(resp[1]) != null) {
      leibles = int.parse(resp[1]);
      leyendo.leibles = leibles;
      Preferences.updateLeyendo(leo: leyendo);
    }
    return leyendo;
  }
}
