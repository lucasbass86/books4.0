import 'dart:convert';

import 'package:books4/models/bookcase.dart';
import 'package:books4/models/models.dart';
import 'package:books4/secret/secret.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LibraryManager extends ChangeNotifier {
  final String _urlGetBookcase = Secret.urlGetBookcase;
  final String _urlSetBookcase = Secret.urlSetBookcase;
  Shelf? _selectedShelf;
  Shelf? get selectedShelf => _selectedShelf;
  set selectedShelf(Shelf? value) {
    _selectedShelf = value;
    notifyListeners();
  }

  Shelf? _markerShelf;
  Shelf? get markerShelf => _markerShelf;
  set markerShelf(Shelf? value) {
    _markerShelf = value;
    notifyListeners();
  }

  List<Bookcase> bookcases = [];
  List<int> _searchedBooks = [];
  List<int> get searchedBooks => _searchedBooks;
  set searchedBooks(List<int> values) {
    _searchedBooks = values;
    notifyListeners();
  }

  LibraryManager() {
    loadBookcase();
  }

  void addBookcase(int shelfCount) async {
    final shelves = List.generate(
      shelfCount,
      (i) => Shelf(
        id: 'shelf_${DateTime.now().millisecondsSinceEpoch}_$i',
        position: i,
        books: [],
      ),
    );
    final bookcase = Bookcase(
      id: 'bookcase_${DateTime.now().millisecondsSinceEpoch}',
      position: bookcases.length,
      shelves: shelves,
    );
    bookcases.add(bookcase);
    await saveBookcase(bookcase);
    notifyListeners();
  }

  void addShelfToBookcase(Bookcase bookcase) async {
    final Shelf shelf = Shelf(
      id: 'shelf_${DateTime.now().millisecondsSinceEpoch}_${bookcase.shelves.length}',
      position: bookcase.shelves.length,
      books: [],
    );
    bookcase.shelves.add(shelf);
    await saveBookcase(bookcase);
    notifyListeners();
  }

  bool checkBookOnShelves(Libro libro) {
    for (Bookcase bookcase in bookcases) {
      for (Shelf shelf in bookcase.shelves) {
        if (shelf.books.any((b) => b.id == libro.codigo)) {
          return true;
        }
      }
    }
    return false;
  }

  void addBookToShelf(Bookcase bookcase, Shelf shelf, BookShelf book) async {
    shelf.books.add(book);
    await saveBookcase(bookcase);
    notifyListeners();
  }

  void rotateBook(BookShelf book) {
    book.horizontal = !book.horizontal;
    notifyListeners();
  }

  void deleteBook(Shelf shelf, BookShelf book) {
    shelf.books.remove(book);
    notifyListeners();
  }

  void moveBookBetweenShelves(BookShelf book, Shelf toShelf) {
    final fromShelf = findShelfOfBook(book);
    if (fromShelf == null || fromShelf == toShelf) return;

    fromShelf.books.remove(book);
    toShelf.books.add(book);
    notifyListeners();
  }

  void deleteShelf(Bookcase bookcase, Shelf shelf) async {
    bookcase.shelves.remove(shelf);
    if (bookcase.shelves.isEmpty) {
      bookcases.remove(bookcase);
      await saveBookcase(bookcase, delete: true);
    } else {
      await saveBookcase(bookcase);
    }
    notifyListeners();
  }

  void deleteBookcase(Bookcase bookcase) async {
    bookcases.remove(bookcase);
    await saveBookcase(bookcase, delete: true);
    notifyListeners();
  }

  Shelf? findShelfOfBook(BookShelf book) {
    for (final bookcase in bookcases) {
      for (final shelf in bookcase.shelves) {
        if (shelf.books.contains(book)) return shelf;
      }
    }
    return null;
  }

  Shelf? findShelfOfBookByID(int bookId) {
    try {
      return bookcases
          .expand((bc) => bc.shelves)
          .firstWhere((shelf) => shelf.books.any((b) => b.id == bookId));
    } catch (_) {
      return null;
    }
  }

  void moveBookInsideOrBetweenShelves(
    BookShelf book,
    Shelf targetShelf,
    int newIndex,
  ) async {
    final fromShelf = findShelfOfBook(book);

    if (fromShelf == null) return;

    final oldIndex = fromShelf.books.indexOf(book);
    fromShelf.books.removeAt(oldIndex);

    if (fromShelf == targetShelf && newIndex > oldIndex) {
      newIndex--;
    }
    targetShelf.books.insert(newIndex, book);
    await saveBookcase(bookcases.firstWhere((b) => b.shelves.any((s) => s.id == targetShelf.id)));
    notifyListeners();
  }

  void moveShelfUp(Bookcase bookcase, Shelf shelf) async {
    final shelves = bookcase.shelves;
    final index = shelves.indexOf(shelf);

    if (index <= 0) return; // no se puede subir más

    shelves.removeAt(index);
    shelves.insert(index - 1, shelf);

    // normalizar posiciones
    for (int i = 0; i < shelves.length; i++) {
      shelves[i].position = i;
    }
    await saveBookcase(bookcase);
    notifyListeners();
  }

  void moveShelfDown(Bookcase bookcase, Shelf shelf) async {
    final shelves = bookcase.shelves;
    final index = shelves.indexOf(shelf);

    if (index >= shelves.length - 1) return; // no se puede bajar más

    shelves.removeAt(index);
    shelves.insert(index + 1, shelf);

    // normalizar posiciones
    for (int i = 0; i < shelves.length; i++) {
      shelves[i].position = i;
    }
    await saveBookcase(bookcase);
    notifyListeners();
  }

  void moveBookcaseLeft(Bookcase bookcase) async {
    final index = bookcases.indexOf(bookcase);

    if (index <= 0) return; // no se puede subir más

    bookcases.removeAt(index);
    bookcases.insert(index - 1, bookcase);

    // normalizar posiciones
    for (int i = 0; i < bookcases.length; i++) {
      bookcases[i].position = i;
    }
    await saveBookcase(bookcase);
    notifyListeners();
  }

  void moveBookcaseRight(Bookcase bookcase) async {
    final index = bookcases.indexOf(bookcase);

    if (index >= bookcases.length - 1) return; // no se puede bajar más

    bookcases.removeAt(index);
    bookcases.insert(index + 1, bookcase);

    // normalizar posiciones
    for (int i = 0; i < bookcases.length; i++) {
      bookcases[i].position = i;
    }
    await saveBookcase(bookcase);
    notifyListeners();
  }

  Future<void> saveBookcase(Bookcase bookcase, {bool delete = false}) async {
    final jsonString = jsonEncode(bookcase.toJson());
    await http.post(
      Uri.parse(_urlSetBookcase),
      body: {
        "bookcase_id": bookcase.id,
        "json": jsonString,
        "delete": delete ? 'true' : '',
      },
    );
  }

  Future<void> loadBookcase() async {
    final response = await http.get(Uri.parse(_urlGetBookcase));
    bookcases = bookcaseFromJson(response.body);
    bookcases.sort((a, b) => a.position.compareTo(b.position));
    notifyListeners();
  }
}
