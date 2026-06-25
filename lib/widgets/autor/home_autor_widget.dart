import 'package:animate_do/animate_do.dart';
import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeAutorWidget extends StatelessWidget {
  final Autor autor;
  final ETypeFilter typeFilter;
  final String toSearch;
  const HomeAutorWidget(
      {super.key, required this.autor, required this.typeFilter, required this.toSearch});

  @override
  Widget build(BuildContext context) {
    List<Libro> libros = [];
    switch (typeFilter) {
      case ETypeFilter.todos:
        libros = autor.libros;
        break;
      case ETypeFilter.leido:
        libros = autor.libros.where((l) => l.leido == 'SI').toList();
        break;
      case ETypeFilter.pendiente:
        libros = autor.libros.where((l) => l.leido == 'NO' && l.fechInicio == '').toList();
        break;
      case ETypeFilter.leyendo:
        libros = autor.libros.where((l) => l.leido == 'NO' && l.fechInicio != '').toList();
        break;
    }
    libros = libros
        .where((element) => element.titulo.toUpperCase().contains(toSearch.toUpperCase()))
        .toList();
    return ElasticInRight(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        width: double.infinity,
        height: 200,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(autor.name,
                        style: Utils.mainTextStyle, overflow: TextOverflow.ellipsis)),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AutorPage.routeName, arguments: autor.name),
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Utils.colorContainer,
                      borderRadius: BorderRadius.circular(Utils.radiusCircular),
                    ),
                    child: Center(
                      child: Text('TODOS',
                          style: TextStyle(
                              color: Utils.colorEtiquetaTexto, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: libros.length,
                itemBuilder: (context, index) {
                  return LibroHomeWidget(libro: libros[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
