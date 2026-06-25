import 'package:animate_do/animate_do.dart';
import 'package:books4/models/models.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CategoriasPage extends StatefulWidget {
  static const String routeName = 'CategoriasPage';
  const CategoriasPage({super.key});

  @override
  State<CategoriasPage> createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  late Servicio servicio;
  EOrderBooks selectedOrden = EOrderBooks.alfabetical;
  List<Categoria> categorias = [];
  @override
  Widget build(BuildContext context) {
    servicio = Provider.of<Servicio>(context, listen: false);
    categorias = servicio.categorias;
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
              expandedHeight: 145,
              backgroundColor: Utils.colorScaffold,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    TopWigdet(showBack: true, title: 'Categorias'),
                    Container(
                      padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 20,
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              Icon(Icons.bookmark_rounded),
                              Text('Mi biblioteca', style: TextStyle(color: Utils.circulo3)),
                            ],
                          ),
                          DropdownButton<EOrderBooks>(
                            value: selectedOrden,
                            items: EOrderBooks.values
                                .map((o) => DropdownMenuItem(value: o, child: Text(o.displayName)))
                                .toList(),
                            borderRadius: BorderRadius.circular(20),
                            underline: Container(),
                            style: TextStyle(color: Utils.circulo3),
                            icon: const SizedBox.shrink(),
                            isDense: true,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            onChanged: (value) => setState(() => selectedOrden = value!),
                          ),
                          Icon(Utils.iconOrder),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _categories(),
          ],
        ),
      ),
    );
  }

  Widget _categories() {
    switch (selectedOrden) {
      case EOrderBooks.alfabetical:
        categorias.sort((a, b) => a.name.compareTo(b.name));
        break;
      case EOrderBooks.totalBooks:
        categorias.sort((a, b) => b.libros.length.compareTo(a.libros.length));
        break;
      case EOrderBooks.readedBooks:
        categorias.sort((a, b) => b.libros
            .where((l) => l.leido == 'SI')
            .length
            .compareTo(a.libros.where((l) => l.leido == 'SI').length));
        break;
      case EOrderBooks.pendingBooks:
        categorias.sort((a, b) => b.libros
            .where((l) => l.leido == 'NO')
            .length
            .compareTo(a.libros.where((l) => l.leido == 'NO').length));
        break;
    }
    return SliverList.builder(
      itemCount: servicio.categorias.length,
      itemBuilder: (context, index) {
        return FadeInLeft(
          delay: Duration(milliseconds: 15 * index),
          child: CategoriaWidget(categoria: categorias[index]),
        );
      },
    );
  }
}
