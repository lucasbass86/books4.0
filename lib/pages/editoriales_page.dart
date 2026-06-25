import 'package:animate_do/animate_do.dart';
import 'package:books4/models/models.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EditorialesPage extends StatefulWidget {
  static const String routeName = 'EditorialesPage';
  const EditorialesPage({super.key});

  @override
  State<EditorialesPage> createState() => _EditorialesPageState();
}

class _EditorialesPageState extends State<EditorialesPage> {
  String toSearch = '';
  List<Editorial> editoriales = [];
  late Servicio servicio;
  EOrderBooks selectedOrden = EOrderBooks.alfabetical;

  @override
  Widget build(BuildContext context) {
    servicio = Provider.of<Servicio>(context, listen: false);
    if (toSearch.isEmpty) {
      editoriales = servicio.editoriales;
    } else {
      editoriales = servicio.editoriales
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
                      title: 'Editoriales',
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
            _editoriales(),
          ],
        ),
      ),
    );
  }

  Widget _editoriales() {
    if (editoriales.isNotEmpty) {
      switch (selectedOrden) {
        case EOrderBooks.alfabetical:
          editoriales.sort((a, b) => a.descripcion.compareTo(b.descripcion));
          break;
        case EOrderBooks.totalBooks:
          editoriales.sort(
            (a, b) {
              List<Libro> librosA = servicio.libros
                  .where((l) => servicio.editorialesBooks
                      .where((c) => c.idEditorial == a.id)
                      .toList()
                      .map((e) => e.idLibro)
                      .toSet()
                      .contains(l.codigo.toString()))
                  .toList();
              List<Libro> librosB = servicio.libros
                  .where((l) => servicio.editorialesBooks
                      .where((c) => c.idEditorial == b.id)
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
          editoriales.sort(
            (a, b) {
              List<Libro> librosA = servicio.libros
                  .where((l) =>
                      l.leido == 'SI' &&
                      servicio.editorialesBooks
                          .where((c) => c.idEditorial == a.id)
                          .toList()
                          .map((e) => e.idLibro)
                          .toSet()
                          .contains(l.codigo.toString()))
                  .toList();
              List<Libro> librosB = servicio.libros
                  .where((l) =>
                      l.leido == 'SI' &&
                      servicio.editorialesBooks
                          .where((c) => c.idEditorial == b.id)
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
          editoriales.sort(
            (a, b) {
              List<Libro> librosA = servicio.libros
                  .where((l) =>
                      l.leido == 'NO' &&
                      servicio.editorialesBooks
                          .where((c) => c.idEditorial == a.id)
                          .toList()
                          .map((e) => e.idLibro)
                          .toSet()
                          .contains(l.codigo.toString()))
                  .toList();
              List<Libro> librosB = servicio.libros
                  .where((l) =>
                      l.leido == 'NO' &&
                      servicio.editorialesBooks
                          .where((c) => c.idEditorial == b.id)
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
        itemCount: editoriales.length,
        itemBuilder: (context, index) {
          return FadeInLeft(
            delay: Duration(milliseconds: 5 * index),
            child: EditorialWidget(editorial: editoriales[index]),
          );
        },
      );
    } else {
      return const SliverFillRemaining(
        child: NotFoundWidget(title: 'Ninguna editorial'),
      );
    }
  }
}
