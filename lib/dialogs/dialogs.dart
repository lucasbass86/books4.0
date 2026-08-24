import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

Future<dynamic> inputBox(BuildContext context, String title,
    {TextInputType textInputType = TextInputType.text,
    String? value,
    TextAlign textAlign = TextAlign.left}) {
  final TextEditingController edAnswer = TextEditingController(text: value);
  const String tooltip = 'Respuesta';
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return ZoomIn(
        child: AlertDialog(
          backgroundColor: Utils.colorCard,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Text(title,
              style: TextStyle(color: Utils.colorEtiquetaTexto), textAlign: TextAlign.center),
          content: StatefulBuilder(
            builder: (context, setState) {
              return TextFormField(
                controller: edAnswer,
                keyboardType: textInputType,
                textAlign: textAlign,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tooltip;
                  }
                  return null;
                },
              );
            },
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop([false, '']),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop([true, edAnswer.text]);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> password(BuildContext context) {
  final TextEditingController edPassword = TextEditingController();
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return ZoomIn(
        child: AlertDialog(
          backgroundColor: Utils.colorCard,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Text("Introduce el password", style: TextStyle(color: Utils.colorEtiquetaTexto)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return TextFormField(
                onChanged: (value) {},
                controller: edPassword,
                obscureText: true,
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password';
                  }
                  return null;
                },
              );
            },
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop([false, '']),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop([true, edPassword.text]);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> showMessage(
    {required BuildContext context, required String message, bool cancel = false}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return ZoomIn(
        child: AlertDialog(
          backgroundColor: Utils.colorCard,
          title: Text("Información", style: TextStyle(color: Utils.colorEtiquetaTexto)),
          content: Text(message, style: Utils.secondTextStyle),
          titleTextStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Utils.colorEtiquetaTexto, fontSize: 27),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          actions: [
            if (cancel)
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith((states) => Utils.colorEtiqueta),
                ),
                child: const Text('Cancelar'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) => Utils.colorEtiqueta),
              ),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> filterDialogLibros(BuildContext context, {ETypeFilter? filter}) {
  ETypeFilter typeFilter = filter ?? ETypeFilter.todos;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ZoomIn(
        child: AlertDialog(
          backgroundColor: Utils.colorCard,
          title: Text("Filtrar", style: TextStyle(color: Utils.colorEtiquetaTexto)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton(
                value: typeFilter,
                elevation: 16,
                iconSize: 0,
                style: TextStyle(
                  color: Utils.colorEtiquetaTexto,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(20),
                dropdownColor: Utils.circulo4,
                onChanged: <ETypeFilter>(value) {
                  setState(() {
                    typeFilter = value!;
                  });
                },
                items: ETypeFilter.values
                    .map((value) => DropdownMenuItem(value: value, child: Text(value.displayName)))
                    .toList(),
              );
            },
          ),
          titleTextStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Utils.colorEtiquetaTexto, fontSize: 27),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) => Utils.colorEtiqueta),
              ),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(typeFilter);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) => Utils.colorEtiqueta),
              ),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> orderDialogLibros(BuildContext context, {EType? type, ETypeOrder? typeOrder}) {
  EType eType = type ?? Preferences.type;
  ETypeOrder eTypeOrder = typeOrder ?? Preferences.typeOrder;
  String dropdownValue1;
  String dropdownValue2;

  switch (eType) {
    case EType.id:
      dropdownValue1 = Utils.id;
      break;
    case EType.paginas:
      dropdownValue1 = Utils.paginas;
      break;
    case EType.titulo:
      dropdownValue1 = Utils.titulo;
      break;
    case EType.autor:
      dropdownValue1 = Utils.autor;
      break;
    case EType.fechaCompra:
      dropdownValue1 = Utils.fechaCompra;
      break;
    case EType.fechaLeido:
      dropdownValue1 = Utils.fechaLeido;
      break;
    case EType.fechaIniciado:
      dropdownValue1 = Utils.fechaIniciado;
      break;
    case EType.categoria:
      dropdownValue1 = Utils.categoria;
      break;
    case EType.nota:
      dropdownValue1 = Utils.nota;
      break;
    case EType.precio:
      dropdownValue1 = Utils.precio;
  }
  switch (eTypeOrder) {
    case ETypeOrder.ascendente:
      dropdownValue2 = Utils.ascendente;
      break;
    case ETypeOrder.descendente:
      dropdownValue2 = Utils.descendente;
      break;
  }

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ZoomIn(
        child: AlertDialog(
          backgroundColor: Utils.colorCard,
          title: Text("Ordenar", style: TextStyle(color: Utils.colorEtiquetaTexto)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: dropdownValue1,
                      elevation: 16,
                      iconSize: 0,
                      style: TextStyle(
                        color: Utils.colorEtiquetaTexto,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(20),
                      dropdownColor: Utils.circulo4,
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue1 = value!;
                        });
                      },
                      items: Utils.orderLibros.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      value: dropdownValue2,
                      elevation: 16,
                      iconSize: 0,
                      style: TextStyle(
                        color: Utils.colorEtiquetaTexto,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(20),
                      dropdownColor: Utils.circulo4,
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue2 = value!;
                        });
                      },
                      items: Utils.orderLibrosAscDes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
          titleTextStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Utils.colorEtiquetaTexto, fontSize: 27),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop([false]);
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) => Utils.colorEtiqueta),
              ),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (type == null) {
                  switch (dropdownValue1) {
                    case Utils.id:
                      Preferences.type = EType.id;
                      break;
                    case Utils.paginas:
                      Preferences.type = EType.paginas;
                      break;
                    case Utils.titulo:
                      Preferences.type = EType.titulo;
                      break;
                    case Utils.autor:
                      Preferences.type = EType.autor;
                      break;
                    case Utils.fechaCompra:
                      Preferences.type = EType.fechaCompra;
                      break;
                    case Utils.fechaLeido:
                      Preferences.type = EType.fechaLeido;
                      break;
                    case Utils.fechaIniciado:
                      Preferences.type = EType.fechaIniciado;
                      break;
                    case Utils.categoria:
                      Preferences.type = EType.categoria;
                      break;
                    case Utils.nota:
                      Preferences.type = EType.nota;
                      break;
                    case Utils.precio:
                      Preferences.type = EType.precio;
                      break;
                  }
                  switch (dropdownValue2) {
                    case Utils.ascendente:
                      Preferences.typeOrder = ETypeOrder.ascendente;
                      break;
                    case Utils.descendente:
                      Preferences.typeOrder = ETypeOrder.descendente;
                      break;
                  }
                  Navigator.of(context).pop();
                } else {
                  switch (dropdownValue1) {
                    case Utils.id:
                      type = EType.id;
                      break;
                    case Utils.paginas:
                      type = EType.paginas;
                      break;
                    case Utils.titulo:
                      type = EType.titulo;
                      break;
                    case Utils.autor:
                      type = EType.autor;
                      break;
                    case Utils.fechaCompra:
                      type = EType.fechaCompra;
                      break;
                    case Utils.fechaLeido:
                      type = EType.fechaLeido;
                      break;
                    case Utils.fechaIniciado:
                      type = EType.fechaIniciado;
                      break;
                    case Utils.categoria:
                      type = EType.categoria;
                      break;
                    case Utils.nota:
                      type = EType.nota;
                      break;
                  }
                  switch (dropdownValue2) {
                    case Utils.ascendente:
                      typeOrder = ETypeOrder.ascendente;
                      break;
                    case Utils.descendente:
                      typeOrder = ETypeOrder.descendente;
                      break;
                  }
                  Navigator.of(context).pop([true, type, typeOrder]);
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) => Utils.colorEtiqueta),
              ),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> shuffleBook(
    {required BuildContext context, String autor = '', String categoria = ''}) {
  Servicio servicio = Provider.of<Servicio>(context, listen: false);
  List<Libro> noLeidos;
  if (autor.isEmpty) {
    noLeidos = servicio.libros.where((l) => l.leido == 'NO' && l.fechInicio.isEmpty).toList();
  } else {
    noLeidos = servicio.libros
        .where((l) => l.leido == 'NO' && l.autor == autor && l.fechInicio.isEmpty)
        .toList();
  }
  if (categoria.isNotEmpty) {
    noLeidos = servicio.libros
        .where((l) => l.leido == 'NO' && l.categoria == categoria && l.fechInicio.isEmpty)
        .toList();
  }

  late Libro recomendado;

  if (autor.isNotEmpty && autor != Utils.filterAutor) {
    Utils.filterAutor = autor;
    Utils.recomendados = [];
  }
  if (categoria.isNotEmpty && categoria != Utils.filterCategoria) {
    Utils.filterCategoria = categoria;
    Utils.recomendados = [];
  }

  // Caso 1: No hay libros sin leer
  if (noLeidos.isEmpty) {
    return showMessage(context: context, message: 'No se han encontrado libros sin leer.');
  }
  // Caso 2: Todos los libros han sido recomendados
  if (Utils.recomendados.length == noLeidos.length) {
    return showMessage(
        context: context, message: 'Ya se han recomendado todos los libros disponibles.');
  }
  // Filtrar libros no recomendados para evitar el bucle
  final librosDisponibles = noLeidos.where((libro) => !Utils.recomendados.contains(libro)).toList();
  // Caso 3: Seleccionar un libro aleatorio de los disponibles
  if (librosDisponibles.isNotEmpty) {
    final random = Random();
    recomendado = librosDisponibles[random.nextInt(librosDisponibles.length)];
    Utils.recomendados.add(recomendado);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        bool scrached = false;
        double visivility = 0;
        return Bounce(
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Utils.colorCard,
                title: Text(
                  "Recomendar",
                  style: TextStyle(color: Utils.colorEtiquetaTexto),
                ),
                content: SizedBox(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: scrached
                            ? () => Navigator.pushNamed(context, LibroPage.routeName,
                                arguments: recomendado)
                            : null,
                        child: ZoomIn(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Image.network(
                              height: 240,
                              width: 160,
                              fit: BoxFit.cover,
                              Utils.getImgURL(recomendado.codigo),
                              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                return Scratcher(
                                  brushSize: 30,
                                  threshold: 50,
                                  color: Utils.circulo1,
                                  onThreshold: () => setState(() => scrached = true),
                                  onChange: (value) => visivility = value / 100,
                                  child: child,
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                return loadingProgress == null
                                    ? child
                                    : CircularProgressIndicator(color: Utils.circulo4);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                actions: [
                  OutlinedButton(
                    onPressed: scrached
                        ? () {
                            Navigator.of(context).pop();
                            shuffleBook(context: context, autor: autor, categoria: categoria);
                          }
                        : null,
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Utils.colorEtiqueta),
                    ),
                    child: const Text('Otro'),
                  ),
                  AnimatedOpacity(
                    opacity: visivility,
                    duration: const Duration(seconds: 1),
                    child: ElevatedButton(
                      onPressed: scrached
                          ? () async {
                              final mark = await showMessage(
                                  context: context,
                                  message: '¿Marcar para siguiente lectura?',
                                  cancel: true);
                              if (mark == true && context.mounted) {
                                final resp = await password(context);
                                if (resp[1] == Utils.password && context.mounted) {
                                  servicio.setNextRead(recomendado.codigo).then((value) {
                                    if (value.type == 'INSERT' && context.mounted) {
                                      showMessage(context: context, message: 'Libro agregado');
                                    }
                                  });
                                  Navigator.of(context).pop();
                                } else {
                                  if (context.mounted) {
                                    showMessage(
                                        context: context, message: 'Password incorrecto...');
                                  }
                                }
                              }
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Utils.colorEtiqueta),
                      ),
                      child: const Text('Aceptar'),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
  return showMessage(context: context, message: 'No se han encontrado libros sin leer.');
}

Future<void> simpleDialog(BuildContext context, Widget content) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return Center(
        child: content,
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return Transform.scale(scale: anim.value, child: child);
    },
  );
}

Future<void> showAssetImage(BuildContext context, String assetName) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(assetName, fit: BoxFit.contain),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return Transform.scale(scale: anim.value, child: child);
    },
  );
}

Future<void> showNetworkImage(BuildContext context, String url) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,
            placeholder: (context, url) => SizedBox(
              width: 45,
              child: Center(
                child: CircularProgressIndicator(color: Utils.circulo4),
              ),
            ),
            errorWidget: (context, url, error) => Utils.noImage,
            imageBuilder: (context, imageProvider) {
              return Image(
                image: imageProvider,
                fit: BoxFit.fitWidth,
              );
            },
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return Transform.scale(scale: anim.value, child: child);
    },
  );
}

void showBooks(BuildContext context, List<Libro> libros) {
  Widget content = Scaffold(
    body: Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration:
          BoxDecoration(color: Utils.colorContainer, borderRadius: BorderRadius.circular(20)),
      child: Column(
        spacing: 20,
        children: [
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: libros.length,
              itemBuilder: (context, index) {
                final Libro libro = libros[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, LibroPage.routeName, arguments: libro),
                  child: Row(
                    spacing: 10,
                    children: [
                      Hero(
                        tag: 'libro${libro.codigo}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: Utils.getImgURL(libro.codigo),
                            fit: BoxFit.contain,
                            placeholder: (context, url) => SizedBox(
                              width: 45,
                              child: Center(
                                child: CircularProgressIndicator(color: Utils.circulo4),
                              ),
                            ),
                            errorWidget: (context, url, error) => Utils.noImage,
                            imageBuilder: (context, imageProvider) {
                              return Image(
                                image: imageProvider,
                                width: 45,
                                fit: BoxFit.fitWidth,
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    libro.titulo,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(libro.autor, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_right_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Aceptar')),
          )
        ],
      ),
    ),
  );
  simpleDialog(context, content);
}
