import 'dart:convert';

class BookShelf {
  final int id;
  final String path;
  bool horizontal;
  int position; // 👈 NUEVO

  BookShelf({
    required this.id,
    required this.path,
    this.horizontal = false,
    required this.position,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "path": path,
        "horizontal": horizontal,
        "position": position,
      };

  factory BookShelf.fromJson(Map<String, dynamic> json) => BookShelf(
        id: json["id"],
        path: json["path"],
        horizontal: json["horizontal"],
        position: json["position"],
      );
}

class Shelf {
  final String id;
  int position;
  final List<BookShelf> books;

  Shelf({
    required this.id,
    required this.position,
    required this.books,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position,
        "books": List<dynamic>.from(books.map((x) => x.toJson())),
      };

  factory Shelf.fromJson(Map<String, dynamic> json) => Shelf(
        id: json["id"],
        position: json["position"],
        books: List<BookShelf>.from(json["books"].map((x) => BookShelf.fromJson(x))),
      );
}

List<Bookcase> bookcaseFromJson(String str) =>
    List<Bookcase>.from(json.decode(str).map((x) => Bookcase.fromJson(x)));

class Bookcase {
  final String id;
  int position;
  final List<Shelf> shelves;

  Bookcase({
    required this.id,
    required this.position,
    required this.shelves,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position,
        "shelves": List<dynamic>.from(shelves.map((x) => x.toJson())),
      };

  factory Bookcase.fromJson(Map<String, dynamic> json) => Bookcase(
        id: json["id"],
        position: json["position"],
        shelves: List<Shelf>.from(json["shelves"].map((x) => Shelf.fromJson(x))),
      );
}
