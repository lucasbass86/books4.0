import 'package:books4/models/bookcase.dart';
import 'package:books4/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookShelfWidget extends StatelessWidget {
  final BookShelf book;
  const BookShelfWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    const double spineW = 40;
    const double spineH = 120;
    Widget image = CachedNetworkImage(
      imageUrl: book.path,
      fit: BoxFit.cover,
      width: spineW,
      height: spineH,
      placeholder: (context, url) => SizedBox(
        width: spineW,
        child: Center(
          child: CircularProgressIndicator(
            color: Utils.circulo4,
          ),
        ),
      ),
    );
    if (book.horizontal) {
      image = RotatedBox(
        quarterTurns: 3,
        child: image,
      );
    }
    return Container(
      child: image,
    );
  }
}
