import 'package:books4/models/models.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class NextBooksPage extends StatelessWidget {
  static const String routeName = 'NextBooksPage';
  const NextBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    Servicio servicio = Provider.of<Servicio>(context, listen: false);
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
              pinned: false,
              expandedHeight: 120,
              backgroundColor: Utils.colorScaffold,
              flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: TopWigdet(title: 'Siguientes lecturas', showBack: true))),
              automaticallyImplyLeading: false,
            ),
            sliverLibros(context, servicio),
          ],
        ),
      ),
    );
  }

  Widget sliverLibros(BuildContext context, Servicio servicio) {
    for (Libro n in servicio.siguientes) {
      if (n.leido == 'SI' || n.fechInicio.isNotEmpty) {
        servicio.deleteNextRead(n.codigo);
      }
    }
    if (servicio.siguientes.isEmpty) {
      return const SliverFillRemaining(
        child: NotFoundWidget(),
      );
    } else {
      return ListaLibrosSliverWidget(libros: servicio.siguientes);
    }
  }
}
