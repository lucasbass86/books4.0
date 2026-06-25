import 'package:animate_do/animate_do.dart';
import 'package:books4/dialogs/dialogs.dart';
import 'package:books4/dialogs/modals.dart';
import 'package:books4/models/models.dart';
import 'package:books4/providers/mainprovider.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EtiquetaPage extends StatefulWidget {
  static const String routeName = 'EtiquetaPage';
  const EtiquetaPage({super.key});

  @override
  State<EtiquetaPage> createState() => _EtiquetaPageState();
}

class _EtiquetaPageState extends State<EtiquetaPage> {
  List<Libro> libros = [];
  List<Libro> filter = [];
  late MainProvider mainProvider;
  ETypeFilter typeFilter = ETypeFilter.todos;
  EType eType = Preferences.type;
  ETypeOrder eTypeOrder = Preferences.typeOrder;
  int leidos = 0;
  late Etiqueta etiqueta;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of<MainProvider>(context);
    Servicio servicio = Provider.of<Servicio>(context, listen: false);
    etiqueta = ModalRoute.of(context)!.settings.arguments as Etiqueta;
    List<EtiquetaBook> etiquetaBooks =
        servicio.etiquetasBooks.where((e) => e.idEtiqueta == etiqueta.id).toList();
    final libroMap = {
      for (var l in servicio.libros) l.codigo.toString(): l,
    };
    libros = etiquetaBooks.map((c) => libroMap[c.idLibro]).whereType<Libro>().toList();

    if (!_isSearching) {
      switch (typeFilter) {
        case ETypeFilter.todos:
          filter = libros;
          break;
        case ETypeFilter.leido:
          filter = libros.where((l) => l.leido == 'SI').toList();
          break;
        case ETypeFilter.pendiente:
          filter = libros.where((l) => l.leido == 'NO').toList();
          break;
        case ETypeFilter.leyendo:
          filter = libros.where((l) => l.leido == 'NO' && l.fechInicio.isNotEmpty).toList();
          break;
      }
    }

    switch (eType) {
      case EType.id:
        if (eTypeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.codigo.compareTo(b.codigo));
        } else {
          filter.sort((a, b) => b.codigo.compareTo(a.codigo));
        }
        break;
      case EType.paginas:
        if (eTypeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.paginas.compareTo(b.paginas));
        } else {
          filter.sort((a, b) => b.paginas.compareTo(a.paginas));
        }
        break;
      case EType.titulo:
        if (eTypeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.titulo.compareTo(b.titulo));
        } else {
          filter.sort((a, b) => b.titulo.compareTo(a.titulo));
        }
        break;
      case EType.autor:
        if (eTypeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.autor.compareTo(b.autor));
        } else {
          filter.sort((a, b) => b.autor.compareTo(a.autor));
        }
        break;
      case EType.fechaCompra:
        if (eTypeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => Utils.dateStringSpanishToEnglish(a.fechCompra)
              .compareTo(Utils.dateStringSpanishToEnglish(b.fechCompra)));
        } else {
          filter.sort((a, b) => Utils.dateStringSpanishToEnglish(b.fechCompra)
              .compareTo(Utils.dateStringSpanishToEnglish(a.fechCompra)));
        }
        break;
      case EType.fechaLeido:
        if (eTypeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => Utils.dateStringSpanishToEnglish(a.fechFin)
              .compareTo(Utils.dateStringSpanishToEnglish(b.fechFin)));
        } else {
          filter.sort((a, b) => Utils.dateStringSpanishToEnglish(b.fechFin)
              .compareTo(Utils.dateStringSpanishToEnglish(a.fechFin)));
        }
        break;
      case EType.fechaIniciado:
        if (eTypeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => Utils.dateStringSpanishToEnglish(a.fechInicio)
              .compareTo(Utils.dateStringSpanishToEnglish(b.fechInicio)));
        } else {
          filter.sort((a, b) => Utils.dateStringSpanishToEnglish(b.fechInicio)
              .compareTo(Utils.dateStringSpanishToEnglish(a.fechInicio)));
        }
        break;
      case EType.categoria:
        if (eTypeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.categoria.compareTo(b.categoria));
        } else {
          filter.sort((a, b) => b.categoria.compareTo(a.categoria));
        }
        break;
      case EType.nota:
        if (eTypeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.nota.compareTo(b.nota));
        } else {
          filter.sort((a, b) => b.nota.compareTo(a.nota));
        }
        break;
      case EType.precio:
        if (eTypeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.precio.compareTo(b.precio));
        } else {
          filter.sort((a, b) => b.precio.compareTo(a.precio));
        }
        break;
    }
    leidos = filter.where((l) => l.leido == 'SI').toList().length;

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.globalPosition.dx < 30) {
            Navigator.pop(context);
          }
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: false,
              expandedHeight: 380,
              backgroundColor: Utils.colorScaffold,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    TopWigdet(
                      title: etiqueta.descripcion,
                      showBack: true,
                      showSearch: true,
                      onSearch: (value) {
                        setState(() {
                          _isSearching = true;
                          filter = libros
                              .where((l) =>
                                  l.autor.toUpperCase().contains(value.toUpperCase()) ||
                                  l.titulo.toUpperCase().contains(value.toUpperCase()))
                              .toList();
                        });
                      },
                      onCloseSearch: () {
                        setState(() {
                          _isSearching = false;
                        });
                      },
                    ),
                    _header(),
                  ],
                ),
              ),
            ),
            ListaLibrosSliverWidget(libros: filter),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return ZoomIn(
      child: Column(
        children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
            decoration: BoxDecoration(
              color: Utils.circulo2,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: Utils.circulo1),
            ),
            child: Column(
              children: [
                Row(
                  spacing: 10,
                  children: [
                    CircleAvatar(
                        backgroundColor: Utils.circulo1,
                        child: Text(etiqueta.descripcion.substring(0, 1))),
                    Expanded(
                      child: Text(
                        etiqueta.descripcion,
                        style: TextStyle(color: Utils.circulo4),
                      ),
                    ),
                    PopupMenuButton(
                      color: Utils.colorCard,
                      constraints: BoxConstraints(maxWidth: 60),
                      iconSize: 30,
                      tooltip: 'Más información',
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      icon: Icon(Icons.more_vert_rounded, color: Utils.colorIcon),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            onTap: () {
                              double price =
                                  libros.fold(0, (previousValue, l) => previousValue + l.precio);
                              showMessage(
                                  context: context,
                                  message:
                                      'El importe de los libros es de ${price.toStringAsFixed(2)}€');
                            },
                            child: Icon(Icons.euro_rounded, size: 25),
                          ),
                        ];
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Utils.circulo3.withAlpha(100),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.menu_book_rounded, color: Utils.circulo3),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filter.length.toString(),
                              style: TextStyle(color: Utils.circulo4, fontSize: 15),
                            ),
                            Text(
                              'Libros',
                              style: TextStyle(color: Utils.circulo4, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Utils.circulo3.withAlpha(100),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.sticky_note_2, color: Utils.circulo3),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filter
                                  .fold<int>(0,
                                      (previousValue, element) => previousValue + element.paginas)
                                  .toString(),
                              style: TextStyle(color: Utils.circulo4, fontSize: 15),
                            ),
                            Text(
                              'Páginas',
                              style: TextStyle(color: Utils.circulo4, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Utils.circulo3.withAlpha(100),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.timer, color: Utils.circulo3),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${(leidos * 100 / filter.length).toStringAsFixed(0)}%',
                              style: TextStyle(color: Utils.circulo4, fontSize: 15),
                            ),
                            Text(
                              'Progreso',
                              style: TextStyle(color: Utils.circulo4, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Expanded(child: SizedBox(height: 1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso de lectura',
                      style: TextStyle(color: Utils.circulo4, fontSize: 10),
                    ),
                    Text(
                      '$leidos de ${filter.length} libros',
                      style: TextStyle(color: Utils.circulo4, fontSize: 10),
                    ),
                  ],
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    double w = constraints.maxWidth;
                    return ProgressBarWidget(
                      width: w,
                      currentValue: leidos,
                      maxValue: filter.length,
                      backgroundColor: Utils.colorCard,
                      progressColor: Utils.colorEtiqueta,
                      textStyle: Utils.mainTextStyle,
                      valueTextStyle: Utils.mainTextStyle.copyWith(fontSize: 13),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Icon(Icons.bookmark_rounded),
                    Text('Mi biblioteca', style: TextStyle(color: Utils.circulo3)),
                  ],
                ),
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Utils.circulo1.withAlpha(50),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Utils.circulo1),
                  ),
                  child: Row(
                    children: [
                      CustomInkWell(
                        onTap: () => showModalTypeView(context),
                        child: Icon(Utils.iconView, size: 25),
                      ),
                      CustomInkWell(
                        onTap: () async {
                          final filter = await filterDialogLibros(context, filter: typeFilter);
                          if (filter != null) {
                            typeFilter = filter;
                          }
                        },
                        child: const Icon(Utils.iconFilter, size: 25),
                      ),
                      CustomInkWell(
                        onTap: () async {
                          final resp =
                              await orderDialogLibros(context, type: eType, typeOrder: eTypeOrder);
                          if (resp[0]) {
                            eType = resp[1];
                            eTypeOrder = resp[2];
                            setState(() {});
                          }
                        },
                        child: const Icon(Utils.iconOrder, size: 25),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
