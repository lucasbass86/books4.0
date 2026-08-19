import 'package:books4/dialogs/dialogs.dart';
import 'package:books4/models/bookcase.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/providers/librarymanager.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/estanterias/bookshelf_widget.dart';
import 'package:flutter/material.dart';

class ShelfWidget extends StatefulWidget {
  final LibraryManager manager;
  final Bookcase bookcase;
  final Shelf shelf;

  const ShelfWidget({
    super.key,
    required this.manager,
    required this.bookcase,
    required this.shelf,
  });

  @override
  State<ShelfWidget> createState() => _ShelfWidgetState();
}

class _ShelfWidgetState extends State<ShelfWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.manager,
      builder: (_, __) {
        return GestureDetector(
          onTap: () {
            if (widget.manager.selectedShelf != widget.shelf) {
              widget.manager.selectedShelf = widget.shelf;
            } else {
              widget.manager.selectedShelf = null;
            }
          },
          onLongPress: () => _showMenuShelf(),
          child: Container(
            height: 140,
            padding: const EdgeInsets.all(8),
            color: widget.manager.searchedBooks.isNotEmpty &&
                    widget.shelf.books.any((b) => widget.manager.searchedBooks.contains(b.id))
                ? widget.manager.selectedShelf != widget.shelf
                    ? Utils.darken(Utils.colorDot, 0.4)
                    : Utils.colorDot
                : widget.manager.selectedShelf == widget.shelf
                    ? Utils.circulo4
                    : Utils.circulo1,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 10,
                children: [
                  ..._buildBookTargets(context),
                  DragTarget<BookShelf>(
                    onWillAcceptWithDetails: (_) => true,
                    onAcceptWithDetails: (book) {
                      widget.manager.moveBookInsideOrBetweenShelves(
                        book.data,
                        widget.shelf,
                        widget.shelf.books.length,
                      );
                    },
                    builder: (_, __, ___) => const SizedBox(width: 30, height: 120),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildBookTargets(BuildContext context) {
    return List.generate(widget.shelf.books.length, (index) {
      final book = widget.shelf.books[index];

      return DragTarget<BookShelf>(
        onWillAcceptWithDetails: (_) => true,
        onAcceptWithDetails: (draggedBook) {
          widget.manager.moveBookInsideOrBetweenShelves(
            draggedBook.data,
            widget.shelf,
            index,
          );
        },
        builder: (_, __, ___) {
          return Draggable<BookShelf>(
            data: book,
            feedback: BookShelfWidget(book: book),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: BookShelfWidget(book: book),
            ),
            child: GestureDetector(
              onLongPress: () => _showMenu(context, widget.manager, widget.shelf, book),
              child: BookShelfWidget(book: book),
            ),
          );
        },
      );
    });
  }

  void _showMenu(
    BuildContext context,
    LibraryManager manager,
    Shelf shelf,
    BookShelf book,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'Ir a la ficha',
                style: TextStyle(color: Utils.circulo3),
              ),
              trailing: Icon(
                Icons.book,
                color: Utils.circulo3,
              ),
              onTap: () async {
                Servicio servicio = Provider.of(context, listen: false);
                await Navigator.pushNamed(context, LibroPage.routeName,
                    arguments: servicio.libros.firstWhere((e) => e.codigo == book.id));
                if (context.mounted) Navigator.pop(context);
              },
            ),
            ListTile(
              trailing: Icon(
                  book.horizontal
                      ? Icons.rotate_90_degrees_cw_rounded
                      : Icons.rotate_90_degrees_ccw_rounded,
                  color: Utils.circulo3),
              title: Text(
                'Girar',
                style: TextStyle(color: Utils.circulo3),
              ),
              onTap: () {
                manager.rotateBook(book);
                Navigator.pop(context);
              },
            ),
            ListTile(
              trailing: Icon(
                Icons.delete,
                color: Colors.red[200],
              ),
              title: Text(
                'Eliminar',
                style: TextStyle(color: Utils.circulo3),
              ),
              onTap: () {
                manager.deleteBook(shelf, book);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMenuShelf() {
    widget.manager.selectedShelf = widget.shelf;
    bool canUp = widget.shelf.position > 0;
    bool canDown = widget.shelf.position < widget.bookcase.shelves.length - 1;
    bool canLeft = widget.bookcase.position > 0;
    bool canRight = widget.bookcase.position < widget.manager.bookcases.length - 1;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              ListTile(
                title: Text('Agregar balda', style: TextStyle(color: Utils.circulo3)),
                trailing: Icon(
                  Icons.book,
                  color: Utils.circulo3,
                ),
                onTap: () {
                  widget.manager.addShelfToBookcase(widget.bookcase);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Balda añadida'));
                },
              ),
              if (canDown || canUp) Divider(color: Utils.circulo2),
              Row(
                children: [
                  if (canUp)
                    Expanded(
                      child: ListTile(
                        title: Text('Subir', style: TextStyle(color: Utils.circulo3)),
                        trailing: Icon(
                          Icons.arrow_drop_up_rounded,
                          color: Utils.circulo3,
                        ),
                        onTap: () {
                          widget.manager.moveShelfUp(widget.bookcase, widget.shelf);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(Utils.snackBar('Balda subida'));
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  if (canDown)
                    Expanded(
                      child: ListTile(
                        title: Text('Bajar', style: TextStyle(color: Utils.circulo3)),
                        trailing: Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Utils.circulo3,
                        ),
                        onTap: () {
                          widget.manager.moveShelfDown(widget.bookcase, widget.shelf);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(Utils.snackBar('Balda bajada'));
                          Navigator.pop(context);
                        },
                      ),
                    ),
                ],
              ),
              Divider(color: Utils.circulo2),
              ListTile(
                title: Text('Eliminar balda', style: TextStyle(color: Utils.circulo3)),
                trailing: Icon(
                  Icons.delete_rounded,
                  color: Colors.red[200],
                ),
                onTap: () async {
                  final resp = await showMessage(
                      context: context,
                      message: 'Se eliminarán los libros de esta balda. ¿Continuar?',
                      cancel: true);
                  if (resp && context.mounted) {
                    widget.manager.deleteShelf(widget.bookcase, widget.shelf);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Balda borrada'));
                  }
                },
              ),
              Divider(color: Utils.circulo3, thickness: 2),
              Row(
                children: [
                  if (canLeft)
                    Expanded(
                      child: ListTile(
                        title: Text('Izquierda', style: TextStyle(color: Utils.circulo3)),
                        trailing: Icon(
                          Icons.arrow_left_rounded,
                          color: Utils.circulo3,
                        ),
                        onTap: () {
                          widget.manager.moveBookcaseLeft(widget.bookcase);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(Utils.snackBar('Estantería movida a la izquierda'));
                        },
                      ),
                    ),
                  if (canRight)
                    Expanded(
                      child: ListTile(
                        title: Text('Derecha', style: TextStyle(color: Utils.circulo3)),
                        trailing: Icon(
                          Icons.arrow_right_rounded,
                          color: Utils.circulo3,
                        ),
                        onTap: () {
                          widget.manager.moveBookcaseRight(widget.bookcase);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(Utils.snackBar('Estantería movida a la derecha'));
                        },
                      ),
                    ),
                ],
              ),
              if (canLeft || canRight) Divider(color: Utils.circulo2),
              ListTile(
                title: Text('Eliminar estantería', style: TextStyle(color: Utils.circulo3)),
                trailing: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red[200],
                ),
                onTap: () async {
                  final resp = await showMessage(
                      context: context, message: '¿Eliminar todos los libros?', cancel: true);
                  if (resp && context.mounted) {
                    widget.manager.deleteBookcase(widget.bookcase);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(Utils.snackBar('Estantería eliminada'));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
