import 'package:books4/models/models.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PrestadosPage extends StatelessWidget {
  static const String routeName = 'PrestadosPage';
  const PrestadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    Servicio servicio = Provider.of(context, listen: false);
    List<Libro> filter = servicio.libros.where((l) => l.prestado == 'SI').toList();
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
              expandedHeight: 100,
              backgroundColor: Utils.colorScaffold,
              flexibleSpace: TopWigdet(title: 'Prestados', showBack: true),
            ),
            if (filter.isNotEmpty) ListaLibrosSliverWidget(libros: filter),
            if (filter.isEmpty)
              const SliverFillRemaining(
                child: NotFoundWidget(title: 'Ningún libro prestado'),
              )
          ],
        ),
      ),
    );
  }
}
