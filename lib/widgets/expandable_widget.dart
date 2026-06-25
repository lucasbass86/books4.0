import 'package:animate_do/animate_do.dart';
import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ExpandableWidget extends StatelessWidget {
  final Libro libro;
  final EExpandableType type;
  final IconData? icon;
  const ExpandableWidget({super.key, required this.libro, required this.type, this.icon});

  @override
  Widget build(BuildContext context) {
    Servicio servicio = Provider.of<Servicio>(context, listen: false);
    List<Libro> libros = [];
    late Categoria? categoria;
    late Editorial? editorial;
    late Autor? autor;
    late Collection? collection;
    List<CollectionBook> booksOfCollection = [];
    String title = '';
    String subTitle = '';

    switch (type) {
      case EExpandableType.autor:
        autor = servicio.autores.firstWhere((a) => a.name == libro.autor);
        libros = autor.libros;
        title = 'Autor';
        subTitle = autor.name;
        break;
      case EExpandableType.categoria:
        libros = servicio.categorias.firstWhere((c) => c.id == libro.categoriaId).libros;
        categoria = servicio.categorias.firstWhere((c) => c.id == libro.categoriaId);
        title = 'Categoría';
        subTitle = categoria.name;
        break;
      case EExpandableType.editorial:
        List<EditorialBook> editorialesBook =
            servicio.editorialesBooks.where((e) => e.idLibro == libro.codigo.toString()).toList();
        if (editorialesBook.isEmpty) {
          return SizedBox.shrink();
        }
        EditorialBook editorialBook = editorialesBook[0];
        editorial = servicio.editoriales.firstWhere((e) => e.id == editorialBook.idEditorial);
        final relaciones =
            servicio.editorialesBooks.where((rel) => rel.idEditorial == editorial!.id).toList();
        libros = servicio.libros
            .where((lib) => relaciones.any((r) => r.idLibro == lib.codigo.toString()))
            .toList();
        title = 'Editorial';
        subTitle = editorial.descripcion;
        break;
      case EExpandableType.coleccion:
        List<CollectionBook> collectionBook =
            servicio.collectionsBooks.where((c) => c.idLibro == libro.codigo.toString()).toList();
        if (collectionBook.isEmpty) {
          return const SizedBox.shrink();
        }
        collection = servicio.collections.where((c) => c.id == collectionBook[0].idColeccion).first;
        booksOfCollection = servicio.collectionsBooks
            .where((c) => c.idColeccion == collection!.id)
            .toList()
          ..sort((a, b) => int.parse(a.orden).compareTo(int.parse(b.orden)));
        // Mapa por código para acceso rápido
        final libroMap = {
          for (var l in servicio.libros) l.codigo.toString(): l,
        };
        // Libros en el MISMO orden que booksOfCollection
        libros = booksOfCollection.map((c) => libroMap[c.idLibro]).whereType<Libro>().toList();
        title = 'Colección';
        subTitle = collection.descripcion;
        break;
    }

    if (libros.isEmpty) {
      return SizedBox.shrink();
    }
    return ZoomIn(
      child: Column(
        children: [
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              childrenPadding: const EdgeInsets.only(left: 10, right: 10),
              iconColor: Utils.colorCard,
              backgroundColor: Utils.colorEtiqueta,
              collapsedBackgroundColor: Utils.colorEtiqueta,
              collapsedIconColor: Utils.colorCard,
              clipBehavior: Clip.antiAlias,
              leading: icon != null ? Icon(icon) : null,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Utils.secondTextStyle.copyWith(color: Utils.colorCard)),
                  Text(subTitle, style: Utils.mainTextStyle.copyWith(color: Utils.colorCard)),
                ],
              ),
              children: [
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: libros.length,
                    itemBuilder: (context, index) {
                      return LibroHomeWidget(
                        libro: libros[index],
                        isFromTag: true,
                        collectionBook: type == EExpandableType.coleccion
                            ? booksOfCollection
                                .firstWhere((c) => c.idLibro == libros[index].codigo.toString())
                            : null,
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${libros.length} libros', style: Utils.thirdTextStyle),
                      CustomInkWell(
                        onTap: () {
                          switch (type) {
                            case EExpandableType.autor:
                              Navigator.pushNamed(context, AutorPage.routeName,
                                  arguments: libro.autor);
                              break;
                            case EExpandableType.categoria:
                              Navigator.pushNamed(context, CategoriaPage.routeName,
                                  arguments: categoria);
                              break;
                            case EExpandableType.editorial:
                              Navigator.pushNamed(context, EditorialPage.routeName,
                                  arguments: editorial);
                              break;
                            case EExpandableType.coleccion:
                              Navigator.pushNamed(context, CollectionPage.routeName,
                                  arguments: collection);
                              break;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Text('Mostrar', style: Utils.thirdTextStyle),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
