import 'package:books4/dialogs/dialogs.dart';
import 'package:books4/models/bookcase.dart';
import 'package:books4/models/models.dart';
import 'package:books4/providers/librarymanager.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/debouncer.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EstanteriasPage extends StatefulWidget {
  static const String routeName = 'EstanteriasPage';
  const EstanteriasPage({super.key});

  @override
  State<EstanteriasPage> createState() => _EstanteriasPageState();
}

class _EstanteriasPageState extends State<EstanteriasPage> {
  final PageController pageController = PageController();
  late Servicio servicio;
  late LibraryManager manager;
  int page = 0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        page = pageController.page!.round();
        manager.selectedShelf = manager.bookcases[page].shelves.first;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    servicio = Provider.of<Servicio>(context);
    manager = Provider.of<LibraryManager>(context);
    return Scaffold(
      floatingActionButton: _fab(context),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.globalPosition.dx < 30) {
            Navigator.pop(context);
          }
        },
        child: Column(
          children: [
            TopWigdet(
              title: 'Estanterías',
              showBack: true,
              showSearch: true,
              onSearch: (value) {
                if (value.isEmpty) {
                  manager.searchedBooks = [];
                  return;
                }
                manager.searchedBooks = servicio.libros
                    .where((i) =>
                        i.autor.toUpperCase().contains(value.toUpperCase()) ||
                        i.titulo.toUpperCase().contains(value.toUpperCase()))
                    .map((e) => e.codigo)
                    .toList();
              },
              onCloseSearch: () => manager.searchedBooks = [],
            ),
            manager.bookcases.isEmpty ? _noData() : _data(),
            _points(),
          ],
        ),
      ),
    );
  }

  Widget _data() {
    return Expanded(
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        controller: pageController,
        itemCount: manager.bookcases.length,
        itemBuilder: (context, index) {
          final bookcase = manager.bookcases[index];
          return BookcaseTabWidget(manager: manager, bookcase: bookcase);
        },
      ),
    );
  }

  Widget _noData() {
    return Expanded(
      child: Center(
          child: Text(
        'No hay estanterías',
        style: TextStyle(fontSize: 25, color: Utils.circulo3),
      )),
    );
  }

  Widget _fab(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (manager.bookcases.isNotEmpty)
          FloatingActionButton(
            heroTag: 'addBook',
            mini: true,
            backgroundColor: Utils.circulo3,
            shape: StadiumBorder(),
            onPressed: () async {
              final List<Libro>? libros = await _searchBook(context);
              if (libros != null) {
                for (Libro l in libros) {
                  if (!manager.checkBookOnShelves(l)) {
                    final bookcase = manager.bookcases[page];
                    final book = BookShelf(
                        id: l.codigo,
                        path: Utils.getImgURL(l.codigo),
                        position: manager.selectedShelf!.books.isEmpty
                            ? 1
                            : manager.selectedShelf!.books.length + 1);
                    manager.addBookToShelf(
                        bookcase, manager.selectedShelf ?? bookcase.shelves.first, book);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(Utils.snackBar('Libro ya colocado . . . ', isGood: false));
                    }
                  }
                }
              }
            },
            child: Icon(Icons.book),
          ),
        FloatingActionButton(
          heroTag: 'addBookcase',
          backgroundColor: Utils.circulo1,
          shape: StadiumBorder(),
          onPressed: () async {
            final resp = await inputBox(context, 'Indica las baldas',
                textInputType: TextInputType.number, textAlign: TextAlign.center);
            if (resp[0]) {
              manager.addBookcase(int.parse(resp[1]));
            }
          },
          child: Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _points() {
    if (manager.bookcases.length == 1) return SizedBox.shrink();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 10,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: manager.bookcases.length,
          itemBuilder: (context, index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 800),
              margin: const EdgeInsets.only(right: 5),
              width: index == page ? 20 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: Utils.circulo3,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<Libro>?> _searchBook(BuildContext context) {
    final searchController = TextEditingController();
    List<Libro> libros = [];
    List<Libro> selection = [];

    return showModalBottomSheet<List<Libro>?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.4,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Utils.circulo1,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Agregar libro',
                            style: TextStyle(
                                color: Utils.circulo1, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context, selection),
                            child: Row(
                              spacing: 5,
                              children: [
                                Icon(Icons.check_rounded),
                                Text(
                                  '${selection.length} libros',
                                  style: TextStyle(color: Utils.circulo3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: searchController,
                        maxLines: 1,
                        style: Utils.mainTextStyle,
                        textCapitalization: TextCapitalization.characters,
                        onChanged: (value) {
                          Debouncer().run(() {
                            setState(() {
                              if (value.isEmpty) {
                                libros = [];
                              } else {
                                final query = value.toUpperCase();
                                libros = servicio.libros
                                    .where((l) =>
                                        l.autor.toUpperCase().contains(query) ||
                                        l.titulo.toUpperCase().contains(query))
                                    .toList();
                              }
                            });
                          });
                        },
                        decoration: InputDecoration(
                          prefixIconColor: Utils.circulo1,
                          fillColor: Utils.circulo1.withAlpha(50),
                          filled: true,
                          hintText: "Buscar libros...",
                          hintStyle: TextStyle(fontSize: 13, color: Utils.circulo1),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Utils.circulo3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(Utils.iconSearch),
                          suffixIcon: searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    searchController.clear();
                                    setState(() {
                                      libros = [];
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: const Icon(Icons.clear),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: libros.isEmpty
                            ? const Center(child: Text('Buscar...'))
                            : ListView.builder(
                                controller: scrollController,
                                physics: const BouncingScrollPhysics(),
                                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: libros.length,
                                itemBuilder: (context, index) {
                                  final Libro libro = libros[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    onTap: () {
                                      if (selection.contains(libro)) {
                                        selection.remove(libro);
                                      } else {
                                        selection.add(libro);
                                      }
                                      setState(
                                        () {},
                                      );
                                    },
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                        imageUrl: Utils.getImgURL(libro.codigo),
                                        width: 45,
                                        fit: BoxFit.fitWidth,
                                        placeholder: (context, url) => SizedBox(
                                          width: 45,
                                          child: Center(
                                            child: CircularProgressIndicator(color: Utils.circulo4),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Utils.noImage,
                                        imageBuilder: (context, imageProvider) {
                                          return Image(
                                            image: imageProvider,
                                            width: 45,
                                            fit: BoxFit.fitWidth,
                                          );
                                        },
                                      ),
                                    ),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          libro.titulo,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white.withAlpha(200),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          libro.autor,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white.withAlpha(200),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Icon(
                                      selection.contains(libro)
                                          ? Icons.check_box_outlined
                                          : Icons.check_box_outline_blank_rounded,
                                      color: Utils.circulo3,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
