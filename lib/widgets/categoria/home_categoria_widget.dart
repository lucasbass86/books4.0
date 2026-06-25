import 'package:animate_do/animate_do.dart';
import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class HomeCategoriaWidget extends StatelessWidget {
  final Categoria categoria;
  final ETypeFilter typeFilter;
  final String toSearch;
  const HomeCategoriaWidget(
      {super.key, required this.categoria, required this.typeFilter, required this.toSearch});

  @override
  Widget build(BuildContext context) {
    List<Libro> libros = [];
    switch (typeFilter) {
      case ETypeFilter.todos:
        libros = categoria.libros;
        break;
      case ETypeFilter.leido:
        libros = categoria.libros.where((l) => l.leido == 'SI').toList();
        break;
      case ETypeFilter.pendiente:
        libros = categoria.libros.where((l) => l.leido == 'NO' && l.fechInicio == '').toList();
        break;
      case ETypeFilter.leyendo:
        libros = categoria.libros.where((l) => l.leido == 'NO' && l.fechInicio != '').toList();
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
                Expanded(child: Text(categoria.name, style: Utils.mainTextStyle)),
                Bounceable(
                  onTap: () =>
                      Navigator.pushNamed(context, CategoriaPage.routeName, arguments: categoria),
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Utils.getCategoryColor(categoria.name).withAlpha(170),
                      borderRadius: BorderRadius.circular(Utils.radiusCircular),
                    ),
                    child: Center(
                      child: Text(
                        'TODOS',
                        style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
                      ),
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
                itemBuilder: (context, index) => LibroHomeWidget(libro: libros[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
