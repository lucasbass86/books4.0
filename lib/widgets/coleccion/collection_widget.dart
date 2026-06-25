import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class CollectionWidget extends StatelessWidget {
  final Collection collection;
  const CollectionWidget({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    Servicio servicio = Provider.of<Servicio>(context, listen: false);
    List<CollectionBook> booksOfCollection =
        servicio.collectionsBooks.where((c) => c.idColeccion == collection.id).toList();
    int totalBook = servicio.collectionsBooks.where((c) => c.idColeccion == collection.id).length;
    final codigos = booksOfCollection.map((e) => e.idLibro).toSet();
    List<Libro> libros =
        servicio.libros.where((l) => codigos.contains(l.codigo.toString())).toList();
    int leidos = libros.where((l) => l.leido == 'SI').toList().length;
    int noLeidos = libros.length - leidos;
    return Bounceable(
      onTap: () => Navigator.pushNamed(context, CollectionPage.routeName, arguments: collection),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          color: Utils.circulo2,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: Utils.circulo1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(collection.descripcion,
                style: TextStyle(fontSize: 17, color: Utils.circulo3),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    if (collection.observaciones.isNotEmpty)
                      Row(
                        children: [
                          Text('*', style: TextStyle(fontSize: 13, color: Utils.circulo3)),
                          const SizedBox(width: 25),
                        ],
                      ),
                    if (collection.cerrada)
                      Row(
                        children: [
                          const Icon(Icons.lock, size: 17),
                          const SizedBox(width: 25),
                        ],
                      ),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: Utils.colorDot,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text('$totalBook libros',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 13, color: Utils.circulo3)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.menu_book_rounded, size: 17),
                    const SizedBox(width: 5),
                    Text('$leidos',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 13, color: Utils.circulo3)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.book, size: 17),
                    const SizedBox(width: 5),
                    Text('$noLeidos',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 13, color: Utils.circulo3)),
                  ],
                ),
                if (leidos == libros.length && collection.cerrada) Icon(Icons.check_rounded)
              ],
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                double w = constraints.maxWidth;
                return ProgressBarWidget(
                  width: w,
                  currentValue: leidos,
                  maxValue: libros.length,
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
    );
  }
}
