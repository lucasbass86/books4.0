import 'dart:io';

import 'package:books4/models/models.dart';
import 'package:books4/secret/secret.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Utils {
  //COLOR SVG 53bfbc
  static const String password = Secret.masterPassword;
  static const String todos = 'TODOS';
  static const String leidos = 'LEÍDOS';
  static const String pendientes = 'PENDIENTES';
  static const String id = 'ID';
  static const String paginas = 'PÁGINAS';
  static const String titulo = 'TÍTULO';
  static const String autor = 'AUTOR';
  static const String fechaCompra = 'FECHA COMPRA';
  static const String fechaLeido = 'FECHA LEÍDO';
  static const String fechaIniciado = 'FECHA INICIADO';
  static const String categoria = 'CATEGORÍA';
  static const String nota = 'NOTA';
  static const String precio = 'PRECIO';
  static const String ascendente = 'ASCENDENTE';
  static const String descendente = 'DESCENDENTE';

  static List<Libro> recomendados = [];
  static String filterAutor = '';
  static String filterCategoria = '';

  static List<String> orderLibros = <String>[
    id,
    titulo,
    autor,
    categoria,
    paginas,
    fechaCompra,
    fechaLeido,
    fechaIniciado,
    nota,
    precio,
  ];
  static List<String> orderLibrosAscDes = <String>[ascendente, descendente];
  static const double cardheight = 130;
  static const double iconSize = 40;
  static const double radiusCircular = 40;

  static final Image noImage = Image.asset('assets/no_image.jpg');
  static final String urlNotFound = 'assets/svg/not_found.svg';

////////////////////////////////////////////////////////////////////////////
  static const IconData iconVistaLista = Icons.list_alt;
  static const IconData iconVistaGrilla = Icons.view_comfy_alt_outlined;
  static const IconData iconVistaPortada = Icons.view_carousel_rounded;
  static const IconData iconVistaListaGlass = Icons.view_agenda_rounded;
  static IconData iconVistaSelected = Icons.palette_outlined;
  static const IconData iconView = Icons.palette_outlined;

  static const IconData iconFilter = Icons.filter_alt;
  static const IconData iconHome = Icons.home_filled;
  static const IconData iconAutor = Icons.person_outline_rounded;
  static const IconData iconCategoria = Icons.label_important_outline;
  static const IconData iconLista = Icons.view_list_rounded;
  static const IconData iconSearch = Icons.search;
  static const IconData iconOrder = Icons.view_kanban_outlined;
  static const IconData iconEditorial = Icons.business;
  static const IconData iconColecciones = Icons.auto_stories;

////////////////////////////////////////////////////////////////////////////
  static Color colorIcon = Colors.grey[600]!;
  static Color colorScaffold = Color(0xff292929);
  static Color colorEtiqueta = Colors.grey[600]!;
  static Color colorEtiquetaTexto = Colors.grey[800]!;
  static Color colorDot = Colors.amber[100]!;
  static Color colorContainer = Colors.grey;
  static Color colorCard = Colors.grey[400]!;
  static Color colorTop = Colors.grey[400]!;
  static Color circulo1 = Colors.grey[600]!;
  static Color circulo2 = Colors.grey[800]!;
  static Color circulo3 = Colors.grey[200]!.withAlpha((0.8 * 255).toInt());
  static Color circulo4 = Colors.grey[300]!;
  static Color bottom = Colors.grey;

  static Color bottomIconColorSelected = Color(0xffc1c1c1);
  static Color bottomIconColorUnselected = Color(0xff272727);

  static TextStyle mainTextStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[600]);
  static TextStyle secondTextStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.grey[600]);
  static TextStyle thirdTextStyle =
      TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: colorDot);

  static Color colorFontTop = Colors.white;

  static BoxShadow boxShadow = BoxShadow(
    color: Utils.circulo1.withAlpha((0.5 * 255).toInt()),
    blurRadius: 10,
    spreadRadius: 7,
    offset: const Offset(0, 5),
  );
  static BoxShadow boxShadowUp = BoxShadow(
    color: Utils.circulo1.withAlpha((0.5 * 255).toInt()),
    blurRadius: 10,
    spreadRadius: 7,
    offset: const Offset(0, -5),
  );

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );
    return darkened.toColor();
  }

  static bool isConnected = false;
  static Future<bool> checkConnection() async {
    try {
      final result =
          await InternetAddress.lookup('www.google.es').timeout(const Duration(seconds: 3));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response =
            await http.get(Uri.parse('https://www.google.es')).timeout(const Duration(seconds: 3));

        isConnected = response.statusCode == 200;
        return isConnected;
      }
    } catch (_) {}

    isConnected = false;
    return false;
  }

  static String limpiar(String texto) {
    return texto
        .replaceAll('<p>', '')
        .replaceAll('<b>', '')
        .replaceAll('</b>', '')
        .replaceAll('</p>', '')
        .replaceAll('<i>', '')
        .replaceAll('</i>', '')
        .replaceAll('<u>', '')
        .replaceAll('</u>', '')
        .replaceAll('<br>', '')
        .replaceAll('</br>', '');
  }

  static String fill(String cadena, String caracter, int longitud, bool porIzquierda) {
    String dv = "";
    for (int i = 0; i < longitud - cadena.length; i++) {
      dv += caracter;
    }

    if (porIzquierda) {
      return dv + cadena;
    } else {
      return cadena + dv;
    }
  }

  static String dateStringSpanishToEnglish(String date) {
    if (date.isNotEmpty) {
      String year = date.substring(6, 10);
      String month = date.substring(3, 5);
      String day = date.substring(0, 2);
      return "$year-$month-$day";
    } else {
      return '';
    }
  }

  static DateTime dateSpanishToEnglish(String date) {
    String year = date.substring(6, 10);
    String month = date.substring(3, 5);
    String day = date.substring(0, 2);
    return DateTime(int.parse(year), int.parse(month), int.parse(day));
  }

  static String dateEnglishToSpanish(String date, {bool showTime = true}) {
    String year = date.substring(0, 4);
    String month = date.substring(5, 7);
    String day = date.substring(8, 10);
    if (!showTime) {
      return "$day-$month-$year";
    } else {
      String hour = date.substring(11, 13);
      String minute = date.substring(14, 16);
      // String seconds = date.substring(17, 19);
      return "$day-$month-$year $hour:$minute";
    }
  }

  static SnackBar snackBar(String title,
      {bool isGood = true, bool isFloating = false, bool isRounded = false}) {
    return SnackBar(
      behavior: isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      content: Text(
        title,
        style: TextStyle(color: isGood ? Colors.white : Colors.black),
        textAlign: TextAlign.center,
      ),
      backgroundColor: isGood ? Colors.green[200] : Colors.red[200],
      shape: isRounded ? StadiumBorder() : null,
    );
  }

  static String dateInterval(String d1, String d2) {
    DateTime dateTime1 = dateSpanishToEnglish(d1);
    DateTime dateTime2 = dateSpanishToEnglish(d2);
    return '${dateTime2.difference(dateTime1).inDays} días';
  }

  static Size getTextSize(String text, TextStyle style, {double maxWidth = double.infinity}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.size;
  }

  static String getYear(String date) {
    return date.length == 10 ? date.substring(6, 10) : '';
  }

  static String getImgURL(int id) =>
      'http://www.escayolasdelucas.com/apps/libros/images/libros/libro${Utils.fill(id.toString(), '0', 4, true)}.jpg';

  static String getImgUrlCategoria(String id) =>
      'http://www.escayolasdelucas.com/apps/libros/images/categorias/categoria$id.jpg';

  static Color getCategoryColor(String category) {
    switch (category.toUpperCase().trim()) {
      case "CIENCIA FICCION":
        return Colors.deepPurpleAccent;
      case "DIVULGACION CIENTIFICA":
        return Colors.tealAccent.shade700;
      case "ARTE":
        return Colors.pinkAccent;
      case "FANTASTICA":
        return Colors.purple.shade400;
      case "TERROR":
        return Colors.red.shade700;
      case "AUTOAYUDA / PSICOLOGIA":
      case "AUTOAYUDA/PSICOLOGIA":
        return Colors.amber.shade600;
      case "NOVELA NEGRA":
        return Colors.grey.shade700;
      case "ROMANTICA":
        return Colors.pink.shade400;
      case "HISTORICA":
        return Colors.brown.shade400;
      case "BIOGRAFIA":
        return Colors.blueGrey.shade600;
      case "NARRATIVA":
        return Colors.lightBlueAccent;
      case "NOVELA GRAFICA":
        return Colors.deepOrangeAccent;
      case "FILOSOFIA / RELIGION":
      case "FILOSOFIA/RELIGION":
        return Colors.deepPurple.shade300;
      case "NUTRICION / SALUD / BIENESTAR":
      case "NUTRICION/SALUD/BIENESTAR":
        return Colors.green.shade500;
      case "DEPORTES":
        return Colors.orangeAccent;
      case "POLITICA":
        return Colors.redAccent.shade700;
      case "VIAJES":
        return Colors.cyan.shade600;
      case "TEATRO":
        return Colors.lime.shade600;
      case "APRENDIZAJE":
        return Colors.indigoAccent;
      default:
        return Colors.blueAccent;
    }
  }

  static IconData getCategoryIcon(String category) {
    switch (category.toUpperCase()) {
      case "APRENDIZAJE":
        return Icons.school_rounded;
      case "ARTE":
        return Icons.palette_rounded;
      case "AUTOAYUDA / PSICOLOGIA":
        return Icons.psychology_rounded;
      case "BIOGRAFIA":
        return Icons.person_rounded;
      case "CIENCIA FICCION":
        return Icons.rocket_launch_rounded;
      case "DEPORTES":
        return Icons.sports_basketball_rounded;
      case "DIVULGACION CIENTIFICA":
        return Icons.science_rounded;
      case "FANTASTICA":
        return Icons.auto_awesome_rounded;
      case "FILOSOFIA / RELIGION":
        return Icons.temple_buddhist_rounded;
      case "HISTORICA":
        return Icons.account_balance_rounded;
      case "NARRATIVA":
        return Icons.menu_book_rounded;
      case "NOVELA GRAFICA":
        return Icons.draw_rounded;
      case "NOVELA NEGRA":
        return Icons.local_police_rounded;
      case "NUTRICION / SALUD / BIENESTAR":
        return Icons.favorite_rounded;
      case "OTROS IDIOMAS":
        return Icons.language_rounded;
      case "POLITICA":
        return Icons.gavel_rounded;
      case "ROMANTICA":
        return Icons.favorite_border_rounded;
      case "TEATRO":
        return Icons.theater_comedy_rounded;
      case "TERROR":
        return Icons.nightlight_round_rounded;
      case "VIAJES":
        return Icons.flight_takeoff_rounded;
      default:
        return Icons.book_rounded;
    }
  }
}

class CategoryStyle {
  final Color baseColor;

  CategoryStyle(this.baseColor);

  /// Fondo oscuro/transparente
  Color get background => baseColor.withAlpha((255 * 0.68).toInt());

  /// Borde opcional
  Color get border => baseColor.withAlpha((255 * 0.30).toInt());

  /// Texto/Icono brillante
  Color get foreground => lighten(baseColor, 0.25);

  /// Método para aclarar colores
  static Color lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);

    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );

    return hslLight.toColor();
  }
}
