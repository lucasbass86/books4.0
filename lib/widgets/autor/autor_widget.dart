import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class AutorWidget extends StatelessWidget {
  final Autor autor;
  const AutorWidget({super.key, required this.autor});

  @override
  Widget build(BuildContext context) {
    Servicio servicio = Provider.of<Servicio>(context, listen: false);
    final currentRoute = ModalRoute.of(context)?.settings.name;
    int leidos =
        autor.libros.where((l) => l.autor == autor.name && l.leido == 'SI').toList().length;
    int noLeidos = autor.libros.length - leidos;
    return Bounceable(
      onTap: () => Navigator.pushNamed(context, AutorPage.routeName, arguments: autor.name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        height: 120,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Utils.circulo2,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: Utils.circulo1),
        ),
        child: Row(
          children: [
            Hero(
              tag: 'autor${autor.id}',
              child: const Icon(Icons.person, size: 80),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(autor.name,
                      style: TextStyle(fontSize: 17, color: Utils.circulo3),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
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
                          Text(
                              '${autor.libros.length} ${autor.libros.length == 1 ? 'libro' : 'libros'}',
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
                  const Expanded(child: SizedBox(height: 1)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 30,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: autor.categorias.length,
                        itemBuilder: (context, index) {
                          Categoria categoria = servicio.categorias
                              .firstWhere((c) => c.name == autor.categorias[index]);
                          return /*CategoriaNameWidget*/ Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: LabelCatogorieColorWidget(
                                categoria: categoria, currentRoute: currentRoute!),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
