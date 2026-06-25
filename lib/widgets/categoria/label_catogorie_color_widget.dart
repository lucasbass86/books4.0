import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';

class LabelCatogorieColorWidget extends StatelessWidget {
  final Categoria categoria;
  final String currentRoute;
  const LabelCatogorieColorWidget({super.key, required this.categoria, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyle(Utils.getCategoryColor(categoria.name));

    return GestureDetector(
      onTap: () {
        if (currentRoute != CategoriaPage.routeName) {
          Navigator.pushNamed(context, CategoriaPage.routeName, arguments: categoria);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: style.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 7,
          children: [
            Icon(Utils.getCategoryIcon(categoria.name), color: style.foreground, size: 17),
            Text(
              categoria.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: style.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
