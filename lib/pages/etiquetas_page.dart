import 'package:animate_do/animate_do.dart';
import 'package:books4/models/models.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EtiquetasPage extends StatefulWidget {
  static const String routeName = 'EtiquetasPage';
  const EtiquetasPage({super.key});

  @override
  State<EtiquetasPage> createState() => _EtiquetasPageState();
}

class _EtiquetasPageState extends State<EtiquetasPage> {
  String toSearch = '';
  List<Etiqueta> etiquetas = [];
  late Servicio servicio;
  EOrderBooks selectedOrden = EOrderBooks.alfabetical;

  @override
  Widget build(BuildContext context) {
    servicio = Provider.of<Servicio>(context, listen: false);
    if (toSearch.isEmpty) {
      etiquetas = servicio.etiquetas;
    } else {
      etiquetas = servicio.etiquetas
          .where((c) => c.descripcion.toUpperCase().contains(toSearch.toUpperCase()))
          .toList();
    }
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.globalPosition.dx < 30) {
            Navigator.pop(context);
          }
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: false,
              expandedHeight: 145,
              backgroundColor: Utils.colorScaffold,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    TopWigdet(
                      title: 'Etiquetas',
                      showBack: true,
                      showSearch: true,
                      onSearch: (value) => setState(() => toSearch = value),
                      onCloseSearch: () => setState(() => toSearch = ''),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 10, right: 20),
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
                          DropdownButton<EOrderBooks>(
                            value: selectedOrden,
                            items: EOrderBooks.values
                                .map((o) => DropdownMenuItem(value: o, child: Text(o.displayName)))
                                .toList(),
                            borderRadius: BorderRadius.circular(20),
                            underline: Container(),
                            style: TextStyle(color: Utils.circulo3),
                            icon: const SizedBox.shrink(),
                            isDense: true,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            onChanged: (value) => setState(() => selectedOrden = value!),
                          ),
                          Icon(Utils.iconOrder),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _etiquetas(),
          ],
        ),
      ),
    );
  }

  Widget _etiquetas() {
    if (etiquetas.isNotEmpty) {
      switch (selectedOrden) {
        case EOrderBooks.alfabetical:
          etiquetas.sort((a, b) => a.descripcion.compareTo(b.descripcion));
          break;
        case EOrderBooks.totalBooks:
          etiquetas.sort(
            (a, b) {
              List<Libro> librosA = servicio.libros
                  .where((l) => servicio.etiquetasBooks
                      .where((c) => c.idEtiqueta == a.id)
                      .toList()
                      .map((e) => e.idLibro)
                      .toSet()
                      .contains(l.codigo.toString()))
                  .toList();
              List<Libro> librosB = servicio.libros
                  .where((l) => servicio.etiquetasBooks
                      .where((c) => c.idEtiqueta == b.id)
                      .toList()
                      .map((e) => e.idLibro)
                      .toSet()
                      .contains(l.codigo.toString()))
                  .toList();
              return librosB.length.compareTo(librosA.length);
            },
          );
          break;
        case EOrderBooks.readedBooks:
          etiquetas.sort(
            (a, b) {
              List<Libro> librosA = servicio.libros
                  .where((l) =>
                      l.leido == 'SI' &&
                      servicio.etiquetasBooks
                          .where((c) => c.idEtiqueta == a.id)
                          .toList()
                          .map((e) => e.idLibro)
                          .toSet()
                          .contains(l.codigo.toString()))
                  .toList();
              List<Libro> librosB = servicio.libros
                  .where((l) =>
                      l.leido == 'SI' &&
                      servicio.etiquetasBooks
                          .where((c) => c.idEtiqueta == b.id)
                          .toList()
                          .map((e) => e.idLibro)
                          .toSet()
                          .contains(l.codigo.toString()))
                  .toList();
              return librosB.length.compareTo(librosA.length);
            },
          );
          break;
        case EOrderBooks.pendingBooks:
          etiquetas.sort(
            (a, b) {
              List<Libro> librosA = servicio.libros
                  .where((l) =>
                      l.leido == 'NO' &&
                      servicio.etiquetasBooks
                          .where((c) => c.idEtiqueta == a.id)
                          .toList()
                          .map((e) => e.idLibro)
                          .toSet()
                          .contains(l.codigo.toString()))
                  .toList();
              List<Libro> librosB = servicio.libros
                  .where((l) =>
                      l.leido == 'NO' &&
                      servicio.etiquetasBooks
                          .where((c) => c.idEtiqueta == b.id)
                          .toList()
                          .map((e) => e.idLibro)
                          .toSet()
                          .contains(l.codigo.toString()))
                  .toList();
              return librosB.length.compareTo(librosA.length);
            },
          );
          break;
      }
      return SliverList.builder(
        itemCount: etiquetas.length,
        itemBuilder: (context, index) {
          return FadeInLeft(
            delay: Duration(milliseconds: 50 * index),
            child: TagWidget(etiqueta: etiquetas[index]),
          );
        },
      );
    } else {
      return const SliverFillRemaining(
        child: NotFoundWidget(title: 'Ninguna etiqueta'),
      );
    }
  }
}
