import 'package:books4/models/models.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChartDetailPage extends StatelessWidget {
  static const String routeName = 'ChartDetailPage';
  const ChartDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<dynamic> argumentos = ModalRoute.of(context)!.settings.arguments as List;
    List<Libro> libros = argumentos[0] as List<Libro>;
    String titulo = argumentos[1] as String;
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
              expandedHeight: 120,
              pinned: false,
              backgroundColor: Utils.colorScaffold,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: TopWigdet(title: titulo, showBack: true)),
              ),
            ),
            ListaLibrosSliverWidget(libros: libros),
          ],
        ),
      ),
    );
  }
}
