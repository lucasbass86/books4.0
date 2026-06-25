import 'package:animate_do/animate_do.dart';
import 'package:books4/models/models.dart';
import 'package:books4/providers/mainprovider.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaLibrosSliverWidget extends StatefulWidget {
  final List<Libro> libros;
  final bool isFromCollection;
  const ListaLibrosSliverWidget({super.key, required this.libros, this.isFromCollection = false});

  @override
  State<ListaLibrosSliverWidget> createState() => _ListaLibrosSliverWidgetState();
}

class _ListaLibrosSliverWidgetState extends State<ListaLibrosSliverWidget> {
  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    late Widget viewWidget;

    switch (mainProvider.selectedView) {
      case ETypeView.lista:
        viewWidget = SliverList.builder(
          itemCount: widget.libros.length,
          itemBuilder: (context, index) {
            return FadeInLeft(
              delay: Duration(milliseconds: 5 * index),
              child: BookWidget(
                  libro: widget.libros[index], isFromCollection: widget.isFromCollection),
            );
          },
        );
        break;
      case ETypeView.listaGlass:
        viewWidget = SliverList.builder(
          itemCount: widget.libros.length,
          itemBuilder: (context, index) {
            return FadeInLeft(
              delay: Duration(milliseconds: 5 * index),
              child: BookVertical(
                  libro: widget.libros[index], isFromCollection: widget.isFromCollection),
            );
          },
        );
        break;
      case ETypeView.cuadricula:
        viewWidget = SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                height: 30,
                child: Row(
                  children: [
                    Text('Zoom', style: Utils.mainTextStyle),
                    Expanded(
                      child: Slider(
                        max: 4,
                        min: 1,
                        divisions: 3,
                        onChanged: (value) => setState(() => Preferences.zoom = value.toInt()),
                        value: Preferences.zoom.toDouble(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverGrid.builder(
              itemCount: widget.libros.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Preferences.zoom,
              ),
              itemBuilder: (context, index) {
                return LibroSmallWidget(
                    libro: widget.libros[index], isFromCollection: widget.isFromCollection);
              },
            ),
          ],
        );
        break;
      case ETypeView.portada:
        viewWidget = SliverFillRemaining(
          child: BookCarouselWidget(libros: widget.libros),
        );
        break;
    }
    return viewWidget;
  }
}
