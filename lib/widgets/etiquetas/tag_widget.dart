import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class TagWidget extends StatelessWidget {
  final Etiqueta etiqueta;
  const TagWidget({super.key, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    Servicio servicio = Provider.of<Servicio>(context, listen: false);
    int totalBook = servicio.etiquetasBooks.where((c) => c.idEtiqueta == etiqueta.id).length;
    final codigos = servicio.etiquetasBooks
        .where((c) => c.idEtiqueta == etiqueta.id)
        .map((e) => e.idLibro)
        .toSet();
    List<Libro> libros =
        servicio.libros.where((l) => codigos.contains(l.codigo.toString())).toList();
    int leidos = libros.where((l) => l.leido == 'SI').toList().length;
    int noLeidos = libros.length - leidos;
    return Bounceable(
      onTap: () => Navigator.pushNamed(context, EtiquetaPage.routeName, arguments: etiqueta),
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        height: 85,
        decoration: BoxDecoration(
          color: Utils.circulo2,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: Utils.circulo1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(etiqueta.descripcion,
                      style: TextStyle(fontSize: 17, color: Utils.circulo3),
                      overflow: TextOverflow.ellipsis),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
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
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  color: Utils.circulo1,
                  value: 1,
                  strokeWidth: 2,
                ),
                CircularProgressIndicator(
                  color: Utils.circulo3,
                  value: leidos / libros.length,
                  strokeWidth: 3,
                ),
                Text(
                  '${((leidos / libros.length) * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
