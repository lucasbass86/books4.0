import 'package:animate_do/animate_do.dart';
import 'package:books4/models/models.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AutoresPage extends StatefulWidget {
  static const String routeName = 'AutoresPage';
  const AutoresPage({super.key});

  @override
  State<AutoresPage> createState() => _AutoresPageState();
}

class _AutoresPageState extends State<AutoresPage> {
  late Servicio servicio;
  bool showIndex = false;
  double _letrasTop = 110;
  List<Autor> autores = [];
  String toSearch = '';
  late ScrollController scrollController;
  EOrderBooks selectedOrden = EOrderBooks.alfabetical;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final offset = scrollController.offset;

    // Cambia el top solo si es diferente al actual para evitar rebuilds innecesarios
    if (offset > 5 && _letrasTop != 10) {
      setState(() {
        _letrasTop = 10;
      });
    } else if (offset <= 5 && _letrasTop != 110) {
      setState(() {
        _letrasTop = 110;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    servicio = Provider.of<Servicio>(context, listen: false);
    if (toSearch.isEmpty) {
      autores = servicio.autores;
    } else {
      autores = servicio.autores
          .where((a) => a.name.toUpperCase().contains(toSearch.toUpperCase()))
          .toList();
    }
    return Scaffold(
      floatingActionButton: _fab(),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.globalPosition.dx < 30) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                _top(),
                _autores(),
              ],
            ),
            if (selectedOrden == EOrderBooks.alfabetical) _letras(),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: false,
      expandedHeight: 145,
      backgroundColor: Utils.colorScaffold,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            TopWigdet(
              showBack: true,
              title: 'Autores',
              showSearch: true,
              onSearch: (value) => setState(() => toSearch = value),
              onCloseSearch: () => setState(() => toSearch = ''),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: selectedOrden == EOrderBooks.alfabetical ? 50 : 20, top: 10, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }

  Widget _fab() {
    return ScrollVisibilityWidget(
      controller: scrollController,
      child: ScrollToHideWidget(
        controller: scrollController,
        height: 50,
        withAnimatedOpacity: true,
        child: FloatingActionButton(
          backgroundColor: Utils.bottom,
          mini: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
          onPressed: () {
            scrollController.position.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear,
            );
          },
          child: Icon(Icons.keyboard_arrow_up_rounded),
        ),
      ),
    );
  }

  Widget _letras() {
    int autoresLength = autores.length;
    List<String> iniciales = [];
    for (Autor a in autores) {
      String ini = a.name.substring(0, 1);
      if (!iniciales.contains(ini)) {
        iniciales.add(ini);
      }
    }
    iniciales.sort((a, b) => a.compareTo(b));
    ScrollController lettersScrollController = scrollController;
    return Positioned(
      left: 15,
      top: _letrasTop,
      bottom: 10,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        width: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...iniciales.map(
              (i) => InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  final contentSize = lettersScrollController.position.viewportDimension +
                      lettersScrollController.position.maxScrollExtent;
                  final target = contentSize *
                      autores.indexWhere((a) => a.name.substring(0, 1) == i) /
                      autoresLength;
                  lettersScrollController.position.animateTo(
                    target,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear,
                  );
                },
                child: ZoomIn(
                  delay: Duration(milliseconds: 15 * iniciales.indexOf(i)),
                  child: Center(child: Text(i, style: Utils.mainTextStyle.copyWith(fontSize: 15))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _autores() {
    switch (selectedOrden) {
      case EOrderBooks.alfabetical:
        autores.sort((a, b) => a.name.compareTo(b.name));
        break;
      case EOrderBooks.totalBooks:
        autores.sort((a, b) => b.libros.length.compareTo(a.libros.length));
        break;
      case EOrderBooks.readedBooks:
        autores.sort((a, b) => b.libros
            .where((l) => l.leido == 'SI')
            .length
            .compareTo(a.libros.where((l) => l.leido == 'SI').length));
        break;
      case EOrderBooks.pendingBooks:
        autores.sort((a, b) => b.libros
            .where((l) => l.leido == 'NO')
            .length
            .compareTo(a.libros.where((l) => l.leido == 'NO').length));
        break;
    }
    return SliverPadding(
      padding: EdgeInsets.only(left: selectedOrden == EOrderBooks.alfabetical ? 50 : 20, right: 20),
      sliver: SliverList.builder(
        itemCount: autores.length,
        itemBuilder: (context, index) => AutorWidget(autor: autores[index]),
      ),
    );
  }
}
