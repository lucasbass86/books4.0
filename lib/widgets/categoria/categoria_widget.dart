import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class CategoriaWidget extends StatelessWidget {
  final Categoria categoria;
  const CategoriaWidget({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    int leidos = categoria.libros
        .where((l) => l.categoriaId == categoria.id && l.leido == 'SI')
        .toList()
        .length;
    int noLeidos = categoria.libros.length - leidos;
    return Bounceable(
      onTap: () => Navigator.pushNamed(context, CategoriaPage.routeName, arguments: categoria),
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        height: 110,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Utils.circulo2,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: Utils.getCategoryColor(categoria.name)),
        ),
        child: Row(
          spacing: 10,
          children: [
            Hero(
              tag: 'categoria${categoria.id}',
              child: Image.network(
                height: 90,
                width: 90,
                fit: BoxFit.fill,
                Utils.getImgUrlCategoria(categoria.id),
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => child,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(child: CircularProgressIndicator(color: Utils.circulo4));
                  }
                },
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(categoria.name,
                      style: TextStyle(fontSize: 17, color: Utils.circulo3),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
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
                          Text('${categoria.libros.length} libros',
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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double w = constraints.maxWidth;
                      return ProgressBarWidget(
                        width: w,
                        currentValue: leidos,
                        maxValue: categoria.libros.length,
                        backgroundColor: Utils.getCategoryColor(categoria.name).withAlpha(130),
                        progressColor: Utils.getCategoryColor(categoria.name),
                        textStyle: Utils.mainTextStyle,
                        valueTextStyle: Utils.mainTextStyle.copyWith(fontSize: 13),
                      );
                    },
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
