import 'package:animate_do/animate_do.dart';
import 'package:books4/dialogs/dialogs.dart';
import 'package:books4/models/models.dart';
import 'package:books4/providers/mainprovider.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class BibliotecaPage extends StatefulWidget {
  static const String routeName = 'BibliotecaPage';
  const BibliotecaPage({super.key});

  @override
  State<BibliotecaPage> createState() => _BibliotecaPageState();
}

class _BibliotecaPageState extends State<BibliotecaPage> {
  late Servicio servicio;
  late MainProvider mainProvider;
  double _letrasTop = 110;
  late ScrollController scrollController;
  ETypeFilter typeFilter = ETypeFilter.pendiente;
  String _toSearch = '';

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final offset = scrollController.offset;
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
    mainProvider = Provider.of<MainProvider>(context);
    servicio = Provider.of<Servicio>(context);
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _top(),
                mainProvider.selectedHome == 0 ? categorias() : autores(),
              ],
            ),
            if (mainProvider.selectedHome == 1) _letras(),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: false,
      expandedHeight: 155,
      backgroundColor: Utils.colorScaffold,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              TopWigdet(
                showBack: true,
                title: 'Biblioteca',
                showSearch: true,
                onSearch: (value) => setState(() => _toSearch = value),
                onCloseSearch: () => setState(() => _toSearch = ''),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 10, left: mainProvider.selectedHome == 0 ? 20 : 40, right: 20, bottom: 0),
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
                    Container(
                      height: 35,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Utils.circulo1.withAlpha(50),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Utils.circulo1),
                      ),
                      child: Row(
                        children: [
                          CustomInkWell(
                            onTap: () async {
                              final filter = await filterDialogLibros(context, filter: typeFilter);
                              if (filter != null) {
                                setState(() {
                                  typeFilter = filter;
                                });
                              }
                            },
                            child: const Icon(Utils.iconFilter, size: 25),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fab() {
    return ScrollVisibilityWidget(
      controller: scrollController,
      child: ScrollToHideWidget(
        controller: scrollController,
        height: 85,
        withAnimatedOpacity: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: Key('up'),
              backgroundColor: Utils.bottom,
              mini: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
              onPressed: () {
                setState(() {
                  scrollController.position.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear,
                  );
                });
              },
              child: Icon(Icons.keyboard_arrow_up_rounded),
            ),
            FloatingActionButton(
              heroTag: Key('change'),
              backgroundColor: Utils.bottom,
              mini: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
              onPressed: () {
                setState(() {
                  mainProvider.selectedHome = mainProvider.selectedHome == 0 ? 1 : 0;
                  scrollController.jumpTo(0);
                });
                ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar(
                    'Cambiado a ${mainProvider.selectedHome == 0 ? 'categorías' : 'autores'}'));
              },
              child: Icon(Icons.change_circle_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget categorias() {
    List<Categoria> cats = [];
    switch (typeFilter) {
      case ETypeFilter.todos:
        cats = servicio.categorias;
        break;
      case ETypeFilter.leido:
        cats = servicio.categorias
            .where((c) => c.libros
                .where((l) =>
                    l.leido == 'SI' && l.titulo.toUpperCase().contains(_toSearch.toUpperCase()))
                .toList()
                .isNotEmpty)
            .toList();
        break;
      case ETypeFilter.pendiente:
        cats = servicio.categorias
            .where((c) => c.libros
                .where((l) =>
                    l.leido == 'NO' &&
                    l.fechInicio == '' &&
                    l.titulo.toUpperCase().contains(_toSearch.toUpperCase()))
                .toList()
                .isNotEmpty)
            .toList();
        break;
      case ETypeFilter.leyendo:
        cats = servicio.categorias
            .where((c) => c.libros
                .where((l) =>
                    l.leido == 'NO' &&
                    l.fechInicio != '' &&
                    l.titulo.toUpperCase().contains(_toSearch.toUpperCase()))
                .toList()
                .isNotEmpty)
            .toList();
        break;
    }
    return SliverPadding(
      padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
      sliver: cats.isNotEmpty
          ? SliverList.builder(
              itemCount: cats.length,
              itemBuilder: (context, index) {
                return HomeCategoriaWidget(
                    categoria: cats[index], typeFilter: typeFilter, toSearch: _toSearch);
              },
            )
          : SliverFillRemaining(child: NotFoundWidget()),
    );
  }

  Widget autores() {
    List<Autor> auFilter = [];
    switch (typeFilter) {
      case ETypeFilter.todos:
        auFilter = servicio.autores;
        break;
      case ETypeFilter.leido:
        auFilter = servicio.autores
            .where((c) => c.libros
                .where((l) =>
                    l.leido == 'SI' && l.titulo.toUpperCase().contains(_toSearch.toUpperCase()))
                .toList()
                .isNotEmpty)
            .toList();
        break;
      case ETypeFilter.pendiente:
        auFilter = servicio.autores
            .where((c) => c.libros
                .where((l) =>
                    l.leido == 'NO' &&
                    l.fechInicio == '' &&
                    l.titulo.toUpperCase().contains(_toSearch.toUpperCase()))
                .toList()
                .isNotEmpty)
            .toList();
        break;
      case ETypeFilter.leyendo:
        auFilter = servicio.autores
            .where((c) => c.libros
                .where((l) =>
                    l.leido == 'NO' &&
                    l.fechInicio != '' &&
                    l.titulo.toUpperCase().contains(_toSearch.toUpperCase()))
                .toList()
                .isNotEmpty)
            .toList();
        break;
    }
    return SliverPadding(
      padding: const EdgeInsets.only(top: 0, left: 40, right: 20),
      sliver: auFilter.isNotEmpty
          ? SliverList.builder(
              itemCount: auFilter.length,
              itemBuilder: (context, index) => HomeAutorWidget(
                  autor: auFilter[index], typeFilter: typeFilter, toSearch: _toSearch),
            )
          : SliverFillRemaining(child: NotFoundWidget()),
    );
  }

  Widget _letras() {
    List<Autor> auFilter = [];
    switch (typeFilter) {
      case ETypeFilter.todos:
        auFilter = servicio.autores;
        break;
      case ETypeFilter.leido:
        auFilter = servicio.autores
            .where((c) => c.libros
                .where((l) =>
                    l.leido == 'SI' && l.titulo.toUpperCase().contains(_toSearch.toUpperCase()))
                .toList()
                .isNotEmpty)
            .toList();
        break;
      case ETypeFilter.pendiente:
        auFilter = servicio.autores
            .where((c) => c.libros
                .where((l) =>
                    l.leido == 'NO' &&
                    l.fechInicio == '' &&
                    l.titulo.toUpperCase().contains(_toSearch.toUpperCase()))
                .toList()
                .isNotEmpty)
            .toList();
        break;
      case ETypeFilter.leyendo:
        auFilter = servicio.autores
            .where((c) => c.libros
                .where((l) =>
                    l.leido == 'NO' &&
                    l.fechInicio != '' &&
                    l.titulo.toUpperCase().contains(_toSearch.toUpperCase()))
                .toList()
                .isNotEmpty)
            .toList();
        break;
    }
    ScrollController lettersScrollController = scrollController;

    List<String> iniciales = [];
    for (Autor a in auFilter) {
      String ini = a.name.substring(0, 1);
      if (!iniciales.contains(ini)) {
        iniciales.add(ini);
      }
    }
    iniciales.sort((a, b) => a.compareTo(b));
    return Positioned(
      left: 15,
      top: _letrasTop,
      bottom: 10,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        width: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...iniciales.map(
              (i) => InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  final contentSize = lettersScrollController.position.viewportDimension +
                      lettersScrollController.position.maxScrollExtent;
                  final target = contentSize *
                      servicio.autores.indexWhere((a) => a.name.substring(0, 1) == i) /
                      auFilter.length;
                  lettersScrollController.position.animateTo(
                    target,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                },
                child: ZoomIn(
                  delay: Duration(milliseconds: 5 * iniciales.indexOf(i)),
                  child: Center(child: Text(i, style: Utils.mainTextStyle.copyWith(fontSize: 15))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
