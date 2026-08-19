import 'package:books4/models/bookcase.dart';
import 'package:books4/providers/librarymanager.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/estanterias/shelf_widget.dart';
import 'package:flutter/material.dart';

class BookcaseTabWidget extends StatelessWidget {
  final LibraryManager manager;
  final Bookcase bookcase;

  const BookcaseTabWidget({
    super.key,
    required this.manager,
    required this.bookcase,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: bookcase.shelves.length,
      itemBuilder: (context, index) {
        final shelf = bookcase.shelves[index];
        return Column(
          children: [
            if (index == 0)
              Container(
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Utils.circulo3,
                ),
              ),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 140,
                  decoration: BoxDecoration(color: Utils.circulo3),
                ),
                Expanded(
                  child: ShelfWidget(
                    manager: manager,
                    bookcase: bookcase,
                    shelf: shelf,
                  ),
                ),
                Container(
                  width: 10,
                  height: 140,
                  decoration: BoxDecoration(color: Utils.circulo3),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(index == bookcase.shelves.length - 1 ? 20 : 0),
                  bottomRight: Radius.circular(index == bookcase.shelves.length - 1 ? 20 : 0),
                ),
                color: Utils.circulo3,
              ),
            ),
          ],
        );
      },
    );
  }
}
